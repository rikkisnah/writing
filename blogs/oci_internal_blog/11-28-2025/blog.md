# NVIDIA Partner Diagnostics, FDT, and Universal FDT: A Comprehensive Guide for OCI Engineers

*A practical guide to running and interpreting GPU diagnostics on GB200 NVL72 racks and other NVIDIA GPU shapes*

---

## Introduction: What is Partner Diagnostics / FDT?

If you've worked on GPU infrastructure at OCI, you've likely encountered a confusing array of diagnostic tools with overlapping names: "Partner Diag," "FDT," "fieldiag," "OneDiag," and "Universal FDT." Understanding what each tool does—and when to use it—is critical for efficient triage and avoiding unnecessary RMAs.

**Partner Diagnostics** is NVIDIA's official hardware validation tool designed to isolate failures on their data center GPU products. The naming confusion stems from the evolution of these tools and their different deployment contexts:

| Tool | Purpose | Typical Use Case |
|------|---------|------------------|
| **Single-GPU Field Diagnostics (fieldiag)** | Individual GPU card validation | H100 PCIe, A100 PCIe, single-GPU cards |
| **Partner Diagnostics (partnerdiag)** | Multi-GPU system validation | HGX-8 baseboards, GB200 compute trays/racks |
| **Universal FDT** | Unified package supporting multiple GPU architectures | Mixed environments, flexible deployment |

The core value of these tools is **precision**: they help identify whether a failure is a hardware defect requiring RMA, a software/configuration issue, or a transient environmental problem that can be resolved with a retest.

> **Pro Tip**: The terms "FDT" (Field Diagnostic Tool), "fieldiag," and "OneDiag" often refer to the same underlying diagnostic framework. The specific binary name may vary by package version and GPU architecture.

---

## Architecture-Specific Coverage

### GB200 NVL72 (Rack-Level Diagnostics)

The GB200 NVL72 is a rack-scale Grace-Blackwell NVLink system containing:
- **18 compute trays** (4 GPUs per tray = 72 GPUs total)
- **9 NVSwitch trays** (each containing 2 NVSwitch ASICs)

This architecture requires a **staged validation approach** with two distinct test levels:

| Level | Scope | Description |
|-------|-------|-------------|
| **L10** | Compute Tray | Individual tray validation (4 GPUs + local NVLink) |
| **L11** | Full Rack | Complete rack validation (72 GPUs + 18 NVSwitches) |

**Critical Rule**: L11 rack-level tests should only be run after **all 18 compute trays pass L10**. Running L11 on a partial rack can cause false NVLink failures due to interference from hosts not participating in the test.

#### Running GB200 Partner Diagnostics

```bash
# Field Level 1 (shorter, basic validation)
./partnerdiag --field --level1 --primary_diag_ip=<PRIMARY_IP>

# Field Level 2 (comprehensive validation)
./partnerdiag --field --level2 --primary_diag_ip=<PRIMARY_IP>

# Manufacturing diagnostics - Switch trays
./partnerdiag --mfg --run_spec=spec_gb200_nvl_72_2_4_switch_nodes_partner_mfg.json --primary_diag_ip=<PRIMARY_IP>

# Manufacturing diagnostics - Compute trays
./partnerdiag --mfg --run_spec=spec_gb200_nvl_72_2_4_compute_nodes_partner_mfg.json --primary_diag_ip=<PRIMARY_IP>
```

> **Note**: The exact spec filenames and flag syntax may vary by FDT package version. Always refer to the README.txt included with your specific diagnostic package.

#### Execution Modes

Partner Diagnostics supports two execution modes:

| Mode | Description | When to Use |
|------|-------------|-------------|
| **Self-Hosted** | Primary node auto-distributes binaries to secondary nodes via SSH | Simpler setup, fewer moving parts |
| **Managed** | External orchestrator controls job scheduling and log handling | Production automation, centralized logging |

### Hopper/Blackwell HGX-8 (Single-Node Diagnostics)

For HGX-8 systems (H100, H200, B200), Partner Diagnostics runs on a single node:

```bash
# Manufacturing mode
sudo ./partnerdiag --mfg --run_spec=spec_blackwell-hgx-8-gpu_partner_mfg.json --run_on_error --no_bmc

# Field diagnostics (default: level2)
sudo ./partnerdiag --field --run_on_error --no_bmc

# Field diagnostics with specific level
sudo ./partnerdiag --field --level1 --run_on_error --no_bmc

# Run specific tests only
sudo ./partnerdiag --field --run_on_error --no_bmc --test=pcie,connectivity
```

### Single-GPU Field Diagnostics (Universal FDT)

For individual GPU cards or simpler configurations:

```bash
# Standard execution - runs on all detected GPUs
sudo ./fieldiag

# Run on specific device
sudo ./fieldiag device=0

# NVLink tests only
sudo ./fieldiag only_nvlink

# Quick basic system test (useful for row remapping status)
sudo ./fieldiag BS_Test
```

**Return Codes:**
- `0` = PASS - Hardware passes diagnostics
- `1` = FAIL - Hardware has failed diagnostics
- `2` = RETEST - Pre-check failed; correct the environment and retest

**Supported Architectures (Universal FDT):**
- **Ampere**: A100, A40, A10, A30, A2
- **Hopper**: H100, H200, H800
- **Blackwell**: B200, GB200

---

## Test Coverage and Duration

The following table summarizes typical test coverage across diagnostic levels. Durations are approximate and vary by firmware version and system configuration.

| Test Name | L10 Level 1 | L10 Level 2 | L11 Rack | Approx. Duration | Description |
|-----------|:-----------:|:-----------:|:--------:|------------------|-------------|
| Connectivity | ✓ | ✓ | ✓ | 12-16 min | NVLink & PCIe connectivity validation |
| NvlBwStress | ✓ | ✓ | ✓ | ~21 min | GPU-GPU NVLink bandwidth stress |
| ThermalSteadyState | ✓ | ✓ | ✓ | 15-22 min | CPU+GPU power/thermal stress |
| CpuGpuSyncPulsePower | ✓ | ✓ | ✓ | 20-23 min | Synchronous power pulsing stress |
| Gpustress | ✓ | ✓ | - | ~4 min | GPU compute stress |
| Gpumem | ✓ | ✓ | - | ~1 min | GPU memory tests |
| Pcie | ✓ | ✓ | - | ~6 min | PCIe bandwidth/eye diagram |
| C2C | ✓ | ✓ | - | ~2 min | Chip-to-chip connectivity |
| DimmStress | ✓ | ✓ | - | ~5 min | System memory stress |

> **Note**: These durations are from a specific FDT build and may differ in your environment. Refer to your spec JSON files for authoritative timing.

### Complete FDT Test ID Reference

The FDT suite includes the following tests. Understanding what each test validates helps identify which component is likely failing:

| Test ID | Category | Description |
|---------|----------|-------------|
| **Checkinforom** | Pre-flight | Validates GPU InfoROM integrity and firmware metadata |
| **environmentcheck** | Pre-flight | Verifies system environment meets test requirements (drivers, permissions, resources) |
| **Inventory** | Pre-flight | Enumerates and validates GPU/NVSwitch device discovery and topology |
| **TegraCpu** | Grace CPU | Tests Grace CPU core functionality and basic operations |
| **TegraCpu4** | Grace CPU | Extended Grace CPU validation (4-thread workload) |
| **TegraCpu5** | Grace CPU | Extended Grace CPU validation (5-thread workload) |
| **TegraMemory** | Grace CPU | Tests Grace CPU memory subsystem (LPDDR5X) |
| **CpuMemorySweep** | Grace CPU | Comprehensive memory address sweep across CPU memory |
| **TegraClink** | Grace CPU | Validates C2C (Chip-to-Chip) link between Grace CPUs |
| **Gpustress** | GPU Compute | CUDA compute stress test on GPU shader cores |
| **Gpumem** | GPU Memory | GPU HBM memory bandwidth and ECC validation |
| **Pcie** | Interconnect | PCIe link training, bandwidth, and eye diagram tests |
| **C2C** | Interconnect | Chip-to-Chip NVLink between Grace CPU and Blackwell GPU |
| **CPUVDD_PowerStress** | Power | CPU voltage domain power stress test |
| **CpuGpuConstPower** | Power | Constant power draw stress across CPU and GPU |
| **Connectivity** | NVLink | NVLink and PCIe topology connectivity validation across all GPUs/NVSwitches |
| **NvlBwStress** | NVLink | NVLink bandwidth stress test (standard) |
| **NvlBwStressBg610** | NVLink | NVLink bandwidth stress with BG610 traffic pattern |
| **NvlBwStressBg610Pulsy** | NVLink | NVLink bandwidth stress with pulsed BG610 traffic (thermal cycling) |
| **DimmStress** | Memory | System DIMM/LPDDR memory stress test |
| **CpuGpuSyncPulsePower** | Power | Synchronized pulsed power stress across CPU and GPU (tests power delivery) |
| **ThermalSteadyState** | Thermal | Sustained thermal stress to validate cooling under steady-state load |
| **SyslogErrorCheck** | Log Check | Scans syslog for errors during/after test execution |
| **KernLogErrorCheck** | Log Check | Scans kernel log for errors (XID, driver errors) |
| **DmesgLogErrorCheck** | Log Check | Scans dmesg for errors (hardware faults, driver messages) |
| **SyslogAERCheck** | Log Check | Scans syslog for PCIe Advanced Error Reporting (AER) events |
| **KernLogAERCheck** | Log Check | Scans kernel log for PCIe AER events |
| **DmesgLogAERCheck** | Log Check | Scans dmesg for PCIe AER events |

**Test Categories Explained:**

| Category | Purpose |
|----------|---------|
| **Pre-flight** | Validates environment before running stress tests |
| **Grace CPU** | Tests specific to the Grace ARM CPU in GB200 systems |
| **GPU Compute** | CUDA shader and compute unit validation |
| **GPU Memory** | HBM memory subsystem testing |
| **Interconnect** | PCIe and C2C link validation |
| **NVLink** | GPU-to-GPU and GPU-to-NVSwitch fabric testing |
| **Power** | Power delivery and voltage regulation stress |
| **Thermal** | Cooling system validation under load |
| **Log Check** | Post-test log scanning for errors that occurred during execution |

---

## Understanding MODS Error Codes

MODS (Modular Operating-system Development Suite) error codes are the primary output from FDT failures. Understanding how to interpret them is crucial for efficient triage.

### Error Code Structure

MODS error codes follow the format: `MODS-xxxxxxxxx###` where:
- `xxxxxxxxx` = Test/context identifier (generally not actionable)
- `###` = **The specific error code** (focus on these last 2-3 digits)

**Example:**
```
MODS-000000000140 | NvlBwStressBg610Pulsy | nvlink | concurrent | NVLink | 0009:01:00.0_SN_1655124012808
```
The key is `140` - this indicates an NVLink bus error.

> **Pro Tip**: DGX error codes follow the same pattern (`DGX-xxxxxxxxx###`). Treat them identically for triage purposes.

### Error Code Categories

#### Non-RMA Eligible (Software/Configuration Issues)

**Action**: Update to latest FDT version, verify firmware recipe alignment, retest. If persistent, file NVBug.

| Code | Message | Typical Cause |
|------|---------|---------------|
| 002 | Software error | Test framework issue |
| 008 | Bad parameter passed to function | Configuration mismatch |
| 021 | Script failed to execute | Environment/setup issue |
| 077 | Timeout error | System load, thermal throttling |
| 144 | NVIDIA CUDA error | Driver/firmware mismatch |
| 240 | Unexpected result from hardware | Transient issue |
| 272 | Read parameter differs from expected | Configuration drift |
| 318 | ECC correctable error in L2 over threshold | Often transient |
| 779 | Voltage value out of range | Power delivery issue |
| 818 | MODS detected an assertion failure | Test framework issue |

#### RMA-Eligible (Hardware Failures)

**Action**: Verify firmware is current, retest once. If error persists, proceed with RMA.

| Code | Message | Component |
|------|---------|-----------|
| 083 | CRC/Checksum miscompare | Memory/data path |
| 097 | Unexpected device interrupts | GPU silicon |
| 194 | Bad memory | HBM/DRAM |
| 276 | Hardware reports wrong status | GPU silicon |
| 316 | ECC correctable error over threshold | Memory |
| 319 | ECC uncorrectable error in L2 | L2 cache |
| 320 | ECC correctable error over threshold | Memory |
| 321 | ECC uncorrectable error | Memory |
| 341 | Buffer mismatch | Memory/data path |
| 363 | Row remapping failed | HBM (exhausted spare rows) |
| 539 | NVRM Generic Falcon Error | GPU microcontroller |
| 541 | NVRM Detected memory error | Memory subsystem |
| 582 | GPU Stress Test found pixel miscompares | Compute units |

#### NVLink-Related (Rack-Level Issues)

**Action**: Treat as fabric-level connectivity issue. Follow NVLink failure checklist (Section 6).

| Code | Message | Typical Cause |
|------|---------|---------------|
| 014 | Low bandwidth | Fabric degradation, link training issues |
| 140 | NVLink bus error | Link-level error, possible cable/connector issue |
| 688 | NVRM invalid state or config | Fabric registration incomplete |

> **Critical**: NVLink failures often indicate rack-level issues, not individual GPU problems. Do NOT immediately RMA a compute tray for NVLink errors—follow the full triage workflow first.

#### Other Non-NVLink Failures

| Code | Message | Suggested Action |
|------|---------|------------------|
| 124 | Invalid InfoROM | Check firmware, run inforom recovery tool, retest. If still failing, RMA. |
| 143 | PCI Express bus error | Ensure GPU/NVSwitch devices detected on lspci, retest. If still failing, RMA. |
| 167 | GFW boot reported a failure | Check firmware, reboot, verify devices on lspci, retest. If still failing, file NVbug. |
| 220 | PCIE device not found | Check firmware, cold reboot, retest. If still failing, RMA. |
| 317 | ECC uncorrectable error in FB | Check firmware, power cycle, retest. If still failing, RMA. |
| 679 | NVRM invalid argument | Check firmware, run inforom recovery tool, retest. If still failing, RMA. |
| 936 | TLW Error | If fatal, power cycle; otherwise ignore. |

---

## Log File Locations and Interpretation

### GB200 FDT Log Paths

FDT logs are stored on local NVMe storage (typically a RAID-1 array):

```
/local/FDT/629-XXXXX-XXXX-FLD-XXXXX/dgx/logs-<YYYYMMDD>-<HHMMSS>/
├── fieldiag_summary.log          # Overall summary - start here
├── run.log                       # Execution timeline
├── <test_id>/
│   └── <GPU_PCI_ADDR_GPU_SN>/
│       ├── fieldiag.log          # Detailed test log
│       └── fieldiag.json         # Machine-readable results
└── COMPUTE_NODE_X/               # Multi-node test logs (L11)
    └── connectivity/
        └── <GPU_PCI_ADDR>/
            └── fieldiag.log
```

### Recovering Logs After Power Cycle

The `/local/FDT` directory is stored on NVMe and disappears after a power cycle. To recover:

```bash
# Find the RAID device
ls /dev | grep -i md
# Output: md0

# Mount the device
sudo mount /dev/md0 /local

# Access FDT logs
cd /local/FDT
```

### Retrieving Logs from OCI Object Storage

FDT logs are automatically uploaded to Object Storage during test execution:

```bash
# Authenticate to OCI
oci session authenticate --profile DEFAULT --tenancy-name bmc_operator_access --region <REGION>

# List available logs for a host
oci os object list -ns hpc -bn Debug --auth security_token --profile DEFAULT --prefix <HOST_SERIAL>

# Download specific log file
oci os object get -ns hpc -bn Debug --auth security_token --profile DEFAULT \
    --name <OBJECT_PATH> --file <LOCAL_FILENAME>
```

> **Note**: Bucket names and namespaces shown are examples. Your environment may use different values.

---

## Triage Workflow for GB200 FDT Failures

When multiple MODS codes appear in a failure log, follow this priority order:

### Priority Order for Triage

1. **Check for XID errors in dmesg/kernel logs first**
2. **Check NVLink-related failures** (codes 014, 140, 688)
3. **Check General Non-RMA-eligible failures** (software/config)
4. **Check Non-NVLink RMA-eligible failures** (hardware)
5. **Check Other Non-NVLink failures**

> **Why XIDs First?** XID errors are reported directly from the NVIDIA GPU driver to the kernel log. They often reveal the root cause before MODS codes are even generated.

### Key XID Errors to Watch

| XID | Description | Typical Action |
|-----|-------------|----------------|
| 31 | GPU memory page fault | Check memory, may need RMA |
| 45 | Preemptive cleanup | Often transient |
| 48 | Double Bit ECC Error | RMA candidate |
| 63 | Row remapping failure | RMA (exhausted spare rows) |
| 74 | NVLink error | Check fabric, cables |
| 109 | NVSwitch error | Check switch tray |

### NVLink Failure Checklist

Before RMAing any component for NVLink failures:

1. **Verify rack firmware version** matches recommended recipe
   ```bash
   # Using HOPS CLI
   hops-cli
   > host <rack_serial>
   > firmware_inventory
   ```

2. **Check fabric registration state**
   ```bash
   nvidia-smi -q | grep Fabric -A 9
   ```
   All GPUs should show `State: Completed` and `Status: Success`.

3. **Inspect NVSwitch Controller Fabric Manager logs**
   ```bash
   # SSH to NVSwitch controller
   cat /var/log/nmx/nmx-c/fabricmanager.log

   # Search for Fatal errors
   grep -i "Fatal" fabricmanager.log* -A 11
   ```

4. **Verify all 18 compute trays were part of the test**
   - If fewer than 18 hosts participated, NVLink failures may be caused by interference from non-participating hosts
   - Re-run with full rack before proceeding to RMA

5. **Check NVLink status**
   ```bash
   nvidia-smi nvlink --status
   ```

6. **Gather NVDebug logs** (includes nvidia-bug-report.sh)
   ```bash
   cd ~/nvdebug
   sudo ./nvdebug -b "GB200 NVL" -t arm64 --local -v -o ./nvdebug-logs
   ```

### Triage Decision Tree

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

## Critical OCI Guardrails

These rules are essential for preventing unnecessary damage and avoiding common pitfalls:

### 1. DO NOT Reseat GB200 Trays

> **NVIDIA Warning**: "Reseating the trays can bend the pins on the tray. Reseating multiple times is likely to cause damage to the NVLink connectivity."

This has been identified as a root cause of hosts/racks being stuck in CPV for weeks with repeated NVLink failures.

### 2. Recipe Alignment First

Many FDT failures are caused by firmware/software recipe drift, not hardware defects. **Always verify recipe alignment before running diagnostics:**

- Check current firmware version against expected recipe
- Ensure all trays on the rack are running the same firmware version
- Partial racks with mixed firmware can cause unpredictable failures

### 3. FDT Does NOT Test RDMA

FDT tests cover:
- NVLink (GPU-to-GPU within rack)
- PCIe
- GPU compute and memory

FDT does **NOT** test:
- RDMA network (host-to-host over Ethernet/InfiniBand)
- SmartNIC connectivity

**Do NOT cut DO tickets for RDMA issues based on FDT failures.** RDMA connectivity is validated separately via:
- Cable validation tests
- mlx checks
- WPA (Wait for Authorization) tests

### 4. L10 Before L11

Never run L11 rack-level tests until all 18 compute trays pass L10. Running L11 on a partial rack will likely produce false NVLink failures.

### 5. Check XID Errors First

Before diving into MODS code analysis, always check:
```bash
dmesg | grep -i "NVRM: Xid"
```

XID errors often reveal the root cause more directly than MODS codes.

---

## Useful Commands Reference

### GPU Inventory and Identification

```bash
# Get comprehensive GPU info
nvidia-smi -q | egrep "GPU 000|Module Id|Serial Number|GPU Fabric GUID"

# Run across multiple hosts with clush
clush -l ubuntu -w <host1>,<host2>,... \
    "nvidia-smi -q | egrep \"GPU 000|Module Id|Serial Number\""
```

### Fabric and NVLink Status

```bash
# Check fabric registration state
nvidia-smi -q | grep Fabric -A 9

# Check NVLink status
nvidia-smi nvlink --status

# Check NVLink error counters
nvidia-smi nvlink -e
```

### Firmware Version Checking

```bash
# Using HOPS CLI
hops-cli
> host <host_serial>
> info | awk '{print $18}'  # Get rack serial
> host <rack_serial>
> firmware_inventory
```

### Log Collection

```bash
# Generate nvidia-bug-report
sudo nvidia-bug-report.sh

# NVDebug collection (GB200)
cd ~/nvdebug
sudo ./nvdebug -b "GB200 NVL" -t arm64 --local -v -o ./nvdebug-logs

# SOSReport (system diagnostics)
sudo sosreport
```

---

## OCI Automation Integration

OCI uses automated orchestration to run FDT at scale. Understanding these patterns helps interpret test results.

### Burn-in Orchestrator Pattern

The burn-in orchestrator automates FDT execution across GPU shapes:

```python
# FDT version selection based on GPU shape (example pattern)
fdt_versions = {
    'BM.GPU.H100.8': '629-24287-XXXX-FLD-40946.tgz',
    'BM.GPU.B200.8': '629-26287-0103-FLD-43576.tgz',
    # GB200 rack-level tests use different packages
    'gb200_compute_tray': '629-24975-0000-FLD-50447-rev2',
    'gb200_rack_level': '629-24972-4975-FLD-50448-rev3',
}
```

### FDT Log Parsing with oci-dr-hpc-v2

The **oci-dr-hpc-v2** repository provides purpose-built tooling for parsing GB200 FDT results. Instead of manually extracting MODS codes, you can use this parser to:

- Extract structured data from raw FDT logs
- Map MODS error codes to actionable recommendations
- Aggregate results across multiple compute trays in L11 rack tests
- Generate triage recommendations based on error patterns

**Repository**: `https://github.com/ai2-compute-gpu/oci-dr-hpc-v2` (OCI internal)

**Key parsing patterns used:**

```python
# MODS code extraction pattern
import re

# Match MODS/DGX error lines from FDT output
mods_pattern = re.compile(r'^(MODS-\d+)\s+\|\s+(\w+)\s+\|\s+(\w+)\s+\|\s+(\w+)')

# GPU field diagnostics error pattern
gpu_pattern = re.compile(r'^(GPU\d).*\[(.*)\].*\s+Error code\s+(\w+)\s+(.*)')

# IST mode MODS code pattern
ist_pattern = re.compile(r'^(MODS-\d+)\s+\|\s+(\w+)\s+\|\s+(\w+)\s+\|\s+(\w+)\s+\|\s+(\w+)\s+\|\s+SXM(\d)\s+\|\s+(\w+.*)')

# Non-failure exit codes to filter out
non_failure_codes = ['MODS-000000000210', 'MODS-000000000301', 'MODS-000000000000']
```

**Using the parser:**

The parser generates structured CSV output files:
- `hosts.csv` - Host-level pass/fail results
- `tests.csv` - Test-level aggregates
- `jobs.csv` - Individual job records
- `failed_gpus.csv` - GPU failure details with MODS codes and serial numbers

> **Pro Tip**: For manual triage, you can use the same regex patterns above to grep through `fieldiag_summary.log` and extract MODS codes with their associated GPU serial numbers and test names.

### Dynamic Spec Generation

For rack-level tests, spec files are generated dynamically based on host discovery:

```bash
# Query tray index from each host
nvidia-smi -q | grep Tray | uniq
# Output: Tray Number : 7

# Map tray index to rack slot
# Tray indices 0-7 → Rack slots 1-8
# Tray indices 8-17 → Rack slots 19-27 (above switch trays)
```

---

## Chassis Slot Mapping Table

For NVLink triage, use this table to map error locations to physical trays:

| Chassis Slot | Tray Index | Tray Name | NVSwitch ASICs |
|:------------:|:----------:|-----------|----------------|
| 27 | 17 | Compute Tray 18 | N/A |
| 26 | 16 | Compute Tray 17 | N/A |
| 25 | 15 | Compute Tray 16 | N/A |
| 24 | 14 | Compute Tray 15 | N/A |
| 23 | 13 | Compute Tray 14 | N/A |
| 22 | 12 | Compute Tray 13 | N/A |
| 21 | 11 | Compute Tray 12 | N/A |
| 20 | 10 | Compute Tray 11 | N/A |
| 19 | 9 | Compute Tray 10 | N/A |
| 18 | 8 | Compute Tray 9 | N/A |
| 17 | 8 | Switch Tray 9 | ffff:0d:10.0, ffff:0d:11.0 |
| 16 | 7 | Switch Tray 8 | ffff:0d:0e.0, ffff:0d:0f.0 |
| 15 | 6 | Switch Tray 7 | ffff:0d:0c.0, ffff:0d:0d.0 |
| 14 | 5 | Switch Tray 6 | ffff:0d:0a.0, ffff:0d:0b.0 |
| 13 | 4 | Switch Tray 5 | ffff:0d:08.0, ffff:0d:09.0 |
| 12 | 3 | Switch Tray 4 | ffff:0d:06.0, ffff:0d:07.0 |
| 11 | 2 | Switch Tray 3 | ffff:0d:04.0, ffff:0d:05.0 |
| 10 | 1 | Switch Tray 2 | ffff:0d:02.0, ffff:0d:03.0 |
| 9 | 0 | Switch Tray 1 | ffff:0d:00.0, ffff:0d:01.0 |
| 8 | 7 | Compute Tray 8 | N/A |
| 7 | 6 | Compute Tray 7 | N/A |
| 6 | 5 | Compute Tray 6 | N/A |
| 5 | 4 | Compute Tray 5 | N/A |
| 4 | 3 | Compute Tray 4 | N/A |
| 3 | 2 | Compute Tray 3 | N/A |
| 2 | 1 | Compute Tray 2 | N/A |
| 1 | 0 | Compute Tray 1 | N/A |

---

## RAS Guide Quick Reference

### Key NVOnline Document IDs

For detailed error code references and RMA procedures:

- **PID 1116117** - Server RAS Guide
- **PID 1109712** - Debug and RAS Guide for NVIDIA Data Center Products
- **PID 1138824** - Multi Node NVLink Troubleshooting Guide

### In-System Test (IST)

IST is a newer, more comprehensive test mode that runs diagnostics in-situ:

```bash
# IST mode execution (example)
./fieldiag.sh --no_bmc --skip_os_check --ist
```

IST requires a separate image download and has different requirements than standard FDT. Contact CPV Tier 2 for IST-specific guidance.

---

## Escalation Paths

When runbook procedures don't resolve the issue:

| Situation | Action |
|-----------|--------|
| MODS code not in runbook | Escalate to CPV Tier 2 via GPUFM queue |
| Runbook doesn't resolve issue | Create HPC JIRA-SD ticket |
| Urgent/time-sensitive | Reach out to #cpv-triage Slack channel |
| Partial rack with customer hosts | Engage SCE team before any RMA/DO action |

### Filing Effective Tickets

Include in your ticket:
1. Host/rack serial number
2. FDT test logs (PAR links or attached)
3. MODS codes observed
4. Triage steps already attempted
5. Firmware version currently installed
6. nvidia-bug-report output

---

## Summary: The Essential Checklist

**Before running FDT:**
- [ ] Verify firmware recipe alignment
- [ ] Ensure all required hosts are available (18 for L11)
- [ ] Confirm no customer instances on rack (or engage SCE)

**When triaging failures:**
- [ ] Check XIDs in kernel logs first
- [ ] Identify MODS code category (Non-RMA, RMA, NVLink)
- [ ] For NVLink errors: verify full rack participation
- [ ] Never reseat trays without explicit approval
- [ ] Don't cut RDMA tickets for FDT failures

**When escalating:**
- [ ] Collect all required logs (FDT, NVDebug, dmesg)
- [ ] Document triage steps attempted
- [ ] Include firmware version information
- [ ] File ticket in appropriate queue (HPC/GPUFM)

---

## References

### NVIDIA Documentation
- Debug and RAS Guide for NVIDIA Data Center Products (DA-11437-001)
- GB200/GB300 Partner Diagnostics User Guide (DU-11965-001)
- GB NVL72 System Validation Guide (VG-12022-001)
- GPU RAS Architecture Overview
- NVIDIA Grace RAS Overview Application Note

### OCI Internal Resources
- GB200/GB300 Shape Runbook: Partner Diagnostics Fail/Mod Codes Mapping
- CPV FDT NVLink Runbook Diagram (NVBug: 5573659)
- HOPS Pinning Golden Set Config Source of Truth
- GPUPR Automated RMA Runbooks

### OCI Automation Repositories (Internal)
- **Burn-in Orchestrator** - FDT invocation, test configuration patterns, log collection automation
- **OCI DR HPC v2 (GB200 FDT Parser)** - FDT log parsing, error code interpretation, result aggregation

---

*Last updated: November 2025*

*This document contains information derived from NVIDIA partner documentation. Command syntax, error codes, and procedures may vary by FDT version. Always refer to the README and release notes included with your specific diagnostic package.*
