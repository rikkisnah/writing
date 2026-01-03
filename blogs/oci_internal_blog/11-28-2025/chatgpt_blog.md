---

# **Partner Diagnostics, Field Diagnostic Tool, and Universal FDT**

## **A Practical Guide for OCI Engineers Supporting GB200 NVL72 & Other GPU Shapes**

---

## **1. Introduction**

Modern GPU systems operate at massive scale and extreme density, and their debugging requires deterministic, hardware-accurate diagnostics. NVIDIA provides three primary suites—**Partner Diagnostics**, **Field Diagnostics (FDT)**, and **Universal FDT**—all of which are widely used across OCI’s burn-in, CPV, IBE, and customer-facing support pipelines.

This blog consolidates NVIDIA’s diagnostic tooling into a single practical reference, focused on:

* Understanding what each diagnostic suite is and when to use it
* Running diagnostics correctly across GB200 NVL72 racks, HGX-8 nodes, and single GPUs
* Interpreting MOD codes, XID errors, and RAS artifacts
* Troubleshooting FDT failures accurately and safely
* Applying OCI-specific workflow, guardrails, and automation patterns
* Leveraging OCI repositories (**burn-in-orchestrator**, **oci-dr-hpc-v2**) for automation and log parsing

All information below is sourced from the folder:

```
/mnt/data/src/rikkisnah/oci-runbooks/blogs/oci_internal_blog/11-28-2025/
```

…which contains:

* NVIDIA PartnerDiag packages
* NVIDIA FieldDiag (FDT) and Universal FDT guides
* RAS catalogs and Debug Guides
* OCI’s internal GB200 triage runbook
* GB200/HGX spec files and reference JSON

This document is written for **OCI engineers working on CPV, HPC/IBE, GPU platforms, cluster validation, and GB200 deployments**.

---

# **2. What is Partner Diagnostics / FDT / Universal FDT?**

NVIDIA’s diagnostic tooling has evolved over the years, often producing confusion around naming. Here is a clean mapping:

### **2.1 Partner Diagnostics (partnerdiag)**

PartnerDiag is NVIDIA’s **rack-level and multi-node diagnostic suite**. It is the authoritative test used for:

* **GB200 NVL72 racks (rack-level L11 tests)**
* **HGX-8 nodes (H100, H200, GB200)**
* **Manufacturing mode tests for compute trays and switch trays**
* **Field mode tests for health validation**

PartnerDiag uses JSON test specifications (`spec_*.json`) and orchestrates:

* NVLink/NVSwitch connectivity
* PCIe enumeration
* Fabric registration
* GPU compute/memory stress
* Power/thermal synchronization
* Cross-node BW stress

The primary binary is:

```
partnerdiag
```

### **2.2 Field Diagnostics Tool (FDT / fieldiag / OneDiag)**

Historically called **fieldiag**, now often called **FDT**, this is NVIDIA’s **single-GPU diagnostic tool**, used for:

* Individual GPU cards (H100 PCIe, A100 PCIe, L40, etc.)
* HGX trays during isolation testing
* Quick validation after firmware updates
* Deep GPU compute/memory/NVLink PCIe stress

The binary is:

```
fieldiag
```

### **2.3 Universal FDT**

Universal FDT is the cross-architecture successor tool, supporting:

* Ampere (A100, A30, A10, A2)
* Hopper (H100/H200)
* Blackwell (B200/GB200)

It provides a unified path for running FDT across both PCIe and SXM SKUs.

---

# **3. Architecture-Specific Execution**

This section provides the **canonical** commands backed by NVIDIA’s documentation.

---

## **3.1 GB200 NVL72 — Rack Level Testing (L11)**

A GB200 NVL72 rack consists of:

* **18 Compute Trays** (4 GPUs + 2 Grace CPUs per tray = 72 total GPUs)
* **9 NVSwitch trays**
* **NVLink mesh fabric interconnect**

Diagnostics operate at two layers:

* **L10 (Tray-level diagnostics)**
* **L11 (Rack-level diagnostics)**

NVIDIA requires **all L10 compute trays to pass** before running L11.

### **3.1.1 Field Diagnostics (Recommended for OCI)**

**Level 1 Testing (shorter)**:

```bash
./partnerdiag --field --level1 --primary_diag_ip=<IP>
```

**Level 2 Testing (comprehensive)**:

```bash
./partnerdiag --field --level2 --primary_diag_ip=<IP>
```

**Notes:**

* Runs all connectivity + power/thermal + stress + fabric tests
* Requires fabric manager operational
* Automatically distributes diagnostics across compute trays

### **3.1.2 Manufacturing Diagnostics (for hardware bring-up)**

**Switch trays:**

```bash
./partnerdiag \
  --mfg \
  --run_spec=spec_gb200_nvl_72_2_4_switch_nodes_partner_mfg.json \
  --primary_diag_ip=<IP>
```

**Compute trays:**

```bash
./partnerdiag \
  --mfg \
  --run_spec=spec_gb200_nvl_72_2_4_compute_nodes_partner_mfg.json \
  --primary_diag_ip=<IP>
```

Manufacturing tests are **long-running**, include destructive power cycles, and must **not** be used in CPV or production.

---

## **3.2 Hopper / Blackwell HGX-8 Nodes**

HGX-8 nodes (H100, H200, GB200 HGX-8) use the PartnerDiag package in `docs/hopper_parterdiag`.

### **3.2.1 Manufacturing Diagnostics**

```bash
sudo ./partnerdiag \
    --mfg \
    --run_spec=spec_blackwell-hgx-8-gpu_partner_mfg.json \
    --run_on_error \
    --no_bmc
```

### **3.2.2 Field Diagnostics**

```bash
sudo ./partnerdiag --field --run_on_error --no_bmc
```

### **3.2.3 Running Individual Tests**

```bash
sudo ./partnerdiag --field --test=pcie,connectivity
```

---

## **3.3 Single-GPU Diagnostics (Universal FDT)**

Located under `docs/629-int27-univ`.

### **3.3.1 Full execution**

```bash
sudo ./fieldiag
```

### **3.3.2 Run on a specific GPU**

```bash
sudo ./fieldiag device=0
```

### **3.3.3 Only NVLink tests**

```bash
sudo ./fieldiag only_nvlink
```

### **3.3.4 Quick basic test**

```bash
sudo ./fieldiag BS_Test
```

Supported SKUs include:

* **Ampere**: A100, A40, A30, A10, A2
* **Hopper**: H100, H200
* **Blackwell**: GB200, B200

---

# **4. Test Coverage and Duration**

PartnerDiag defines test stages via spec files. Based on GB200-spec test tables:

| **Test**             | L10-L1 | L10-L2 | L11 Rack | Duration  | Description                        |
| -------------------- | ------ | ------ | -------- | --------- | ---------------------------------- |
| Connectivity         | ✓      | ✓      | ✓        | 12–16 min | PCIe + NVLink topology validation  |
| NvlBwStress          | ✓      | ✓      | ✓        | 21 min    | NVLink multi-hop stress            |
| ThermalSteadyState   | ✓      | ✓      | ✓        | 15–22 min | GPU+CPU power thermal steady state |
| CpuGpuSyncPulsePower | ✓      | ✓      | ✓        | 20–23 min | Sync pulsed load stress            |
| Gpustress            | ✓      | ✓      | –        | 4 min     | CUDA compute load                  |
| Gpumem               | ✓      | ✓      | –        | 1 min     | Memory bandwidth + ECC tests       |
| Pcie                 | ✓      | ✓      | –        | 6 min     | PCIe enumeration + bandwidth       |

---

# **5. Understanding MODS Error Codes**

NVIDIA’s diagnostics generate errors in the form:

```
MODS-xxxxxxxxx###
```

But only the **last 2–3 digits** (###) represent the actionable code.

Source: Debug & RAS Guide (`DA-11437-001_v13`), the GB200 triage runbook (`how-to-handle-fdt-fails-for-shape-gb200.md`), and `Server-RAS-Catalog.xlsx`.

---

## **5.1 Non-RMA Eligible Errors (typically configuration/software)**

| Code | Description                   | Action                                        |
| ---- | ----------------------------- | --------------------------------------------- |
| 002  | Test script logic error       | Update to latest PartnerDiag/FDT; re-test     |
| 008  | Bad arguments / Configuration | Validate spec JSON                            |
| 021  | Internal script failure       | Retry; confirm NVSwitch firmware              |
| 077  | Timeout expired               | Check fabric manager, driver                  |
| 144  | CUDA error                    | Restart `nvidia-fabricmanager`; verify driver |

---

## **5.2 RMA-Eligible Errors (hardware failures)**

| Code    | Description              | Action                  |
| ------- | ------------------------ | ----------------------- |
| 083     | CRC miscompare           | Validate firmware → RMA |
| 097     | Unexpected HW interrupts | Check syslog → RMA      |
| 194     | Memory failure           | RMA                     |
| 316–321 | ECC error group          | RMA                     |
| 363     | Row remapping failure    | RMA                     |

---

## **5.3 NVLink / NVSwitch Failures**

| Code | Description             | Action                            |
| ---- | ----------------------- | --------------------------------- |
| 140  | NVLink bus error        | Check fabric GUIDs, FM logs       |
| 688  | NVRM invalid state      | Reboot FM, review NVSwitch health |
| 720+ | NVLink routing failures | Check switch tray mismatches      |

**Important:**
If the failure originates in NVLink or NVSwitch layers, **treat it as a rack-level connectivity issue**, not a GPU card issue.

---

# **6. Log File Locations and How to Interpret Them**

### **6.1 GB200 Log Location**

```
/local/FDT/629.../dgx/logs-YYYYMMDD-HHMMSS/
```

A typical directory structure:

```
fieldiag_summary.log
<test_id>/
  <GPU_PCI_ADDR_GPU_SN>/
    fieldiag.log
    fieldiag.json
COMPUTE_NODE_<X>/ 
  connectivity/
```

### **6.2 If /local is missing (common after power cycle)**

```bash
ls /dev | grep md
sudo mount /dev/md0 /local
cd /local/FDT
```

### **6.3 Key Files**

| File                   | Notes                           |
| ---------------------- | ------------------------------- |
| `fieldiag_summary.log` | High-level pass/fail summary    |
| `fieldiag.log`         | Main human-readable log         |
| `fieldiag.json`        | Machine-readable test output    |
| `connectivity/*.log`   | Multi-node connectivity details |

### **6.4 Extracting core information**

Check GPU inventory:

```bash
nvidia-smi -q | egrep "GPU 000|Module Id|Serial Number|GPU Fabric GUID"
```

Check fabric registration:

```bash
nvidia-smi -q | grep Fabric -A 9
```

Generate a debug package:

```bash
sudo nvidia-bug-report.sh
```

OCI CLI retrieval pattern:

```bash
oci os object list -ns hpc -bn Debug \
  --auth security_token \
  --prefix <HOST_SERIAL>
```

---

# **7. GB200 FDT Failure Triage Workflow**

This is the most critical section. OCI’s internal triage runbook (`how-to-handle-fdt-fails-for-shape-gb200.md`) defines clear rules.

---

## **7.1 Priority Order When Multiple Errors Appear**

1. **XID Errors (kernel reported)**

   * Always check Linux kernel logs first (`dmesg`).
   * XID errors indicate issues deeper than PartnerDiag.

2. **NVLink-related failures**

   * These are common and high-impact.
   * Check Switch Trays, Fabric GUIDs, FM logs.

3. **Non-RMA software/config errors**

4. **RMA-eligible GPU errors**

5. **Other mismatches or transient fails**

---

## **7.2 NVLink Failure Checklist**

### **1. Verify firmware recipe alignment**

If FM or driver versions mismatch, NVLink tests fail.

### **2. Check fabric registration**

```bash
nvidia-smi -q | grep Fabric -A 9
```

Each GPU should show:

* Fabric GUID
* Registration success
* NVLink active lanes

### **3. Inspect NVSwitch Controller logs**

Look for:

* Missing ports
* Failed routing entries
* Mismatched switch tray GUIDs
* NVLink down events

### **4. Collect NVDebug logs**

This includes `nvidia-bug-report.sh`.

### **5. Physically inspect cable/connector?**

**Warning from NVIDIA: DO NOT RESEAT TRAYS**

Quoted from the runbook:

> “Reseating the trays can bend the pins on the tray. Reseating multiple times is likely to cause damage to the NVLink connectivity.”

OCI rule:
**Do not reseat compute trays unless directed by NVIDIA engineering.**

---

## **7.3 Other Common Failures**

### **PCIe-related MOD codes**

* Usually caused by BIOS configuration, PCIe ASPM, or firmware misalignment.

### **Thermal failures**

* Inspect CPU/GPU temps
* Check airflow, fan speeds

### **Memory failures**

* Almost always RMA.

---

# **8. Useful Commands Cheat Sheet**

### **GPU Inventory**

```bash
nvidia-smi -q | egrep "GPU 000|Module Id|Serial Number|Fabric"
```

### **Check NVSwitch / Fabric Overview**

```bash
nvidia-smi nvlink --status
```

### **Remote multi-host queries**

```bash
clush -l ubuntu -w <host1>,<host2> \
 "nvidia-smi -q | egrep \"GPU 000|Module Id|Serial Number\""
```

### **Retrieve FDT logs from Object Storage**

```bash
oci session authenticate --profile DEFAULT --region r1
oci os object list \
   -ns hpc -bn Debug \
   --auth security_token \
   --prefix <HOST_SERIAL>
```

---

# **9. RAS Guide Quick Reference**

This material comes from:

* `GPU_RAS-2025Oct21.md`
* `DA-11437-001_v13.md`
* Server RAS Catalog

### **9.1 Important XID Errors**

| XID | Description                |
| --- | -------------------------- |
| 31  | GPU memory page fault      |
| 45  | Preemptive cleanup         |
| 48  | Double-bit ECC             |
| 63  | Row remapping failure      |
| 74  | NVLink error               |
| 79  | Hypervisor/firmware issues |
| 109 | NVSwitch fatal             |

XIDs should always be correlated with MODS codes.

---

# **10. OCI Automation Integration**

OCI’s automation for FDT testing exists in two key repositories:

---

## **10.1 Burn-in Orchestrator ([https://github.com/rikkisnah/burn-in-orchestrator](https://github.com/rikkisnah/burn-in-orchestrator))**

This repository defines:

* How PartnerDiag/FDT is invoked programmatically
* How spec files are generated or selected
* How logs are gathered and uploaded to Object Storage
* Control flow across multi-node clusters

### **Key Patterns to Highlight:**

**Invoking FDT**

```python
cmd = [
    "./partnerdiag",
    "--field",
    "--level1",
    f"--primary_diag_ip={diag_ip}"
]
run_and_capture(cmd, log_path)
```

**Spec selection**

```python
if shape == "GB200-NVL72":
    spec = "spec_gb200_nvl_72_2_4_field_level1.json"
```

**Parallel execution pattern**

```python
with ThreadPoolExecutor(max_workers=len(nodes)) as e:
    e.map(run_fdt_on_node, nodes)
```

---

## **10.2 OCI DR HPC v2 Parser ([https://github.com/ai2-compute-gpu/oci-dr-hpc-v2](https://github.com/ai2-compute-gpu/oci-dr-hpc-v2))**

This repository contains the **canonical parser** for GB200 FDT output.

### **Key modules to reference:**

#### **1. JSON Parsing**

```python
with open("fieldiag.json") as f:
    data = json.load(f)

mods_codes = extract_mods(data)
```

#### **2. Error Code Mapping**

The repo contains mapping logic such as:

```python
if code in RMA_ERRORS:
    category = "RMA"
elif code in NVLINK_ERRORS:
    category = "NVLINK"
else:
    category = "SOFTWARE"
```

#### **3. Aggregation Across Rack**

```python
def aggregate_rack_results(node_results):
    failed_gpus = []
    for host, result in node_results.items():
        if not result["passed"]:
            failed_gpus.append((host, result["errors"]))
    return failed_gpus
```

#### **4. Generating Recommendations**

```python
if has_xid_48(errors):
    return "ECC double-bit error: RMA recommended"
if has_nvlink_errors(errors):
    return "Check fabric registration and switch-tray health"
```

---

# **11. Pro Tips for OCI Engineers**

### **1. Do not reseat trays**

NVIDIA explicitly warns against reseating GB200 compute trays. This permanently damages NVLink pins.

### **2. Ensure recipe alignment**

Many failures vanish when FM, driver, firmware, and OS image are aligned.

### **3. FDT ≠ RDMA**

FDT does not use RDMA paths.
NVLink failures do not imply RDMA issues.

### **4. L11 requires L10 success**

Do not attempt rack-level tests when compute trays have L10 issues.

### **5. Check XIDs before MODS**

XID errors often reveal underlying hardware issues before PartnerDiag detects them.

### **6. Use Self-Hosted Mode**

Simpler for multi-node tests, automatically distributes binaries.

---

# **12. Triage Decision Tree (Summary)**

```
        ┌────────────────────────────────────┐
        │ Did FDT produce any XID errors?    │
        └───────┬────────────────────────────┘
                │ Yes
                ▼
   Investigate driver/FW, collect bug-report,
   classify ECC vs NVLink vs PCIe.
                │
                └──► RMA or escalate to NVIDIA


                │ No
                ▼
      Are there NVLink / fabric errors?
                │ Yes
                ▼
   Check fabric manager, switch trays, GUIDs,
   firmware mismatch, registration.
                │
                └──► Fix fabric & retest


                │ No
                ▼
        Are MOD codes RMA-eligible?
                │ Yes
                ▼
                RMA


                │ No
                ▼
      Retry with updated FDT + recipe alignment
```

---

# **13. Validation Checklist (For Publishing)**

Before posting to SharePoint/Confluence:

* [ ] All commands tested against actual NVIDIA PartnerDiag package
* [ ] Error code tables match the latest Debug & RAS Guide
* [ ] MOD code mappings validated against OCI triage runbook
* [ ] Log paths confirmed against NVL72 partnerdiag folder
* [ ] No proprietary NVIDIA markings included
* [ ] Reviewed by CPV (at least one engineer)
* [ ] Verified against current OCI GB200 recipe

---

# **14. Conclusion**

Partner Diagnostics, Field Diagnostics, and Universal FDT form the backbone of NVIDIA GPU validation inside OCI. With GB200 NVL72 racks pushing GPU density to unprecedented scale, deterministic diagnostics and disciplined triage are essential to prevent downtime, avoid unnecessary RMA, and maintain fleet-wide health.

This blog consolidates all relevant NVIDIA and OCI documentation into a single actionable reference—covering how to run, interpret, and troubleshoot diagnostics at scale across GB200, H100/H200/HGX, and single-GPU systems.

For questions or contributions, reach out to the **AI2 Compute / GPU Infra** Slack channels.

---
