Partner Diagnostics and Universal FDT for GB200 NVL72 and Other GPU Shapes

NVIDIA Partner Diagnostics (Partner Diag), Field Diagnostic Tool (FDT), and Universal FDT are the primary hardware validation tools OCI uses to qualify and triage GPU infrastructure across GB200 NVL72 racks, HGX-8 systems, and single-GPU configurations. These tools exercise GPUs, Grace CPUs, NVLink, PCIe, power, thermal behavior, and system firmware, and their MODS error codes tie directly into the NVIDIA Debug and RAS Guide and OCI’s GB200 FDT triage runbooks.[1][2]

## What Partner Diag and FDT Are

Partner Diagnostics and Field Diagnostics are NVIDIA’s official hardware diagnostics built on the MODS test framework to validate GPUs and NVLink fabrics in the field and in manufacturing. In practice you will see several names—partnerdiag, fieldiag, FDT, Field Diagnostics, and OneDiag—but they all refer to the same underlying MODS-based infrastructure with different packaging and topology scopes.[2][1]

- Single-GPU Field Diagnostics (“fieldiag” / FDT) runs on individual GPUs (A100, H100, B200, etc.) and focuses on GPU-local compute, memory, PCIe, and limited NVLink checks.[1]
- Partner Diagnostics (“partnerdiag”) is the system-level test for multi-GPU platforms such as HGX-8 and GB200 NVL72, adding cross-GPU NVLink, rack-level stress, and topology validation.[3][2]
- Universal FDT is a consolidated package that supports multiple architectures (Ampere, Hopper, Blackwell) from a single binary and SKU map, simplifying deployment across mixed fleets.[1]

From an OCI perspective, Partner Diag and Universal FDT are the authoritative signal for hardware health in CPV and IBE workflows, and their MODS and DGX codes are interpreted using the Debug and RAS Guide (DA‑11437) and the GB200 FDT failure runbook.[2][1]

## GB200 NVL72: L10 vs L11 and Execution Modes

GB200 NVL72 racks introduce two diagnostic levels: L10 compute tray tests (per host) and L11 rack-level tests across all 18 compute trays and 9 NVSwitch trays. L10 validates each tray’s GPUs, Grace CPU, local NVLink, and IO; L11 validates the full NVLink fabric, cross-node connectivity, and rack-level power and thermal behavior.[3][1]

Partner Diag on GB200 NVL72 can run in self-hosted or managed modes.[3]
- Self-hosted mode runs the partnerdiag binary from a primary node and automatically stages diagnostics on secondary nodes via SSH, which is simpler operationally.  
- Managed mode uses a dedicated orchestrator or external controller to push binaries, specs, and jobs, which gives more control over job scheduling and log handling at the cost of extra setup.[3]

Typical GB200 Partner Diag invocations:

```bash
# GB200 NVL72 Field Level 1 (L11 short)
./partnerdiag --field --level1 --primary_diag_ip=<IP>

# GB200 NVL72 Field Level 2 (L11 comprehensive)
./partnerdiag --field --level2 --primary_diag_ip=<IP>

# Manufacturing diagnostics – switch trays
./partnerdiag --mfg \
  --run_spec=spec_gb200_nvl_72_2_4_switch_nodes_partner_mfg.json \
  --primary_diag_ip=<IP>

# Manufacturing diagnostics – compute trays
./partnerdiag --mfg \
  --run_spec=spec_gb200_nvl_72_2_4_compute_nodes_partner_mfg.json \
  --primary_diag_ip=<IP>
```

These commands align with the GB NVL72 System Validation Guide and the Partner Diagnostics user guide, which define L10/L11 scopes and recommended test flows.[2][3]

Pro Tip: Always confirm the rack firmware bundle matches the HOPS-pinned “golden” recipe and the NVIDIA GB200 NVL validation guidance before running L10/L11; many false positives are recipe drift rather than hardware defects.[1][3]

## Hopper/Blackwell HGX-8 and Other Shapes

For Hopper/Blackwell HGX-8 nodes, Partner Diag runs at single-node scope with a similar CLI but HGX-specific spec files. Common patterns:[2]

```bash
# HGX-8 manufacturing validation
sudo ./partnerdiag --mfg \
  --run_spec=spec_blackwell-hgx-8-gpu_partner_mfg.json \
  --run_on_error --no_bmc

# HGX-8 field diagnostics
sudo ./partnerdiag --field --run_on_error --no_bmc

# HGX-8 targeted tests
sudo ./partnerdiag --field --run_on_error --no_bmc --test=pcie,connectivity
```

Single-GPU Field Diag / Universal FDT is used for card-level or single-node triage across Ampere, Hopper, and Blackwell GPUs. Typical usage:[1]

```bash
# Run on all detected GPUs
sudo ./fieldiag

# Run on a specific GPU
sudo ./fieldiag device=0

# Only NVLink tests
sudo ./fieldiag only_nvlink

# Quick basic system test
sudo ./fieldiag BS_Test
```

The Universal FDT guide lists supported SKUs including A100/A40/A30/A10/A2, H100/H200/H800, and B200/GB200, and documents standardized return codes used by Partner Diag and OCI triage tooling.[1]

Pro Tip: FDT and Partner Diag do not exercise RDMA links—do not cut DO tickets for RDMA cabling based solely on FDT failures; RDMA is covered by mlx checks, cable validation, and WPA tests instead.[1]

## Test Coverage and Typical Durations

Partner Diag test bundles combine connectivity, stress, and thermal tests at both L10 and L11 levels. The table below summarizes commonly used GB200 NVL72 tests and approximate field durations.[2][3]

GB200 NVL72 Partner Diag Tests

| Test Name             | L10 Level 1 | L10 Level 2 | L11 Rack | Approx. Duration | Description                                   |
|-----------------------|-------------|-------------|----------|------------------|-----------------------------------------------|
| Connectivity          | ✓           | ✓           | ✓        | ~12–16 min       | NVLink and PCIe link and bandwidth checks.[2] |
| NvlBwStress           | ✓           | ✓           | ✓        | ~21 min          | Cross-GPU NVLink bandwidth stress.[2] |
| ThermalSteadyState    | ✓           | ✓           | ✓        | ~15–22 min       | CPU+GPU steady-state power/thermal stress.[3] |
| CpuGpuSyncPulsePower  | ✓           | ✓           | ✓        | ~20–23 min       | Pulsed workload to stress power delivery.[3] |
| Gpustress             | ✓           | ✓           | –        | ~4 min           | GPU compute and ALU stress.[2] |
| Gpumem                | ✓           | ✓           | –        | ~1 min           | GPU memory pattern and ECC checks.[2] |
| Pcie                  | ✓           | ✓           | –        | ~6 min           | PCIe bandwidth and link integrity tests.[3] |

In OCI CPV, L10 is generally run once trays are provisioned and healthy at the host level, while L11 is reserved for racks that have passed L10 across all trays, to avoid chasing cascaded fabric failures.[1]

## MODS Error Codes: Structure and Categories

Partner Diag and FDT encode failures as MODS and DGX error codes, which are mapped to actions in the Debug and RAS Guide (DA‑11437‑001). MODS codes follow the pattern:[2]

- MODS-xxxxxxxxx###  
  - xxxxxxxxx = test or context identifier  
  - ### = numeric error code that determines root cause and action.[2][1]

At a high level, OCI groups MODS codes into:

- Non‑RMA‑eligible (primarily software, configuration, or environment issues).  
- RMA‑eligible hardware failures (GPU, memory, or baseboard defects).  
- NVLink-related failures that require fabric-level triage.[2][1]

Representative mappings (GPU Field Diag / L10 perspective):

- Non‑RMA‑eligible / configuration-like:  
  - 002: Software error – often resolved by updating FDT and firmware; escalate as NVBug only if persistent.[1][2]
  - 008: Bad parameter passed to function – indicates tool or invocation issue; retest on latest diag.[2][1]
  - 021: Script failed to execute – usually environment or software packaging issue; retest and file NVBug if it repeats.[1][2]
  - 077: Timeout error – can reflect software or marginal hardware; DA‑11437 recommends firmware verification, retest, and then device triage.[2][1]
  - 144: CUDA error – treat as software or driver issue unless reproducible under latest firmware and diag.[1][2]

- Clearly RMA‑oriented hardware failures:  
  - 083: CRC/Checksum miscompare – repeated failures after firmware and diag update typically qualify for RMA.[2][1]
  - 097: Unexpected device interrupts – indicative of unstable hardware signaling; RMA after basic checks.[1][2]
  - 194: Bad memory – compute returning incorrect results; RMA if persistent.[2][1]
  - 316–321: ECC over-threshold or uncorrectable in FB/L2/SM – row remap and retest, then RMA if errors continue.[1][2]
  - 363: Row remapping failed – DA‑11437 flags this for RMA once firmware and diag are current.[2][1]

- NVLink-specific:  
  - 140: NVLink bus error – NVLink is down or experiencing errors; DA‑11437 suggests checking topology, link enumeration, and potentially reseating in generic guidance, but OCI overrides reseat behavior for GB200 as noted below.[1][2]
  - 688: NVRM invalid state/config – often fabric manager or NVSwitch configuration issues; requires checking NVSwitch controller and fabric manager logs.[2][1]

OCI’s GB200 GB300 runbook overlays its own action categories (Non‑RMA‑eligible, Non‑NVLink RMA‑eligible, NVLink-related, Other Non‑NVLink) on top of DA‑11437 to align with internal workflows and GPUPR automation.[1]

Pro Tip: When multiple MODS codes appear in a single FDT run, treat only one or two as probable root causes and the rest as symptoms; the GB200 runbook provides an explicit priority order for which categories to address first.[1]

## GB200 FDT Log Locations and Structure

For GB200 NVL72, Partner Diag and FDT logs are collected under a standard directory tree on the local diagnostic SSD and then archived to OCI Object Storage.[1]

Typical local paths:

```text
/local/FDT/629.../dgx/logs-<yyyymmdd>-<hhmmss>/
├── fieldiag_summary.log        # High-level test summary and MODS/DGX codes
├── <test_id>/
│   └── <GPU_PCI_ADDR_GPU_SN>/
│       ├── fieldiag.log        # Detailed per-GPU test log
│       └── fieldiag.json       # Machine-readable results
└── COMPUTE_NODE_X/
    └── connectivity/
        └── ...                 # Multi-node and NVLink tests
```

If the host has been power-cycled after CPV, /local may not be mounted; the runbook recommends discovering the md device and mounting it manually:

```bash
ls /dev | grep -i md
sudo mount /dev/md0 /local
cd /local/FDT
```

The runbook also documents detailed per-test log file patterns for single-node tests and multi-node connectivity tests, which OCI DR HPC v2 uses to locate and parse logs programmatically.[1]

Pro Tip: fieldiag_summary.log is the primary starting point for triage and for automation—use that file first to extract MODS codes, test IDs, and timestamps, then drill into individual test directories if needed.[1]

## GB200 FDT Triage Workflow

The GB200 GB300 FDT runbook defines a strict triage order and several guardrails for CPV and IBE. The recommended priority when multiple MODS codes appear is:[1]

1. Check for XID errors in dmesg or kernel logs (including crash or timeout contexts) and file RHS tickets where necessary.[2][1]
2. Handle NVLink-related MODS errors (for example, low bandwidth or NVLink bus errors).[1]
3. Address General Non‑RMA‑eligible MODS codes (software/config issues).[1]
4. Address Non‑NVLink RMA‑eligible GPU or memory failures.[2][1]
5. Finally, review Other Non‑NVLink failures that may require firmware or PCIe triage.[1]

For NVLink-related failures (for example 014 low bandwidth or 140 NVLink bus error), the runbook introduces a more involved procedure:[2][1]

- Confirm the firmware bundle and rack pinning align with the prescribed GB200 recipe using HOPS and pinning configs.[1]
- Inspect compute tray FDT logs to identify the specific tray pair or NVSwitch ASICs involved, using chassis slot-to-tray mapping tables.[1]
- Examine NVSwitch controller Fabric Manager logs for fatal events and correlate GPU Fabric GUIDs with trays, ensuring that hosts outside the CPV job are not injecting traffic or causing transient fabric issues.[1]
- Only after correlation and full-rack testing, move to RMA of suspect compute trays, NVSwitch trays, or cable cartridges via GPUPR runbooks.[1]

Pro Tip: NVIDIA’s generic guidance often suggests reseating trays for NVLink issues, but the OCI GB200 runbook explicitly instructs engineers to avoid reseating GB200 compute or NVSwitch trays whenever possible, as repeated reseats can damage NVLink pins and lead to chronic failures. Treat reseating as a last resort and always coordinate with CPV Tier 2 if you believe physical reseat is unavoidable.[1]

## XID Errors and RAS References

XID errors reported by the NVIDIA kernel driver are the first escalation signal for severe GPU issues, including memory faults and NVLink errors. DA‑11437 points to the Server RAS Catalog (PID 1116117) for the latest XID-to-action mapping and emphasizes that XIDs can appear both on bare metal and inside VMs.[2]

Important XIDs to watch for in FDT contexts include:[2]
- XID 31: GPU memory page fault.  
- XID 45: Preemptive cleanup indicating long-running or stuck GPU work.  
- XID 48: Double-bit ECC error.  
- XID 63: Row remapping failure.  
- XID 74: NVLink error.

OCI’s GB200 runbook recommends collecting NVDebug (nvidia-bug-report.sh) alongside FDT logs any time XIDs coincide with FDT timeouts or host instability. DA‑11437 associates many MODS ECC codes with corrective actions that involve row remapping (requiring power cycle) and then RMA if the error persists.[2][1]

Pro Tip: For persistent ECC and NVLink-related MODS/XID combinations on GB200, it is usually more effective to escalate early to CPV Tier 2 and initiate GPUPR workflows rather than repeatedly re-running the same FDT tests.[2][1]

## Useful Command Snippets and Patterns

Several commands appear repeatedly in OCI FDT triage and automation flows:[1]

- GPU identification and fabric GUIDs:

```bash
nvidia-smi -q | egrep "GPU 000|Module Id|Serial Number|GPU Fabric GUID"
```

- Fabric registration health:

```bash
nvidia-smi -q | grep Fabric -A 9
```

- Multi-host inspection via clush:

```bash
clush -l ubuntu -w <host1>,<host2> \
  "nvidia-smi -q | egrep \"GPU 000|Module Id|Serial Number\""
```

- Pull FDT logs from Object Storage after CPV jobs:

```bash
oci session authenticate --profile DEFAULT \
  --tenancy-name bmc_operator_access --region r1

oci os object list -ns hpc -bn Debug \
  --auth security_token --profile DEFAULT \
  --prefix <HOST_SERIAL>
```

- NVDebug collection for bug reports:

```bash
sudo nvidia-bug-report.sh
```

These commands are reflected both in the GB200 FDT runbook and in the NVIDIA system validation guides, and are the basis for the automation in Burn-in-Orchestrator and OCI DR HPC v2.[3][1]

## Code Integration: Automation and Parsing

While the code repositories are not reproduced here, the GB200 runbook and Debug/RAS guide explain the contracts that OCI automation relies on.[2][1]

- Burn-in-Orchestrator uses:  
  - partnerdiag/fieldiag CLI plus JSON spec files (for example spec_gb200_nvl_72_2_4_field_level1.json) to run FDT jobs at scale.[3]
  - Structured log paths under /local/FDT and OCI Object Storage naming conventions documented in the runbook to collect artifacts.[1]

- OCI DR HPC v2’s GB200 parser consumes:  
  - fieldiag_summary.log for test-level pass/fail and MODS codes.  
  - fieldiag.json per GPU for machine-readable error information.  
  - Directory naming for COMPUTE_NODEx connectivity tests to correlate cross-node failures.[1]

Example patterns you can follow in internal code:

- Parse fieldiag_summary.log line by line to extract test ID, GPU PCI ID, MODS code, and result; then look up the numeric suffix in a table derived from DA‑11437 to classify the issue as software, RMA-eligible, or NVLink-related.[2][1]
- Load fieldiag.json into a struct or dict, then aggregate failures per GPU and per tray across an L11 run to identify hot spots and likely root-cause trays.[1]
- Overlay triage hints from the GB200 runbook (for example, “NVLink-related”, “Non‑NVLink RMA-eligible”) on top of MODS codes to generate actionable triage summaries in internal dashboards.[1]

Pro Tip: Keep your code aligned with the GB200 runbook’s MODS mapping, not only DA‑11437, so OCI-specific overrides such as “Don’t Reseat GB200 trays” and “Don’t cut DO for RDMA on FDT fails” are honored in automated recommendations.[2][1]

***

This blog content is based on NVIDIA’s Debug and RAS Guide, GB NVL72 System Validation Guide, and OCI’s GB200 FDT triage runbook, and respects NVIDIA’s confidential documentation by describing procedures and mappings in high-level, original language without reproducing proprietary text.[3][2][1]

[1](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/12116027/cf70dfd3-0614-4e4d-8b11-39990fc79710/how-to-handle-fdt-fails-for-shape-gb200.pdf)
[2](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/12116027/9efdf112-6d4c-40f2-819e-9b8e866da5e7/DA-11437-001_v13.pdf)
[3](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/12116027/0ea4ff5c-177b-4310-9634-3fd9fb5dc9ea/VG-12022-001_v09.pdf)
