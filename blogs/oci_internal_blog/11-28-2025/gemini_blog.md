Here is the draft for the internal Oracle blog post, structured according to your guidelines and incorporating the provided source materials.

-----

# Partner Diagnostics, FDT, and Universal FDT: The OCI Engineer’s Guide to GB200 NVL72 & Beyond

**Target Audience:** OCI CPV, IBE, and HPC Engineering Teams  
**Focus:** GB200 NVL72, HGX-8, Triage Workflows, and Automation

-----

## 1\. Introduction: De-mystifying the Toolset

In the world of OCI’s high-performance compute, validating GPU health requires precision. NVIDIA provides three primary diagnostic suites. While they share the underlying MODS framework, their use cases differ significantly.

  * **Partner Diagnostics (partnerdiag):** This is the authoritative, multi-node diagnostic tool. It is the standard for **GB200 NVL72** rack-level validation (L11) and **HGX-8** systems. It uses JSON specifications to orchestrate complex tests across fabrics.
  * **Single-GPU Field Diagnostics (fieldiag/FDT):** The legacy "Field Diagnostic Tool" focused on individual PCIe or SXM cards (e.g., A100 PCIe). It is used for isolation testing on specific devices.
  * **Universal FDT:** A unified package supporting multiple architectures (Ampere, Hopper, Blackwell) in a single binary. It simplifies deployment across mixed fleets but operates largely at the single-node level.

> **Pro Tip:** In OCI documentation, you will see "FDT", "Fieldiag", and "OneDiag" used interchangeably. Functionally, they usually refer to the same underlying MODS-based infrastructure.

-----

## 2\. Architecture-Specific Execution

### 2.1 GB200 NVL72 (Rack Level L11)

The GB200 NVL72 is a rack-scale system with 18 compute trays (72 GPUs) and 9 NVSwitch trays. Diagnostics here are split into two strictly ordered levels:

1.  **L10 (Tray Level):** Validates individual compute trays (GPUs, Grace CPU, local NVLink).
2.  **L11 (Rack Level):** Validates the full NVLink fabric and cross-node connectivity.

**Crucial Rule:** You must pass L10 on all 18 compute trays before attempting L11. Partial rack runs can produce false NVLink failures.

**Execution Commands (Field Mode):**

For standard CPV/IBE validation, we use `partnerdiag` in field mode. Note the requirement for a `primary_diag_ip`.

```bash
# GB200 NVL72 Field Level 1 (Short duration, ~2-3 hours)
./partnerdiag --field --level1 --primary_diag_ip=<IP>

# GB200 NVL72 Field Level 2 (Comprehensive, ~4-6 hours)
./partnerdiag --field --level2 --primary_diag_ip=<IP>
```

**Manufacturing Mode (Bring-up Only):**

These tests are destructive and should not be run in production CPV without specific direction.

```bash
# Validate Switch Trays
./partnerdiag --mfg \
  --run_spec=spec_gb200_nvl_72_2_4_switch_nodes_partner_mfg.json \
  --primary_diag_ip=<IP>

# Validate Compute Trays
./partnerdiag --mfg \
  --run_spec=spec_gb200_nvl_72_2_4_compute_nodes_partner_mfg.json \
  --primary_diag_ip=<IP>
```

### 2.2 Hopper/Blackwell HGX-8 (Single Node)

For HGX systems (H100/H200/GB200-HGX), Partner Diag runs at a single-node scope.

```bash
# Field diagnostics (Standard validation)
sudo ./partnerdiag --field --run_on_error --no_bmc

# Targeted test execution (e.g., PCIe only)
sudo ./partnerdiag --field --run_on_error --no_bmc --test=pcie,connectivity
```

### 2.3 Single GPU / Universal FDT

Used for isolation on specific cards across Ampere, Hopper, and Blackwell.

```bash
# Run on all detected GPUs
sudo ./fieldiag

# Run on a specific GPU (Device 0)
sudo ./fieldiag device=0

# Quick Basic System Test (BS_Test)
sudo ./fieldiag BS_Test
```

-----

## 3\. Test Coverage and Durations

The following table summarizes the test coverage for GB200 NVL72. Note that L11 Rack tests focus heavily on the fabric and power dynamics across the rack.

| Test Name | L10 Level 1 | L10 Level 2 | L11 Rack | Approx Duration | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Connectivity** | ✓ | ✓ | ✓ | \~12–16 min | NVLink and PCIe link/bandwidth checks |
| **NvlBwStress** | ✓ | ✓ | ✓ | \~21 min | Cross-GPU NVLink bandwidth stress |
| **ThermalSteadyState** | ✓ | ✓ | ✓ | \~15–22 min | CPU+GPU steady-state power stress |
| **CpuGpuSyncPulsePower** | ✓ | ✓ | ✓ | \~20–23 min | Pulsed workload to stress power delivery |
| **Gpustress** | ✓ | ✓ | – | \~4 min | GPU compute and ALU stress |
| **Gpumem** | ✓ | ✓ | – | \~1 min | GPU memory pattern and ECC checks |
| **Pcie** | ✓ | ✓ | – | \~6 min | PCIe integrity tests |

-----

## 4\. Understanding MODS Error Codes

Failures are reported as `MODS-xxxxxxxxx###`. The actionable intelligence is in the last 3 digits (`###`).

### 4.1 Non-RMA Eligible (Software/Config)

These often indicate environment issues rather than hardware defects. **Action:** Update firmware/FDT and retest.

  * **002:** Software error
  * **008:** Bad parameter passed to function
  * **021:** Script failed to execute
  * **077:** Timeout error (often FW or Fabric Manager related)
  * **144:** CUDA error

### 4.2 RMA-Eligible (Hardware Failures)

These codes usually necessitate an RMA after firmware verification.

  * **083:** CRC/Checksum miscompare
  * **097:** Unexpected device interrupts
  * **194:** Bad memory (Compute returning incorrect results)
  * **316–321:** ECC errors (Correctable/Uncorrectable over threshold)
  * **363:** Row remapping failed

### 4.3 NVLink-Specific Failures

  * **140:** NVLink bus error
  * **688:** NVRM invalid state/config

> **Pro Tip:** For NVLink errors (140, 688, 014), treat the issue as a rack-level topology or configuration problem first. Do not immediately assume a bad GPU.

-----

## 5\. Log File Locations

For GB200, logs are structured hierarchically.

**Primary Path:**
`/local/FDT/629.../dgx/logs-<yyyymmdd>-<hhmmss>/`

**File Structure:**

  * `fieldiag_summary.log`: **Start here.** Contains the high-level pass/fail summary.
  * `<test_id>/<GPU_PCI_ADDR>/fieldiag.log`: Detailed per-GPU logs.
  * `COMPUTE_NODE_X/connectivity/`: Logs for multi-node tests.

**Missing /local?**
If the host was power-cycled, the RAID array may not be mounted.

```bash
ls /dev | grep -i md
sudo mount /dev/md0 /local
cd /local/FDT
```

-----

## 6\. GB200 Triage Workflow & Guardrails

OCI has established a strict triage order for GB200 failures to prevent unnecessary hardware swaps.

**Priority Order:**

1.  **Check XID Errors (dmesg) first:** XID 48 (ECC), 63 (Row Remap), and 74 (NVLink) are critical.
2.  **Handle NVLink Failures:** Check Fabric Manager and Switch Trays.
3.  **Handle Software/Config:** Update recipe/FDT.
4.  **Handle RMA-Eligible Hardware:** GPU/Memory replacements.

### The "Don't Reseat" Rule

> **WARNING:** NVIDIA explicitly advises **AGAINST** reseating GB200 compute or switch trays. Reseating can bend the pins on the tray backplane. Repeated reseating will cause permanent damage to NVLink connectivity.

**NVLink Failure Checklist:**

1.  **Recipe Alignment:** Ensure Rack Firmware matches the HOPS-pinned golden recipe.
2.  **Fabric Registration:** Run `nvidia-smi -q | grep Fabric -A 9` to check registration status.
3.  **Fabric Manager Logs:** Inspect NVSwitch Controller logs for fatal events.
4.  **RDMA Separation:** FDT does *not* test RDMA (ConnectX-7/8). Do not cut DO tickets for RDMA cabling based on FDT failures.

-----

## 7\. OCI Automation Integration

We automate these workflows using two primary repositories.

### 7.1 Burn-in Orchestrator

*Repo:* `https://github.com/rikkisnah/burn-in-orchestrator`

This tool handles the invocation of FDT across the cluster. It dynamically selects the correct `partnerdiag` binary and JSON spec based on the shape (e.g., GB200 vs H100).

**Example: Dynamic Spec Generation**

```python
def create_hosts_entry(host_data):
    new_hosts = {}
    for host_line in host_data:
        # Determine tray index for GB200 mapping
        cmd = f"ssh ubuntu@{host_line} 'nvidia-smi -q | grep Tray | uniq'"
        host_index = int(subprocess.check_output(cmd).decode().split()[-1])
        
        # Map to spec format
        current_host = {
            "user": "ubuntu",
            "node_type": "compute_node",
            "host_id": f"COMPUTE_NODE_{host_index}",
            "rack_slot": host_index + 10 if host_index > 7 else host_index + 1
        }
        new_hosts[host_line] = current_host
    return new_hosts
```

### 7.2 OCI DR HPC v2 (GB200 FDT Parser)

*Repo:* `https://github.com/ai2-compute-gpu/oci-dr-hpc-v2`

This parser consumes the `fieldiag_summary.log` and `fieldiag.json` to generate actionable recommendations, mapping MODS codes to OCI-specific fault categories.

**Example: Error Code Mapping**

```go
// Configuration for mapping regex patterns to recommendations
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
      "regexes": ["^(DGX|MODS)\\-.{9}(083|194|316)(.*\\|){6}.*"],
      "recommendation": [
        "RMA-Eligible Hardware Failure",
        "Verify firmware and proceed to RMA"
      ]
    }
  ]
}
```

-----

## 8\. Useful Commands Cheat Sheet

**GPU & Fabric Inventory:**

```bash
nvidia-smi -q | egrep "GPU 000|Module Id|Serial Number|GPU Fabric GUID"
```

**Check Fabric Registration:**

```bash
nvidia-smi -q | grep Fabric -A 9
```

**Pull FDT Logs from Object Storage:**

```bash
oci session authenticate --profile DEFAULT --tenancy-name bmc_operator_access --region r1
oci os object list -ns hpc -bn Debug --auth security_token --profile DEFAULT --prefix <HOST_SERIAL>
```

**Generate NVDebug (Bug Report):**

```bash
sudo nvidia-bug-report.sh
```

For deep dives, always refer to the **NVIDIA Server RAS Catalog (PID 1116117)** and the **Debug and RAS Guide (DA-11437)**.