# RMA Field Diagnostics Test using_40df249bf3b4430091800cf1f2df3251-291125-0113-918

_Converted from PDF: 2025-11-28_

---

RMA Field Diagnostics Test using Repair Rack
We are currently executing on a proof-of-concept that will repair and test GB200 compute trays inside the ABL data center. As part of this initiative, we
have setup a repair rack with a Diagnostics Server that is used to execute full L10 manufacturing test on a compute tray in the rack (see: Repair Validation
Rack). With this current setup, we have also validated the ability to run those same tests against compute trays in the customer rack, without impacting the
customer that may have instances running in the same rack. As a short-term stop-gap solution until Warminator is ready, we plan to use this repair setup
to test compute trays with repair orders from the customer.


RMA Short-Term Workflow

        After we finish running L10 Manufacturing tests on a compute tray, the compute tray will be factory reset and running the latest manufacturing
        version of firmware. The compute tray must be handed back to the customer like we would a spare replacement. The compute tray will be
        configured for PXE booting as a spare, but will need to be configured and have the correct customer firmware flashed.




This full Warminator flow is defined in Warminator flow, with the following flow as a short-term process until Warminator is available.




L10 Manufacturing Test (FDT)
The Field Diagnostic Test using the L10 Manufacturing test procedure will execute the following:
  Test                                          Details/Command

 Check, Update, and Validate ILOM             Check ILOM is at the expected version, flash ILOM firmware, and check version
 firmware

 Check, Update, and Validate PLDM             Check PLDM is at the expected version, flash PLDM firmware, and check version
 firmware

 Run hardware diagnostic i2c test             Run hwdiag i2c test and only validate result

 Boot live host image to update CX8, SWB,     Except firmware update, this step checks nvme count and cx8 count, we can move these checks when
 IOB, Nvme firmware                           booting to Ubuntu 2404 before running partnerdiag

 Check open problems                          Fail for any ILOM Open Problems

 hwdiag i2c test all                          hwdiag i2c test all


 hwdiag fan test                              hwdiag fan test -o


 cx8 count validation                         check cx8 count is as expected

                                              lspci | grep Mellanox | grep ConnectX-8


 Loopback cable type check                    make sure using optical transceiver

                                              mlxlink -d mlx5_{} -m | grep -i "Cable Type"




 Validate all PCI bus                         mst start && mst status -v


 Configure CX8 PCI bus using 2*400Gb/s        mlxconfig -y -d {pci_id} set MODULE_SPLIT_M0[0..3]=1 "
                                              f"MODULE_SPLIT_M0[4..7]=2 MODULE_SPLIT_M0[8..15]=FF

                                              mlxconfig -y -d {pci_id} set NUM_OF_PF=2


 Get mlxlink full output to check if          mlxlink -d {} -m -c -e -j
 transceiver is reachable

 osfp_internal_prbs test

 ultrapass cable flip check

 RDMA serial cable check                      mlxlink -d mlx5_{} -m


 Partnerdiag test                             Run partnerdiag tests (see below)

 Disable internal loopback

 Reset to Factory


NVIDIA Partnerdiag Tests
The following table contains all tests executed as part of L10 manufacturing partnerdiag. This table contains information from the NVIDIA document (DU-
11965-001_18), customized based on what we execute and what failures we ignore in L10 manufacturing.

  Actions                                                          Test           Test Description              Pass/Fail Criteria
                                                                   Duration

 Inventory                                                        1 minute       System-level check of         Fails if the firmware version does not match.
                                                                                 components against expected
                                                                                 versions.

 inforom                                                          40 seconds     Checks the GPU inforom

 tegra_cpu (TegraCpu)                                             10 minutes     Performs CPU diagnostics      Fails if the CPU operation is not stable.
                                                                  (configurabl   testing.
                                                                  e)
tegra_memory (TegraMemory)                                     45 seconds     Saturates the system memory     Fails if unable to perform read/write/allocate
                                                                              bus with the concurrent data    transactions on all memory channels.
                                                                              traffic that was generated by
                                                                              High Speed Scrubbing and
                                                                              the CPU.



                                                                              It requires a

                                                                              MODS secure partition.

tegra_memory (CpuMemorySweep)                                  22 minutes     Perform reads, writes,          Fails if the test cannot allocate read/write
                                                                              correctness checks for CPU      /allocate transactions on all memory channels.
                                                                              memory.



                                                                              This requires a MODS secure
                                                                              partition.

tegra_clink (TegraClink)                                       40 seconds     CPU-CPU NVIDIA® NVLink™         Fails if the link quality thresholds are not met.
                                                                              Test.

ssd                                                            2 minutes      SSD Stress test.                Skipped in Repair Test
                                                               (configurabl
                                                               e)

pcieproperties                                                 1 second       Verifies the PCIe connection    Fail if the detected PCIe properties do not
                                                                              properties.                     match the spec JSON file.
(CxPcieProperties, BfPcieProperties, BfMgmtPcieProperties)
                                                                                                              Skipped BfPcieProperties and BfMgmtPciePr
                                                                                                              operties for ABL SKU

gpustress (Gpustress)                                          4.5 minutes    GPU stress tests.               Fails if there is a CRC miscompare during
                                                                                                              computation.

gpumem (Gpumem)                                                One minute     GPU memory and                  Fails if the GPU memory is unstable.

                                                                              interface (FBIO) tests.

pcie                                                           12.5           GPU PCIe bandwidth, speed       Fails if the GPU PCIe connection is unstable or
                                                               minutes        switching, and eye diagram      cannot achieve required functions.
                                                                              tests.

thermal (ThermalSteadyState)                                   11.5           Thermal test.                   Fails if the temperature exceeds the limitation.
                                                               minutes (co
                                                               nfigurable)

connectivity                                                   12 minutes     Validates that the electrical   Skipped in L10 Test
                                                                              quality of NVLinks and PCIE
                                                                              link speeds/width match the
                                                                              POR.

nvlink                                                         12 minutes     NVLink bandwidth and eye        Skipped in L10 Test
                                                                              diagram tests.
(NvlBwStress, NvlBwStressBg610)

ibstress                                                       2 minutes      Performs infiniband stress      Fails if the expected bandwidth is not met.
                                                               (configurabl   read and write operations and
(IbStressCables, IbStressBf3PhyLoopback, IbStressBf3Loopout,   e)             verifies the performance.       Skipped IbStressCables and
IbStressCx7PhyLoopback, IbConfigureCx7Cables400G_8X,                                                          IbStressCx7PhyLoopback in Repair Test
IbStressLoopout400G_8X, IbConfigureCx7Cables400G_4X,
IbStressLoopout400G_4X, Cx8GpuDirectLoopback,                                                                 Skipped IbStressBf3PhyLoopback, IbStress
Cx8GpuDirectCrossGpu)                                                                                         Bf3Loopout, IbStressLoopout400G_8X, IbStr
                                                                                                              essLoopout400G_4X, Cx8GpuDirectLoopbac
                                                                                                              k, and Cx8GpuDirectCrossGpu for ABL SKU

dpudiag                                                        5 minutes      Performs infiniband traffic     Fails if the ConnectX-8 does not meet
                                                               (configurabl   stress, eye diagram, and        performance standards.
(CxeyegradeStart, CxeyegradeStop, Bf3PcieInterfaceTraffic)     e)             thermal stress of
                                                                              ConnectX Devices                Skipped CxeyegradeStop
                                                                                                              and Bf3PcieInterfaceTraffic for ABL SKU
powersync                                                   2.5 minutes    Performs a synchronous CPU        Fails if the temperature exceeds the limitation.
                                                            per frequenc   and GPU power stress.
(CpuGpuSyncPulsePower1Hz50duty,                             y (configura
CpuGpuSyncPulsePower3Hz50duty,                              ble)
CpuGpuSyncPulsePower10Hz50duty,
CpuGpuSyncPulsePower25Hz50duty,
CpuGpuSyncPulsePower50Hz50duty,
CpuGpuSyncPulsePower100Hz50duty,
CpuGpuSyncPulsePower200Hz50duty,
CpuGpuSyncPulsePower300Hz50duty,
CpuGpuSyncPulsePower400Hz50duty,
CpuGpuSyncPulsePower500Hz50duty,
CpuGpuSyncPulsePower600Hz50duty,
CpuGpuSyncPulsePower700Hz50duty,
CpuGpuSyncPulsePower800Hz50duty,
CpuGpuSyncPulsePower900Hz50duty,
CpuGpuSyncPulsePower1kHz50duty,
CpuGpuSyncPulsePower1_5kHz50duty,
CpuGpuSyncPulsePower2kHz50duty,
CpuGpuSyncPulsePower3kHz50duty,
CpuGpuSyncPulsePower4kHz50duty)

chkoccurrences                                              1.5 minutes    Verifies that                     The required dependencies and/or
                                                                           the required permissions          permissions for the selected actions are not
(SyslogErrorCheck, KernLogErrorCheck, DmesgLogErrorCheck,                  and tools are installed for all   met.
SyslogAERCheck, KernLogAERCheck)                                           actions selected to be run.
                                                                                                             Ignored on Failure for Repair Test
