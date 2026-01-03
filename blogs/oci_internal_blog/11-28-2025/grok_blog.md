# Partner Diagnostics, Field Diagnostic Tool, and Universal FDT  
## A Practical Guide for OCI Engineers Supporting GB200 NVL72 & Other GPU Shapes  
*(Restarted & Fully Rewritten – November 28, 2025)*

---

### 1. Introduction

This is the single, actionable reference OCI engineers use when running or triaging NVIDIA diagnostics on GB200 NVL72 racks, HGX H100/H200/B200 nodes, or individual GPUs.

Everything below is distilled from the authoritative sources you already have access to:

- NVIDIA Partner Diagnostics User Guide (DU-11965-001_20)  
- Debug and RAS Guide (DA-11437-001_v13)  
- GB200 NVL72 System Validation Guide (VG-12022-001_v09)  
- OCI internal runbook: how-to-handle-fdt-fails-for-shape-gb200.md  
- burn-in-orchestrator & oci-dr-hpc-v2 repositories  

If something contradicts the latest runbook or DA-11437, the runbook wins.

---

### 2. The Three Diagnostic Tools – Quick Mapping

| Tool Name               | Binary        | Primary Use Case                              | Scope                     | Typical OCI Usage                     |
|-------------------------|---------------|-----------------------------------------------|---------------------------|---------------------------------------|
| Partner Diagnostics     | partnerdiag   | Rack-level & multi-node (GB200 NVL72, HGX-8)  | L10 tray / L11 rack       | CPV burn-in, IBE, rack validation    |
| Field Diagnostics (FDT) | fieldiag      | Single-GPU / single-node deep stress          | One GPU or one tray       | Isolation testing, post-firmware check |
| Universal FDT           | fieldiag      | Same as FDT but unified package (Ampere → Blackwell) | One GPU or one tray | Preferred for mixed-architecture fleets |

All three are built on the same MODS framework and share the same error code catalog.

---

### 3. Running Diagnostics – Canonical Commands

#### 3.1 GB200 NVL72 (18 compute trays + 9 NVSwitch trays)

**Prerequisite:** All 18 compute trays must pass L10 before attempting L11.

```bash
# Field Level 1 – shorter (~2–3 h for full rack)
./partnerdiag --field --level1 --primary_diag_ip=<PRIMARY_HOST_IP>

# Field Level 2 – comprehensive (~4–6 h for full rack)
./partnerdiag --field --level2 --primary_diag_ip=<PRIMARY_IP>
```

Manufacturing mode (only during bring-up, never in CPV):

```bash
# Compute trays
./partnerdiag --mfg --run_spec=spec_gb200_nvl_72_2_4_compute_nodes_partner_mfg.json --primary_diag_ip=<IP>

# Switch trays
./partnerdiag --mfg --run_spec=spec_gb200_nvl_72_2_4_switch_nodes_partner_mfg.json --primary_diag_ip=<IP>
```

#### 3.2 HGX-8 Nodes (H100, H200, GB200 HGX-8)

```bash
# Field diagnostics (default = Level 2)
sudo ./partnerdiag --field --run_on_error --no_bmc

# Level 1 only (faster)
sudo ./partnerdiag --field --level1 --run_on_error --no_bmc

# Specific tests only
sudo ./partnerdiag --field --test=pcie,connectivity --run_on_error --no_bmc
```

#### 3.3 Single GPU / Universal FDT

```bash
sudo ./fieldiag                     # all GPUs
sudo ./fieldiag device=0            # specific GPU
sudo ./fieldiag only_nvlink         # NVLink-only
sudo ./fieldiag BS_Test             # quick health check
```

Return codes: 0 = PASS | 1 = FAIL | 2 = RETEST (environment/pre-check issue)

---

### 4. Test Coverage & Approximate Durations (GB200 NVL72)

| Test                     | L10 L1 | L10 L2 | L11 Rack | Approx Duration |
|--------------------------|--------|--------|----------|-----------------|
| Connectivity             | Yes    | Yes    | Yes      | 12–16 min       |
| NvlBwStress              | Yes    | Yes    | Yes      | ~21 min         |
| ThermalSteadyState       | Yes    | Yes    | Yes      | 15–22 min       |
| CpuGpuSyncPulsePower     | Yes    | Yes    | Yes      | 20–23 min       |
| Gpustress                | Yes    | Yes    | No       | ~4 min          |
| Gpumem                   | Yes    | Yes    | No       | ~1 min          |
| Pcie                     | Yes    | Yes    | No       | ~6 min          |

---

### 5. MODS Error Codes – OCI Action Matrix (2025)

Only the last 3 digits matter (e.g., MODS-XXXXXXXXX083 → 083)

| Category                    | Codes                              | OCI Action                                                                 |
|-----------------------------|------------------------------------|-----------------------------------------------------------------------------|
| Non-RMA (software/config)   | 002, 008, 021, 077, 144, 240, 272, 318, 779, 818 | Update FDT + recipe → retest → NVBug if persistent                         |
| RMA-eligible (GPU/memory)   | 083, 097, 194, 276, 316–321, 341, 363, 539, 541, 582, 774 | Firmware check → retest → RMA if repeat                                    |
| NVLink / Fabric             | 014, 140, 688                     | Treat as rack-level issue → follow NVLink checklist (never reseat blindly) |

Full mapping is maintained in oci-dr-hpc-v2 and the internal runbook.

---

### 6. Critical OCI Guardrails (Memorize These)

1. **Never reseat GB200 compute or switch trays**  
   → Bends NVLink pins → permanent damage (explicit NVIDIA + OCI rule)

2. **Recipe alignment is the #1 root cause**  
   → Driver, firmware, fabric-manager, OS image must match the golden recipe

3. **FDT ≠ RDMA**  
   → NVLink failures in FDT do **not** justify cutting RDMA DO tickets

4. **L11 requires clean L10 on all 18 trays**  
   → Partial rack runs produce false NVLink failures

5. **Always check XID errors in dmesg first**  
   → XID 48, 63, 74, 109 are usually more authoritative than MODS

---

### 7. Log Locations & Recovery

```text
/local/FDT/<build>/dgx/logs-YYYYMMDD-HHMMSS/
├── fieldiag_summary.log      ← start here
├── <test_id>/
│   └── <PCI_ADDR_SN>/
│       ├── fieldiag.log
│       └── fieldiag.json
└── COMPUTE_NODE_X/connectivity/
```

If /local is missing after power cycle:

```bash
ls /dev | grep md
sudo mount /dev/md0 /local   # or md127, etc.
```

---

### 8. Quick Triage Decision Tree

```
Any XID in dmesg? → Yes → Collect nvidia-bug-report.sh → RHS / GPUPR

No XID → NVLink MODS (014/140/688)? → Yes → Run NVLink checklist (recipe, GUIDs, FM logs)

No NVLink → RMA-eligible MODS? → Yes → RMA tray/GPU

No → Non-RMA MODS → Update FDT + recipe → retest
```

---

### 9. Useful One-Liners

```bash
# GPU + fabric GUID inventory
nvidia-smi -q | egrep "GPU 000|Module Id|Serial Number|Fabric GUID"

# Fabric registration health
nvidia-smi -q | grep -A9 Fabric

# Full NVLink status
nvidia-smi nvlink --status

# Generate full debug bundle
sudo nvidia-bug-report.sh
```

---

### 10. OCI Automation References (Internal Only)

- Burn-in Orchestrator → https://github.com/rikkisnah/burn-in-orchestrator  
- GB200 FDT Parser & Triage Engine → https://github.com/ai2-compute-gpu/oci-dr-hpc-v2  

These repos contain the exact invocation patterns, spec generation, and MODS-to-recommendation logic used in production CPV.

---

### 11. Conclusion

Mastering Partner Diagnostics, FDT, and Universal FDT — plus the OCI-specific guardrails above — is mandatory for anyone touching GB200 NVL72 racks or modern GPU shapes. When in doubt:  
1. Check recipe alignment  
2. Check XIDs  
3. Never reseat  
4. Escalate early with full logs

Questions? Ping #cpv-triage or #gpu-infra-ai2-compute.

*Happy diagnosing — and keep those trays seated!*