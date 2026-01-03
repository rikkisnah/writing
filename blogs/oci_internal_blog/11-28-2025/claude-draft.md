# Partner Diagnostics, Field Diagnostic Tool, and Universal FDT

## A Practical Guide for OCI Engineers Supporting GB200 NVL72 & Other GPU Shapes

---

## 1. Introduction

Modern GPU systems operate at massive scale and extreme density, requiring deterministic, hardware-accurate diagnostics for debugging and validation. NVIDIA provides three primary diagnostic suites—**Partner Diagnostics**, **Field Diagnostics (FDT)**, and **Universal FDT**—all of which are widely used across OCI's burn-in, CPV, IBE, and customer-facing support pipelines.

This blog consolidates NVIDIA's diagnostic tooling into a single practical reference, focused on:

- Understanding what each diagnostic suite is and when to use it
- Running diagnostics correctly across GB200 NVL72 racks, HGX-8 nodes, and single GPUs
- Interpreting MOD codes, XID errors, and RAS artifacts
- Troubleshooting FDT failures accurately and safely
- Applying OCI-specific workflow, guardrails, and automation patterns
- Leveraging OCI repositories (**burn-in-orchestrator**, **oci-dr-hpc-v2**) for automation and log parsing

This document is written for **OCI engineers working on CPV, HPC/IBE, GPU platforms, cluster validation, and GB200 deployments**.

---

## 2. What is Partner Diagnostics / FDT / Universal FDT?

NVIDIA's diagnostic tooling has evolved over the years, often producing confusion around naming. Here is a clean mapping:

### 2.1 Partner Diagnostics (partnerdiag)

Partner Diagnostics is NVIDIA's **rack-level and multi-node diagnostic suite**. It is the authoritative test used for:

- **GB200 NVL72 racks (rack-level L11 tests)**
- **HGX-8 nodes (H100, H200, GB200)**
- **Manufacturing mode tests for compute trays and switch trays**
- **Field mode tests for health validation**

Partner Diagnostics uses JSON test specifications (`spec_*.json`) and orchestrates:

- NVLink/NVSwitch connectivity validation
- PCIe enumeration and bandwidth testing
- Fabric registration verification
- GPU compute/memory stress testing
- Power/thermal synchronization
- Cross-node bandwidth stress

The primary binary is:

```bash
partnerdiag
```

### 2.2 Field Diagnostics Tool (FDT / fieldiag / OneDiag)

Historically called **fieldiag**, now often called **FDT**, this is NVIDIA's **single-GPU diagnostic tool**, used for:

- Individual GPU cards (H100 PCIe, A100 PCIe, L40, etc.)
- HGX trays during isolation testing
- Quick validation after firmware updates
- Deep GPU compute/memory/NVLink PCIe stress

The binary is:

```bash
fieldiag
```

### 2.3 Universal FDT

Universal FDT is the cross-architecture successor tool, supporting:

- **Ampere**: A100, A30, A10, A2
- **Hopper**: H100, H200
- **Blackwell**: B200, GB200

It provides a unified path for running FDT across both PCIe and SXM SKUs.

---

## 3. Architecture-Specific Execution

This section provides the **canonical** commands backed by NVIDIA's documentation.

### 3.1 GB200 NVL72 — Rack Level Testing (L11)

A GB200 NVL72 rack consists of:

- **18 Compute Trays** (4 GPUs + 2 Grace CPUs per tray = 72 total GPUs)
- **9 NVSwitch trays**
- **NVLink mesh fabric interconnect**

Diagnostics operate at two layers:

- **L10 (Tray-level diagnostics)**: Individual compute tray validation
- **L11 (Rack-level diagnostics)**: Full rack validation across all 18 compute trays and 9 switch trays

NVIDIA requires **all L10 compute trays to pass** before running L11.

#### 3.1.1 Field Diagnostics (Recommended for OCI)

**Level 1 Testing (shorter)**:

```bash
./partnerdiag --field --level1 --primary_diag_ip=<IP>
```

**Level 2 Testing (comprehensive)**:

```bash
./partnerdiag --field --level2 --primary_diag_ip=<IP>
```

**Notes:**
- Runs all connectivity + power/thermal + stress + fabric tests
- Requires fabric manager operational
- Automatically distributes diagnostics across compute trays

#### 3.1.2 Manufacturing Diagnostics (for hardware bring-up)

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

**Cable Cartridge EEPROM Check (both compute and switch trays):**

```bash
./partnerdiag \
  --mfg \
  --run_spec=spec_gb200_nvl_72_2_4_cable_cartridge_partner.json \
  --primary_diag_ip=<IP>
```

Manufacturing tests are **long-running**, include destructive power cycles, and must **not** be used in CPV or production.

---

### 3.2 Hopper / Blackwell HGX-8 Nodes

HGX-8 nodes (H100, H200, GB200 HGX-8) use the Partner Diagnostics package for single-node testing.

#### 3.2.1 Manufacturing Diagnostics

```bash
sudo ./partnerdiag \
    --mfg \
    --run_spec=spec_blackwell-hgx-8-gpu_partner_mfg.json \
    --run_on_error \
    --no_bmc
```

#### 3.2.2 Field Diagnostics

```bash
sudo ./partnerdiag --field --run_on_error --no_bmc
```

#### 3.2.3 Running Individual Tests

```bash
sudo ./partnerdiag --field --test=pcie,connectivity --run_on_error --no_bmc
```

#### 3.2.4 Specifying Test Levels

```bash
# Level 1 (shorter)
sudo ./partnerdiag --field --level1 --run_on_error --no_bmc

# Level 2 (comprehensive - default)
sudo ./partnerdiag --field --level2 --run_on_error --no_bmc
```

---

### 3.3 Single-GPU Diagnostics (Universal FDT)

For individual GPU card testing across Ampere, Hopper, and Blackwell architectures.

#### 3.3.1 Full Execution

```bash
sudo ./fieldiag
```

#### 3.3.2 Run on a Specific GPU

```bash
sudo ./fieldiag device=0
```

#### 3.3.3 Only NVLink Tests

```bash
sudo ./fieldiag only_nvlink
```

#### 3.3.4 Quick Basic Test

```bash
sudo ./fieldiag BS_Test
```

This is useful for quick row remapping status checks.

#### 3.3.5 Return Codes

| Return Code | Banner | Description |
|-------------|--------|-------------|
| 0 | PASS | Hardware passes diagnostics |
| 1 | FAIL | Hardware has failed diagnostics |
| 2 | RETEST | Pre-check failed, correct and retest |

---

## 4. Test Coverage and Duration

Partner Diagnostics defines test stages via spec files. Based on GB200-spec test tables:

| Test | L10-L1 | L10-L2 | L11 Rack | Duration | Description |
|------|--------|--------|----------|----------|-------------|
| Connectivity | ✓ | ✓ | ✓ | 12–16 min | PCIe + NVLink topology validation |
| NvlBwStress | ✓ | ✓ | ✓ | 21 min | NVLink multi-hop stress |
| ThermalSteadyState | ✓ | ✓ | ✓ | 15–22 min | GPU+CPU power thermal steady state |
| CpuGpuSyncPulsePower | ✓ | ✓ | ✓ | 20–23 min | Sync pulsed load stress |
| Gpustress | ✓ | ✓ | – | 4 min | CUDA compute load |
| Gpumem | ✓ | ✓ | – | 1 min | Memory bandwidth + ECC tests |
| Pcie | ✓ | ✓ | – | 6 min | PCIe enumeration + bandwidth |

### FDT Test IDs

The following tests are available in the FDT test suite:

- Checkinforom, environmentcheck, Inventory
- TegraCpu, TegraCpu4, TegraCpu5, TegraMemory
- CpuMemorySweep, TegraClink
- Gpustress, Gpumem, Pcie, C2C
- CPUVDD_PowerStress, CpuGpuConstPower
- Connectivity, NvlBwStress, NvlBwStressBg610, NvlBwStressBg610Pulsy
- DimmStress, CpuGpuSyncPulsePower, ThermalSteadyState
- SyslogErrorCheck, KernLogErrorCheck, DmesgLogErrorCheck
- SyslogAERCheck, KernLogAERCheck, DmesgLogAERCheck

---

## 5. Understanding MODS Error Codes

NVIDIA's diagnostics generate errors in the form:

```
MODS-xxxxxxxxx###
```

or

```
DGX-xxxxxxxxx###
```

But only the **last 2–3 digits** (###) represent the actionable code.

### 5.1 Non-RMA Eligible Errors (typically configuration/software)

**Action**: Check firmware version and retest with latest FDT. If repeated, file NVBug with dmesg and diagnostic logs.

| Code | Error Message |
|------|---------------|
| 002 | Software error |
| 008 | Bad parameter passed to function |
| 021 | Script failed to execute |
| 077 | Timeout error |
| 144 | NVIDIA CUDA error |
| 240 | Unexpected result from hardware |
| 272 | Read parameter differs from expected |
| 318 | ECC detected a correctable error in L2 over threshold |
| 779 | Voltage value out of range |
| 818 | MODS detected an assertion failure |

### 5.2 RMA-Eligible Errors (hardware failures)

**Action**: Check firmware and retest. If repeated, start RMA process.

| Code | Error Message |
|------|---------------|
| 083 | CRC/Checksum miscompare |
| 097 | Unexpected device interrupts |
| 194 | Bad memory |
| 276 | Hardware reports wrong status |
| 316 | ECC detected a correctable error over threshold |
| 319 | ECC detected an uncorrectable error in L2 |
| 320 | ECC detected a correctable error over threshold |
| 321 | ECC detected an uncorrectable error |
| 341 | Buffer mismatch |
| 363 | Row remapping failed |
| 539 | NVRM Generic Falcon Error |
| 541 | NVRM Detected memory error |
| 582 | GPU Stress Test found pixel miscompares |
| 612 | Invalid value for Tegra configuration variables |
| 614 | Extra golden code miscompare |
| 774 | Tegra test failed |

### 5.3 NVLink / NVSwitch Failures

| Code | Error Message | Action |
|------|---------------|--------|
| 014 | Low bandwidth | Check fabric registration, FM logs |
| 140 | NVLink bus error | Check fabric GUIDs, FM logs |
| 688 | NVRM invalid state or config | Check NVSwitch controller, FM status |

**Important:** If the failure originates in NVLink or NVSwitch layers, **treat it as a rack-level connectivity issue**, not a GPU card issue.

### 5.4 Other Non-NVLink Failures

| Code | Error Message | Suggested Action |
|------|---------------|------------------|
| 124 | Invalid InfoROM | Check firmware, run inforom recovery tool, retest. If still failing, RMA. |
| 143 | PCI Express bus error | Ensure GPU and NVSwitch devices detected on lspci, retest. If still failing, RMA. |
| 167 | GFW boot reported a failure | Check firmware, reboot, verify devices on lspci, retest. If still failing, file NVbug. |
| 220 | PCIE device not found | Check firmware, cold reboot, retest. If still failing, RMA. |
| 317 | ECC uncorrectable error in FB | Check firmware, power cycle, retest. If still failing, RMA. |
| 679 | NVRM invalid argument | Check firmware, run inforom recovery tool, retest. If still failing, RMA. |
| 936 | TLW Error | If fatal, power cycle; otherwise ignore. |

---

## 6. Log File Locations and Interpretation

### 6.1 GB200 Log Location

```
/local/FDT/629.../dgx/logs-YYYYMMDD-HHMMSS/
```

A typical directory structure:

```
fieldiag_summary.log           # High-level pass/fail summary
<test_id>/
  <GPU_PCI_ADDR_GPU_SN>/
    fieldiag.log               # Detailed test log
    fieldiag.json              # Machine-readable results
COMPUTE_NODE_X/
  connectivity/                # Multi-node test logs
```

### 6.2 If /local is Missing (common after power cycle)

```bash
# Find the mountable SSD device
ls /dev | grep -i md
# Output: md0

# Mount the SSD device
sudo mount /dev/md0 /local

# Navigate to FDT logs
cd /local/FDT
```

### 6.3 Key Files

| File | Notes |
|------|-------|
| `fieldiag_summary.log` | High-level pass/fail summary |
| `fieldiag.log` | Main human-readable log |
| `fieldiag.json` | Machine-readable test output |
| `connectivity/*.log` | Multi-node connectivity details |
| `run.log` | Console output and final results |

### 6.4 FDT Test Log File Paths

**Single Node:**
```
/local/FDT/629.../dgx/logs-<yyyymmdd>-<hhmmss>/<fdt_test_id>/<GPU_PCI_ADDR_GPU_SN>/fieldiag.log
```

**Multi-Node:**
```
/local/FDT/629.../dgx/logs-<yyyymmdd>-<hhmmss>/COMPUTE_NODE_X/connectivity/<GPU_PCI_ADDR_GPU_SN>/fieldiag.log
```

### 6.5 Retrieving Logs from OCI CLI

```bash
# Authenticate
oci session authenticate --profile DEFAULT --tenancy-name bmc_operator_access --region r1

# List available logs
oci os object list -ns hpc -bn Debug --auth security_token --profile DEFAULT --prefix <HOST_SERIAL>

# Download specific log
oci os object get -ns hpc -bn Debug --auth security_token --profile DEFAULT \
  --name /name/of/object/store/filepath \
  --file ./local_filename
```

---

## 7. GB200 FDT Failure Triage Workflow

This is the most critical section. OCI's internal triage runbook defines clear rules.

### 7.1 Priority Order When Multiple Errors Appear

1. **XID Errors (kernel reported)**
   - Always check Linux kernel logs first (`dmesg`)
   - XID errors indicate issues deeper than Partner Diagnostics

2. **NVLink-related failures**
   - Common and high-impact
   - Check Switch Trays, Fabric GUIDs, FM logs

3. **Non-RMA software/config errors**
   - Retry with latest firmware and FDT

4. **RMA-eligible GPU errors**
   - Proceed with RMA qualification

5. **Other mismatches or transient fails**
   - Investigate and retry

### 7.2 NVLink Failure Checklist

#### Step 1: Verify Firmware Recipe Alignment

If FM or driver versions mismatch, NVLink tests will fail.

#### Step 2: Check Fabric Registration

```bash
nvidia-smi -q | grep Fabric -A 9
```

Each GPU should show:
- Fabric GUID
- Registration success
- NVLink active lanes

#### Step 3: Inspect NVSwitch Controller Logs

Look for:
- Missing ports
- Failed routing entries
- Mismatched switch tray GUIDs
- NVLink down events

```bash
# SSH to NVSwitch controller
ssh admin@<nvswitch_controller_ip>

# View Fabric Manager logs
cat /var/log/nmx/nmx-c/fabricmanager.log

# Search for Fatal errors
grep -i "Fatal" fabricmanager.log* -A 11
```

#### Step 4: Collect NVDebug Logs

```bash
cd ~/nvdebug
sudo ./nvdebug -b "GB200 NVL" -t arm64 --local -v -o ./nvdebug-logs
```

This includes `nvidia-bug-report.sh`.

#### Step 5: Physical Inspection?

> **Warning from NVIDIA: DO NOT RESEAT TRAYS**
>
> "Reseating the trays can bend the pins on the tray. Reseating multiple times is likely to cause damage to the NVLink connectivity."

**OCI Rule:** Do not reseat compute trays unless directed by NVIDIA engineering.

### 7.3 NVLink Triage Steps Summary

1. Review JIRA ticket history for host RMA history
2. Verify firmware version matches recommended recipe
3. Search Compute Tray FDT Test Logs for MODS/DGX errors
4. Identify compute tray and switch tray using chassis slot mapping
5. If test involved fewer than 18 hosts, analyze Fabric Manager logs
6. Check for Fatal errors from hosts NOT part of the test
7. Run full rack-level L11 test with all 18 hosts if needed
8. Initiate GPUPR automated RMA for compute tray if needed
9. If still failing, escalate for NVSwitch tray RMA
10. If still failing, cut DO ticket for cable cartridge replacement

### 7.4 Chassis Slot Mapping Table

| Chassis Slot | Tray Index | Tray Name | NVSwitch ASICs |
|--------------|------------|-----------|----------------|
| 27 | 17 | Compute Tray 18 | N/A |
| 26 | 16 | Compute Tray 17 | N/A |
| 25 | 15 | Compute Tray 16 | N/A |
| ... | ... | ... | ... |
| 17 | 8 | Switch Tray 9 | ffff:0d:10.0, ffff:0d:11.0 |
| 16 | 7 | Switch Tray 8 | ffff:0d:0e.0, ffff:0d:0f.0 |
| ... | ... | ... | ... |
| 9 | 0 | Switch Tray 1 | ffff:0d:00.0, ffff:0d:01.0 |
| 8 | 7 | Compute Tray 8 | N/A |
| ... | ... | ... | ... |
| 1 | 0 | Compute Tray 1 | N/A |

---

## 8. Useful Commands Reference

### 8.1 GPU Inventory

```bash
nvidia-smi -q | egrep "GPU 000|Module Id|Serial Number|GPU Fabric GUID"
```

### 8.2 Check NVSwitch / Fabric Overview

```bash
nvidia-smi nvlink --status
```

### 8.3 Check Fabric Registration State

```bash
nvidia-smi -q | grep Fabric -A 9
```

### 8.4 Remote Multi-Host Queries

```bash
clush -l ubuntu -w <host1>,<host2> \
  "nvidia-smi -q | egrep \"GPU 000|Module Id|Serial Number\""
```

### 8.5 Get Rack Firmware Version

```bash
# Using hops-cli
hops-cli
> host <rack_serial>
> firmware_inventory
```

### 8.6 Generate Debug Package

```bash
sudo nvidia-bug-report.sh
```

---

## 9. XID Error Quick Reference

XID errors are reported to the kernel log from the NVIDIA GPU driver. Key XIDs to watch:

| XID | Description |
|-----|-------------|
| 31 | GPU memory page fault |
| 45 | Preemptive cleanup |
| 48 | Double-bit ECC error |
| 63 | Row remapping failure |
| 74 | NVLink error |
| 79 | Hypervisor/firmware issues |
| 109 | NVSwitch fatal |

XIDs should always be correlated with MODS codes.

For the latest GPU XID error code to action mapping, refer to the **NVIDIA Server RAS Catalog** (NVOnline: 1116117).

---

## 10. OCI Automation Integration

OCI's automation for FDT testing exists in two key repositories:

### 10.1 Burn-in Orchestrator

**Repository:** `https://github.com/rikkisnah/burn-in-orchestrator`

This repository defines:
- How Partner Diagnostics/FDT is invoked programmatically
- How spec files are generated or selected
- How logs are gathered and uploaded to Object Storage
- Control flow across multi-node clusters

#### FDT Version Selection by Shape

```bash
SHAPE=$(echo $HOST_JSON_DATA | jq -r '.[].shape' | uniq)
case $SHAPE in
    BM.GPU.H100.8 | BM.GPU.H100T.8 | BM.GPU.H200.8 )
        fdt_version=40946
        nvidia_fdt_file=629-24287-XXXX-FLD-${fdt_version}.tgz
        ;;
    BM.GPU.B200.8 )
        fdt_version=43576
        nvidia_fdt_file=629-26287-0103-FLD-${fdt_version}.tgz
        ;;
esac
```

#### Invoking FDT

```bash
# GPU Fielddiag test
fdt_parameters="--no_bmc --field --gpufielddiag --run_on_error"
sudo ./partnerdiag $fdt_parameters

# Rack-level test
fdt_parameters="--field --level2 --primary_diag_ip=${PRIMARY_HOST_IP} --no_bmc"
sudo ./partnerdiag $fdt_parameters
```

#### Dynamic Spec Generation

```python
def create_hosts_entry(host_data):
    new_hosts = {}
    for host_line in host_data:
        # Query each host for its tray index
        cmd = f"ssh ubuntu@{host_line} 'nvidia-smi -q | grep Tray | uniq'"
        host_index = int(subprocess.check_output(cmd).decode().split()[-1])

        current_host = {
            "user": "ubuntu",
            "node_type": "compute_node",
            "host_id": f"COMPUTE_NODE_{host_index}",
            "rack_slot": host_index + 10 if host_index > 7 else host_index + 1
        }
        new_hosts[host_line] = current_host
    return new_hosts
```

#### Log Upload Pattern

```bash
upload_logs() {
    for file in logs/*; do
        oci os object put --namespace hpc --bucket-name Debug \
            --file ${file} --auth instance_principal --force
    done
}
```

### 10.2 OCI DR HPC v2 Parser

**Repository:** `https://github.com/ai2-compute-gpu/oci-dr-hpc-v2`

This repository contains the **canonical parser** for GB200 FDT output.

#### MODS Error Code Parsing

```go
func parseLogsAndSummarize(inputFilePath string, config *ParserConfig) (*ParserResults, error) {
    for _, regexConfig := range config.Configurations {
        regex := regexp.Compile(regexConfig.Regex)
        matches := regex.FindAllString(logContent, -1)
        for _, match := range matches {
            results.AddMatch(match, regexConfig.Recommendation)
        }
    }
    return results, nil
}
```

#### Error Code Mapping Configuration

```json
{
  "configurations": [
    {
      "regexes": ["^(DGX|MODS)\\-.{9}(014|140)(.*\\|){6}.*"],
      "recommendation": [
        "This indicates an NVLink-Related FDT Test Failure",
        "Follow NVLink-Related failure triage steps"
      ]
    },
    {
      "regexes": ["^(DGX|MODS)\\-.{9}(002|008|021|077|144)(.*\\|){6}.*"],
      "recommendation": [
        "This indicates a General Non-RMA-Eligible FDT Test Failure",
        "Check firmware version and retest with latest"
      ]
    }
  ]
}
```

#### Triage Recommendation Generation

```go
func generateRecommendations(results HostResults) RecommendationReport {
    var recommendations []Recommendation

    for _, testResult := range results.AllTests() {
        if rec := config.GetRecommendation(testResult.Name, testResult.Status); rec != nil {
            recommendations = append(recommendations, Recommendation{
                Type:      rec.Type,  // "critical", "warning", "info"
                TestName:  testResult.Name,
                FaultCode: rec.FaultCode,  // e.g., "HPCGPU-1009-01"
                Issue:     rec.Issue,
                Suggestion: rec.Suggestion,
            })
        }
    }

    return RecommendationReport{
        Recommendations: recommendations,
        GeneratedAt:     time.Now().UTC(),
    }
}
```

---

## 11. Pro Tips for OCI Engineers

### 1. Do Not Reseat Trays

NVIDIA explicitly warns against reseating GB200 compute trays. This permanently damages NVLink pins.

### 2. Ensure Recipe Alignment

Many failures vanish when FM, driver, firmware, and OS image are aligned to the recommended recipe.

### 3. FDT Does Not Equal RDMA

FDT tests don't use RDMA paths. NVLink failures do not imply RDMA issues. **Do not cut DO tickets for RDMA issues based on FDT failures.**

### 4. L11 Requires L10 Success

Do not attempt rack-level tests when compute trays have L10 issues.

### 5. Check XIDs Before MODS

XID errors often reveal underlying hardware issues before Partner Diagnostics detects them.

### 6. Use Self-Hosted Mode

Self-hosted mode is simpler for multi-node tests and automatically distributes binaries to secondary nodes.

### 7. Full Rack Testing for NVLink Issues

When diagnosing NVLink failures, always run with all 18 hosts when possible. Partial rack tests can show false failures due to interference.

### 8. IST for In-System Testing

For newer, more comprehensive testing, consider In-System Test (IST) which requires a separate image download.

---

## 12. Triage Decision Tree

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

## 13. Key NVOnline References

| PID | Document Title |
|-----|----------------|
| 1116117 | Server RAS Guide |
| 1109712 | Debug and RAS Guide for NVIDIA Data Center Products |
| 1138824 | Multi Node NVLink Troubleshooting Guide |
| 1120466 | Partner Diagnostics User Guide |
| 1091416 | Data Center Partner Diagnostics Playbook |
| 1123468 | NVIDIA GB200 NVL Service Flow User Guide |
| 1117886 | GB200 NVL72 Rack Level Integration Guidelines |
| 1124813 | GB200 NVL NVLink Mapping Tool |

---

## 14. Conclusion

Partner Diagnostics, Field Diagnostics, and Universal FDT form the backbone of NVIDIA GPU validation inside OCI. With GB200 NVL72 racks pushing GPU density to unprecedented scale, deterministic diagnostics and disciplined triage are essential to prevent downtime, avoid unnecessary RMA, and maintain fleet-wide health.

This blog consolidates all relevant NVIDIA and OCI documentation into a single actionable reference—covering how to run, interpret, and troubleshoot diagnostics at scale across GB200, H100/H200/HGX, and single-GPU systems.

For questions or contributions, reach out to the **CPV Triage** (`#cpv-triage`) or **AI2 Compute / GPU Infra** Slack channels.

---

## References

1. NVIDIA GB200 and GB300 NVL 72 Partner Diagnostics User's Guide (DU-11965-001_20)
2. Debug and RAS Guide for NVIDIA Data Center Products (DA-11437-001_v13)
3. NVIDIA Field Diagnostic Software Guide (DU-05363-001_v42/v43)
4. NVIDIA GB200 NVL System Validation Guide (VG-12022-001_v09)
5. GPU RAS Architecture Overview (GPU_RAS-2025Oct21)
6. OCI Internal Runbook: How to Handle FDT Fails for Shape GB200
7. OCI Burn-in Orchestrator Repository (`burn-in-orchestrator`)
8. OCI DR HPC v2 Repository (`oci-dr-hpc-v2`)
9. NVIDIA Server RAS Catalog (NVOnline: 1116117)
10. Multi Node NVLink Troubleshooting Guide (NVOnline: 1138824)
