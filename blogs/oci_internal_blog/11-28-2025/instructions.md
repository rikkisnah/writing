# Claude Code Instructions: Partner Diagnostics / FDT / Universal FDT Blog

## Purpose

Write a comprehensive internal Oracle blog post explaining NVIDIA Partner Diagnostics (Partner Diag), Field Diagnostic Tool (FDT), and Universal FDT with focus on GB200 NVL72 racks. The blog should enable readers to:

1. Understand what Partner Diag / FDT / Universal FDT software is
2. Know how to run these diagnostics on different GPU shapes (GB200, H100, etc.)
3. Interpret errors and understand MOD codes / RAS Guide references
4. Troubleshoot common FDT failures

---

## Source Materials Location

All source materials are located in the directory: `/mnt/data/src/rikkisnah/oci-runbooks/blogs/oci_internal_blog/11-28-2025/`

### Primary Documentation (Authoritative - NVIDIA)

```
docs/
├── partnerdiag_docs/          # GB200 NVL72 Partner Diag package
│   ├── README.txt             # Quick start guide
│   ├── relnotes.txt           # Release notes with known issues
│   ├── partnerdiag            # Main executable
│   └── spec_gb200_nvl_72_2_4_*.json  # Test configuration files
├── hopper_parterdiag/         # Hopper/Blackwell HGX-8 Partner Diag
│   ├── README.txt             # Quick start guide  
│   ├── mods_mapping.json      # GPU architecture to MODS version mapping
│   └── spec_blackwell-hgx-8-gpu_*.json  # Test configs
├── 629-int27-diag/            # Single-GPU Field Diagnostics
│   ├── NV_Field_Diag_Software.md  # Field Diag user guide
│   └── mods_mapping.json      # MODS version mappings
├── 629-int27-univ/            # Universal Field Diagnostics
│   └── NV_Field_Diag_Software.md  # Universal FD guide
└── server_ras_catalog/
    └── Server-RAS-Catalog.xlsx  # Error codes reference

pdfs/
├── DA-11437-001_v13.md        # Debug and RAS Guide (ERROR CODES - PRIMARY REFERENCE)
├── DU-11965-001_20.md         # GB200/GB300 Partner Diagnostics User Guide
├── VG-12022-001_v09.md        # GB NVL72 System Validation Guide
├── GPU_RAS-2025Oct21.md       # GPU RAS Architecture overview
├── NVIDIA_Grace_RAS_Overview_App_Note_v08.md  # Grace CPU RAS
└── how-to-handle-fdt-fails-for-shape-gb200.md  # OCI IBE Runbook (TRIAGE PROCEDURES)
```

### OCI Internal Documentation

- `docs/how-to-handle-fdt-fails-for-shape-gb200.md` - The authoritative OCI runbook for GB200 FDT failure triage (also available as `pdfs/how-to-handle-fdt-fails-for-shape-gb200.md`)

### OCI Code Repositories

**Burn-in Orchestrator**
- **GitHub**: `https://github.com/rikkisnah/burn-in-orchestrator`
- **Local Path**: `/mnt/data/src/rikkisnah/burn-in-orchestrator`
- **Purpose**: Automation code that runs FDT at scale
- **Key Areas to Reference**:
  - How FDT tests are invoked programmatically
  - Test configuration patterns and spec file generation
  - Log collection and upload automation
  - Multi-node orchestration patterns

**OCI DR HPC v2 (GB200 FDT Parser)**
- **GitHub**: `https://github.com/ai2-compute-gpu/oci-dr-hpc-v2`
- **Local Path**: `/mnt/data/src/rikkisnah/oci-dr-hpc-v2`
- **Purpose**: Purpose-built code for parsing GB200 FDT results
- **Key Areas to Reference**:
  - FDT log parsing and structured data extraction
  - Error code interpretation automation
  - Result aggregation and reporting
  - Integration with OCI diagnostic workflows

---

## Blog Structure Outline

### 1. Introduction: What is Partner Diagnostics / FDT?

**Key Points to Cover:**
- Partner Diagnostics is NVIDIA's official hardware validation tool for isolating failures
- Different naming conventions: "Partner Diag", "FDT" (Field Diagnostic Tool), "Fieldiag", "OneDiag"
- Three main variants:
  - **Single-GPU Field Diagnostics (fieldiag)** - For individual GPU cards (H100 PCIe, etc.)
  - **Partner Diagnostics (partnerdiag)** - For multi-GPU systems (HGX-8, GB200)
  - **Universal FDT** - Supports multiple GPU architectures in one package

**Source Material:**
- `docs/629-int27-diag/NV_Field_Diag_Software.md` lines 59-99 (Introduction & SKU support)
- `pdfs/DU-11965-001_20.md` lines 155-182 (Partner Diag introduction)

### 2. Architecture-Specific Coverage

#### 2.1 GB200 NVL72 (L11 Rack Level)

**Key Concepts:**
- **L10** = Compute Tray level diagnostics (individual tray validation)
- **L11** = Full rack level diagnostics (72 GPUs across 18 compute trays + 9 NVSwitch trays)
- **Self-Hosted Mode** = Simpler execution where primary node auto-distributes binaries to secondary nodes
- **Managed Mode** = External orchestrator controls job scheduling and log handling

**How to Run:**
```bash
# Field Level 1 (shorter)
./partnerdiag --field --level1 --primary_diag_ip=<IP>

# Field Level 2 (comprehensive)
./partnerdiag --field --level2 --primary_diag_ip=<IP>

# Manufacturing diagnostics (switch trays)
./partnerdiag --mfg --run_spec=spec_gb200_nvl_72_2_4_switch_nodes_partner_mfg.json --primary_diag_ip=<IP>

# Manufacturing diagnostics (compute trays)
./partnerdiag --mfg --run_spec=spec_gb200_nvl_72_2_4_compute_nodes_partner_mfg.json --primary_diag_ip=<IP>
```

**Source Material:**
- `docs/partnerdiag_docs/README.txt` (execution commands)
- `pdfs/DU-11965-001_20.md` lines 2934-3100 (Field Diagnostics Guidelines)
- `docs/partnerdiag_docs/spec_gb200_nvl_72_2_4_field_level1.json` (test configuration example)

#### 2.2 Hopper/Blackwell HGX-8 (Single Node)

**How to Run:**
```bash
# Manufacturing
sudo ./partnerdiag --mfg --run_spec=spec_blackwell-hgx-8-gpu_partner_mfg.json --run_on_error --no_bmc

# Field diagnostics
sudo ./partnerdiag --field --run_on_error --no_bmc

# Run specific tests only
sudo ./partnerdiag --field --run_on_error --no_bmc --test=pcie,connectivity
```

**Source Material:**
- `docs/hopper_parterdiag/README.txt` (execution commands)

#### 2.3 Single GPU Field Diagnostics (Universal FDT)

**How to Run:**
```bash
# Standard execution - runs on all detected GPUs
sudo ./fieldiag

# Run on specific device
sudo ./fieldiag device=0

# Only NVLink tests
sudo ./fieldiag only_nvlink

# Basic system test (quick)
sudo ./fieldiag BS_Test
```

**Supported Architectures:**
- Ampere: A100, A40, A10, A30, A2
- Hopper: H100, H200, H800
- Blackwell: B200, GB200

**Source Material:**
- `docs/629-int27-univ/NV_Field_Diag_Software.md` lines 70-130 (SKU support)
- `docs/629-int27-diag/NV_Field_Diag_Software.md` lines 162-181 (Return codes)

### 3. Test Coverage and Duration

Create a table summarizing tests for each diagnostic level:

| Test Name | L10 Level 1 | L10 Level 2 | L11 Rack | Duration | Description |
|-----------|-------------|-------------|----------|----------|-------------|
| Connectivity | ✓ | ✓ | ✓ | ~12-16 min | NVLink & PCIe validation |
| NvlBwStress | ✓ | ✓ | ✓ | ~21 min | GPU-GPU NVLink bandwidth stress |
| ThermalSteadyState | ✓ | ✓ | ✓ | ~15-22 min | CPU+GPU power stress |
| CpuGpuSyncPulsePower | ✓ | ✓ | ✓ | ~20-23 min | Synchronous pulsing stress |
| Gpustress | ✓ | ✓ | - | ~4 min | GPU compute stress |
| Gpumem | ✓ | ✓ | - | ~1 min | GPU memory tests |
| Pcie | ✓ | ✓ | - | ~6 min | PCIe bandwidth/eye diagram |

**Source Material:**
- `pdfs/DU-11965-001_20.md` lines 3200-3283 (Test duration tables)

### 4. Understanding MODS Error Codes

**Critical Section - Error Code Structure:**

MODS error codes follow the format: `MODS-xxxxxxxxx###` where:
- `xxxxxxxxx` = Test/context identifier (not actionable)
- `###` = Specific error code (the meaningful part - focus on these last 2-3 digits)

**Note:** DGX error codes follow the same pattern: `DGX-xxxxxxxxx###`

**Error Code Categories:**

#### Non-RMA Eligible (Software/Config Issues):
| Code | Message | Action |
|------|---------|--------|
| 002 | Software error | Re-test with latest FDT |
| 008 | Bad parameter | Re-test with latest FDT |
| 021 | Script failed | Re-test with latest FDT |
| 077 | Timeout error | Check firmware, re-test |
| 144 | CUDA error | Check firmware, re-test |

**Action for Non-RMA Codes:** Update to latest FDT version, verify firmware recipe alignment, retest. If persistent, file NVBug.

#### RMA-Eligible (Hardware Failures):
| Code | Message | Action |
|------|---------|--------|
| 083 | CRC/Checksum miscompare | RMA after firmware check |
| 097 | Unexpected device interrupts | RMA after firmware check |
| 194 | Bad memory | RMA after firmware check |
| 316-321 | ECC errors | RMA after firmware check |
| 363 | Row remapping failed | RMA |

**Action for RMA Codes:** Verify firmware is current, retest once. If error persists, proceed with RMA.

#### NVLink-Specific:
| Code | Message | Action |
|------|---------|--------|
| 014 | Low bandwidth | Check fabric registration, FM logs |
| 140 | NVLink bus error | Check fabric registration, cables |
| 688 | NVRM invalid state | Check fabric manager, NVSwitch |

**Action for NVLink Codes:** Treat as rack-level connectivity issue, not GPU card issue. Follow NVLink failure checklist (Section 6).

**Source Material:**
- `pdfs/DA-11437-001_v13.md` lines 1642-2200 (GPU Diagnostics Error Code tables)
- `pdfs/how-to-handle-fdt-fails-for-shape-gb200.md` lines 168-400 (MOD codes and actions)

### 5. Log File Locations and Interpretation

**GB200 FDT Log Paths:**
```
/local/FDT/629.../dgx/logs-<yyyymmdd>-<hhmmss>/
├── fieldiag_summary.log    # Overall summary
├── <test_id>/
│   └── <GPU_PCI_ADDR_GPU_SN>/
│       ├── fieldiag.log    # Detailed test log
│       └── fieldiag.json   # Machine-readable results
└── COMPUTE_NODE_X/
    └── connectivity/       # Multi-node test logs
```

**If /local/FDT doesn't exist (after power cycle):**
```bash
# Find and mount the SSD
ls /dev | grep -i md
sudo mount /dev/md0 /local
cd /local/FDT
```

**Source Material:**
- `pdfs/how-to-handle-fdt-fails-for-shape-gb200.md` lines 1140-1190 (Log file paths)

### 6. Triage Workflow for GB200 FDT Failures

**Priority Order for Multiple MODS Codes:**
1. Check for XID errors in dmesg/kernel logs first
2. Check NVLink-related fails
3. Check General Non-RMA-eligible fails
4. Check Non-NVLink RMA-eligible fails
5. Check Other Non-NVLink fails

**NVLink Failure Checklist:**
1. Verify rack firmware version matches recommended recipe (use HOPS to check)
2. Check fabric registration: `nvidia-smi -q | grep Fabric -A 9`
3. Inspect NVSwitch Controller Fabric Manager logs for fatal errors
4. Gather NVDebug logs (includes `nvidia-bug-report.sh`)
5. Check for cable/connector issues (but **DO NOT reseat trays** - see warning below)
6. Verify all 18 compute trays are healthy before running L11 tests
7. Check for interference from hosts not part of the test

**Important Warning from NVIDIA:**
> "Reseating the trays can bend the pins on the tray. Reseating multiple times is likely to cause damage to the NVLink connectivity."

**Source Material:**
- `pdfs/how-to-handle-fdt-fails-for-shape-gb200.md` lines 112-166 (Triage workflow)
- `pdfs/how-to-handle-fdt-fails-for-shape-gb200.md` lines 131-140 (Reseating warning)

### 7. Useful Commands Reference

**GPU Inventory and Identification:**
```bash
# Get GPU info for all GPUs
nvidia-smi -q | egrep "GPU 000|Module Id|Serial Number|GPU Fabric GUID"

# Run across multiple hosts with clush
clush -l ubuntu -w <host1>,<host2> "nvidia-smi -q | egrep \"GPU 000|Module Id|Serial Number\""
```

**Fabric and NVLink Status:**
```bash
# Check fabric registration state
nvidia-smi -q | grep Fabric -A 9

# Check NVLink status
nvidia-smi nvlink --status
```

**Log Collection:**
```bash
# Get FDT logs from OCI CLI
oci session authenticate --profile DEFAULT --tenancy-name bmc_operator_access --region r1
oci os object list -ns hpc -bn Debug --auth security_token --profile DEFAULT --prefix <HOST_SERIAL>

# Generate nvidia-bug-report
sudo nvidia-bug-report.sh

# Get rack firmware version (using HOPS)
hops-cli
> host <rack_serial>
> firmware_inventory
```

### 8. RAS Guide Quick Reference

**Key NVOnline Document IDs:**
- PID 1116117 - Server RAS Guide
- PID 1109712 - Debug and RAS Guide for NVIDIA Data Center Products
- PID 1138824 - Multi Node NVLink Troubleshooting Guide

**XID Errors:**
XID errors are reported to the kernel log from the NVIDIA GPU driver. Key XIDs to watch:
- XID 31: GPU memory page fault
- XID 45: Preemptive cleanup
- XID 48: Double Bit ECC Error
- XID 63: Row remapping failure
- XID 74: NVLink error

**Source Material:**
- `pdfs/GPU_RAS-2025Oct21.md` (GPU RAS Architecture)
- `pdfs/DA-11437-001_v13.md` lines 1214-1270 (XID Error Codes)

---

## Writing Guidelines

1. **Audience**: OCI engineers working on GPU infrastructure (CPV, IBE, HPC teams)
2. **Tone**: Technical but accessible, practical and actionable
3. **Format**: 
   - Use clear section headers with descriptive titles
   - Include code blocks for all commands (with syntax highlighting)
   - Create tables for error code references and test coverage
   - Add "Pro Tips" callout boxes for non-obvious insights
   - Use bullet points for lists, numbered lists for procedures
4. **Length**: Comprehensive but scannable (~3000-4000 words)
5. **Structure**: Follow the outline in "Blog Structure Outline" section
6. **Diagrams**: Consider including (if available):
   - GB200 NVL72 rack topology diagram
   - FDT test flow diagram
   - Triage decision tree
7. **References**: Always cite source materials with file paths and line numbers where applicable

---

## Key Insights to Highlight

These critical points must be emphasized throughout the blog:

1. **The "Don't Reseat" Rule**: NVIDIA explicitly advises against reseating GB200 trays as it can damage NVLink pins. This is a critical OCI guardrail.

2. **Recipe Alignment**: Always ensure firmware/software matches the recommended recipe before running diagnostics. Many failures are caused by recipe drift, not hardware defects.

3. **FDT vs RDMA**: FDT tests don't use RDMA links - **do not cut DO tickets for RDMA issues based on FDT failures**. RDMA is tested separately via mlx checks and WPA tests.

4. **L10 vs L11**: 
   - **L10** = individual compute tray diagnostics (must pass first)
   - **L11** = full rack diagnostics (requires all 18 trays to pass L10 first)

5. **Self-Hosted vs Managed Mode**: 
   - **Self-hosted** = simpler (auto-copies diag to secondary nodes via SSH)
   - **Managed mode** = more control (external orchestrator manages jobs and logs)

6. **IST (In-System Test)**: A newer, more comprehensive test that requires separate image download. Mention but don't focus on it unless specifically requested.

7. **XID Errors First**: Always check XID errors in dmesg/kernel logs before investigating MODS codes. XIDs often reveal underlying hardware issues first.

---

## Code Integration from OCI Repositories

When writing the blog, include code examples and patterns from the OCI automation repositories. Reference the local paths above for actual code inspection.

### Burn-in Orchestrator

**Repository Details:**
- GitHub: `https://github.com/rikkisnah/burn-in-orchestrator`
- Local Path: `/mnt/data/src/rikkisnah/burn-in-orchestrator`

**Key Areas to Document:**
1. **FDT Test Invocation** - How FDT tests are invoked programmatically
2. **Spec File Generation** - Dynamic spec file generation/customization based on shape
3. **Log Collection** - Automated log collection and parsing
4. **Result Reporting** - Result reporting patterns and integration

**Include Code Examples:**
- How OCI automates FDT execution at scale
- Multi-node orchestration patterns
- Error handling and retry logic
- Integration with OCI Object Storage for log archival

### OCI DR HPC v2 - GB200 FDT Parser

**Repository Details:**
- GitHub: `https://github.com/ai2-compute-gpu/oci-dr-hpc-v2`
- Local Path: `/mnt/data/src/rikkisnah/oci-dr-hpc-v2`

**Key Areas to Document:**
1. **FDT Log Parsing Modules** - How structured data is extracted from raw FDT logs
2. **Error Code Mapping** - Automated interpretation of MODS codes to actionable recommendations
3. **Result Aggregation** - How results from multiple compute trays are consolidated
4. **Reporting Integration** - How parsed results feed into OCI diagnostic dashboards

**Include Code Examples:**
- How to parse `fieldiag_summary.log` programmatically
- Extracting MODS error codes from JSON results
- Correlating failures across multiple nodes in L11 rack tests
- Generating triage recommendations based on error patterns
- Integration with OCI diagnostic workflows

---

## Reference Blog Drafts

When writing the blog, refer to the following draft versions for comparison and to ensure consistency:

- `chatgpt_blog.md` - ChatGPT-generated draft
- `perplexity_blog.md` - Perplexity-generated draft with inline citations
- `perplexity_feedback.md` - **Important:** Validation feedback on Perplexity draft (contains accuracy checks and warnings about unverifiable claims)
- `claude-draft.md` - Claude-generated draft
- `grok_blog.md` - Grok-generated draft
- `gemini_blog.md` - Gemini-generated draft

**Critical Guidelines:**
- These drafts should be used as **reference only** for structure and style
- **Always verify information** against the authoritative source materials listed in the "Source Materials Location" section above
- **Do not hallucinate** or include information that cannot be verified from the provided documentation
- Pay special attention to `perplexity_feedback.md` which highlights areas where claims cannot be fully verified from public sources
- When in doubt, cite the source document with file path and line numbers

## Validation Checklist Before Publishing

Before publishing, verify the following:

**Technical Accuracy:**
- [ ] All commands tested and accurate
- [ ] Error code tables match latest DA-11437 document
- [ ] Log paths verified against current FDT package
- [ ] Test durations and coverage match source documentation
- [ ] MODS code mappings verified against OCI runbook

**References and Citations:**
- [ ] All references verified against source materials in the `docs/` and `pdfs/` folders
- [ ] References section includes all source documents with file paths
- [ ] Links to NVOnline resources are correct (verify PID numbers)
- [ ] Code repository links are accurate

**Content Review:**
- [ ] No NVIDIA confidential markings visible in published content
- [ ] All critical guardrails highlighted (Don't Reseat, Recipe Alignment, FDT≠RDMA)
- [ ] Triage workflow matches OCI runbook procedures
- [ ] Reviewed by CPV team member for accuracy

**Formatting and Style:**
- [ ] Consistent formatting throughout
- [ ] All code blocks have proper syntax highlighting
- [ ] Tables are properly formatted
- [ ] Pro Tips callouts are clearly marked
