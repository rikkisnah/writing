# GPU_RAS-2025Oct21

_Converted from PDF: 2025-11-28_

---

    R
              ik




    GPU HW & SW Resiliency Teams
                                   Ki
                                      sn
                                        ah
                                       11 NV
                                         20 ID
                                           34 IA
                                             8 Co
                                               20 n
                                                 25 fide
                                   GPU RAS ARCHITECTURE
                                                   -1 nt
                                                     1- ia
                                                       28 l O
                                                         16 ra
                                                           :1 cle
                                                             2: L
                                                               4 5 ab
                                                                     s
                                                                         -N
                                                                              VL
1
                          All information in the following presentation is NVIDIA




                                                        VL
                          confidential, including codenames, future products, and




                                                     -N
                          performance projections




                                              s
                                        4 5 ab
                          No information in this presentation is allowed to be revealed or
                          published without NVIDIA consent




                                      2: L
                                    :1 cle
                          Sharing or distributing copies of this presentation to anyone is




                                  16 ra
                          strictly prohibited. Use of cameras to capture information is




                                28 l O
    NVIDIA                strictly prohibited




                              1- ia
                            -1 nt
CONFIDENTIAL              THIS INFORMATION IS INTENDED TO OUTLINE OUR GENERAL




                          25 fide
                          PRODUCT DIRECTION. MANY OF THE PRODUCTS AND FEATURES




                        20 n
                          DESCRIBED HEREIN REMAIN IN VARIOUS STAGES AND WILL
 Presentation

                      8 Co
                          BE OFFERED ON A WHEN-AND-IF-AVAILABLE BASIS. THIS ROADMAP



                    34 IA
                          DOES NOT CONSTITUTE A COMMITMENT, PROMISE, OR LEGAL

                  20 ID
                11 NV     OBLIGATION AND IS SUBJECT TO CHANGE AT THE
                          SOLE DISCRETION OF NVIDIA.
                 ah


                          THE DEVELOPMENT, RELEASE, AND TIMING OF ANY FEATURES
               sn



                          OR FUNCTIONALITIES DESCRIBED FOR OUR PRODUCTS REMAINS AT
            Ki




                          THE SOLE DISCRETION OF NVIDIA. NVIDIA WILL HAVE NO LIABILITY
                          FOR FAILURE TO DELIVER OR DELAY IN THE DELIVERY OF ANY OF
         ik
        R




                          THE PRODUCTS, FEATURES, OR FUNCTIONS SET FORTH IN THIS
                          DOCUMENT.
                                                                                     2
                                                                                                VL
                                                                       OVERVIEW




                                                                                            -N
                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
       A summary of GPU RAS Architecture




                                                                                  :1 cle
                                                                                16 ra
       ▪ RAM protections




                                                                              28 l O
                                                                            1- ia
       ▪ Error Containment




                                                                          -1 nt
                                                                        25 fide
       ▪ HW availability features




                                                                      20 n
       ▪ Interfaces: PCIe, NVLink, and Chip-to-Chip (C2C) error handling




                                                                    8 Co
                                                                  34 IA
       Error Containment Definitions
                                                                20 ID
                                                              11 NV
                                                               ah


       ▪ A hardware fault is contained at the origin if error indication (poison) is attached to all erroneous data leaving the
                                                             sn



         source.
                                                          Ki




       ▪ A hardware fault is contained at an intermediate point or destination if the error indication is recognized in all
                                                     ik




         possible fault paths and the destination halts to prevent the poison from spreading further.
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                   3
                                                              GPU RAS FEATURE ROADMAP




                                                                                                                               VL
                                        RAM Protections: Ampere -> Hopper -> Blackwell -> Rubin




                                                                                                                         -N
                                            Ampere (A100)                    Hopper (H100, H200)          Blackwell (B200, B300, GB200)              Rubin (R100)




                                                                                            s
         Unit Name                      Protection              Error        Protection         Error        Protection          Error          Protection           Error




                                                                                      4 5 ab
                                                               Contain                         Contain                          Contain                             Contain




                                                                                    2: L
  HBM                                       ECC                  ✓              ECC*               ✓            ECC*                ✓              ECC**                ✓




                                                                                  :1 cle
  GCC (L 1.5)                              Parity                              Parity              ✓            Parity              ✓              Parity               ✓




                                                                                16 ra
                                                                              28 l O
  MMU/TLB                                  Parity                              Parity              ✓         Parity-Retry           ✓           Parity-Retry            ✓
  PCIe                               Parity/SEC-DED                        Parity/SEC-DED          ✓      Parity/SEC/SEC-DED        ✓       Parity/SEC/SEC-DED          ✓




                                                                            1- ia
                                                                          -1 nt
  NVLink                             Parity/SEC-DED              ✓         Parity/SEC-DED          ✓       Parity/SEC-DED           ✓         Parity/SEC-DED            ✓




                                                                        25 fide
  Register File                          SEC-DED                              SEC-DED              ✓          SEC-DED               ✓            SEC-DED                ✓
  L2 Request Coalescer                                                                                          Parity                           SEC-DED




                                                                      20 n
                                                                    8 Co
  L2 Cache (Data)                        SEC-DED                 ✓            SEC-DED              ✓          SEC-DED               ✓            SEC-DED                ✓




                                                                  34 IA
  L2 Cache (Tag)                           Parity                              Parity              ✓            Parity              ✓            SEC-DED                ✓



                                                                20 ID
  L1 Cache (Instr)                         Parity             11 NV            Parity              ✓            Parity              ✓              Parity               ✓
  L1 Cache (Data)                        SEC-DED                              SEC-DED              ✓          SEC-DED               ✓            SEC-DED                ✓
                                                               ah

  Copy engine, CXL, FB                                                                                      SEC/SEC-DED             ✓          SEC/SEC-DED              ✓
                                                             sn



  L2 state                                                                                                      Parity              ✓         Parity/SEC-DED            ✓
                                                          Ki




  Microcontrollers               Some Parity/SEC-DED                     Some Parity/SEC-DED                    Parity              ✓              Parity               ✓
                                                     ik
                                                  R




                       SRAMs that can generate Uncorrectable Errors (UCE) designate affected data with poison as shown in Error Contain column
                                                                            SEC: Single-bit Error Correction; DED: Double-bit Error Detection
NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                         4
                                                                            *: HBM3/3E - DRAM On-Die ECC + Sideband ECC; **: HBM4 - adds TBD RAS support
                                                                                                VL
                                                     HARDWARE ERROR CONTAINMENT




                                                                                              -N
                                                        Error Containment by Consumer of Poisoned Data




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                               Ampere (A100)    Hopper (Hx00)      Blackwell& Rubin




                                                                                  :1 cle
                                                                                                   (Bx00/Rx00)




                                                                                16 ra
                                                                              28 l O
Streaming Multiprocessor                                             ✓                  ✓                  ✓




                                                                            1- ia
Copy Engine                                                          ✓                  ✓                  ✓




                                                                          -1 nt
                                                                        25 fide
Memory Mgmt. Unit Fill                                                                  ✓                  ✓




                                                                      20 n
Frame Buffer                                                         ✓                  ✓                  ✓




                                                                    8 Co
Microcontrollers                                                                                           ✓


                                                                  34 IA
                                                                20 ID
(OFA/SEC/GSP/FSP/PMU)                                         11 NV
Context Switch Engine (FECS)                                                                               ✓
                                                               ah


Video Engines (Decoder/JPEG)                                                                               ✓
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                           5
                                           SOFTWARE
                                             SOFTWAREERROR  CONTAINMENT
                                                      ERROR CONTAINMENT




                                                                                                          VL
                                                                                                    -N
                                                                                                  Driver resets engine and




                                                                            s
                                                                     Engine halts and reports                                   CUDA sync returns error;




                                                                      4 5 ab
                                                                                                  attributed contexts are
                                                                              error                                             requires process restart.
                                                                                                         terminated




                                                                    2: L
                                                                  :1 cle
 Log & Report




                                                                16 ra
   Error (48)                                                                                            Report XID




                                                              28 l O
                                                Yes: Error is
                                                contained




                                                            1- ia
                                                          -1 nt
Uncorrectable            Return Data +




                                                        25 fide
                                                          Poison
Error Detected          poison to client                  aware?




                                                      20 n
                                                    8 Co
                                              No: Error is                                        CUDA sync returns error;




                                                  34 IA
                                                                   Engine continues execution
                                              uncontained                                        requires process restart for
                                                                        with corrupt data


                                                20 ID
                                                                                                       all processes.
                                              11 NV
                                               ah

    Affects all                                                     Driver resets all engines
    contexts?                                                      and terminates all contexts
                  Yes (unlikely):
                                             sn



                  All contexts
                                          Ki




                  are affected
                                      ik




                                                                           Report XID                  Require PF-FLR
                                    R




                                    Guarantee CUDA sync error
                                                                                                                                               6
                                    SOFTWARE  ERROR
                                    SOFTWARE ERROR   RECOVERY
                                                   CONTAINMENT




                                                                                      VL
                                                                                     -N
                   Worker Proc           FT Launcher
                                                                        Tenant       CSP




                                                                    s
                                                              4 5 ab
                                                            2: L
                                                          :1 cle
                                                        16 ra
                                                      28 l O
  App                                                                                 Field Diag /




                                                    1- ia
                            Fault                      RM                                                         RMA
running                                                                                   EUD




                                                  -1 nt
                                       APP Fails                     Diag Required                   RMA




                                                25 fide
                                                         Transient




                                              20 n
                                            8 Co
            Recovery Action:
            •   None




                                          34 IA
            •   GPU Reset                           NVML GPU

                                        20 ID
            •
            •
                Node reboot
                Drain P2P             11 NV        Recovery API
            •   Drain and Reset
                                                                                            Good
                                       ah


          Wait until NVLink fabric is healthy      NVML Fabric
                                     sn




                                                    State API
                                  Ki




                                                                                                           CUDA 12.7 Rel
                            ik
                         R




                                                                                                           CUDA 12.8 Rel

                                                                                                                  7
    R
          ik
                    Ki
                       sn
                         ah
                        11 NV
                          20 ID
                            34 IA
                              8 Co
                                20 n
                                  25 fide
                                    -1 nt
                                      1- ia
                                        28 l O
                                          16 ra
                                            :1 cle
                                              2: L
                                                4 5 ab
                                                      s
                                                          -N
                                                               VL
8
    HW AVAILABILITY FEATURES
                                                                                                               VL
                                                               AVAILABILITY FEATURES




                                                                                                           -N
                                                                                            s
                                                                                      4 5 ab
       ▪ Goal: Improve up-time by minimizing fatal errors




                                                                                    2: L
                                                                                  :1 cle
           • Non-fatal errors terminate impacted application while avoiding the need for GPU HW reset




                                                                                16 ra
                                                                              28 l O
               Technique                                                                   Summary




                                                                            1- ia
       Error Containment                         ▪      Data poisoning for error attribution to the consuming process




                                                                          -1 nt
                                                                        25 fide
                                                 ▪      HW executing the process halts to prevent error leak
                                                 ▪      An error code is returned to caller CUDA application (on CPU)




                                                                      20 n
                                                                    8 Co
                                                 ▪      HW engine reset without requiring GPU reset




                                                                  34 IA
                                                 ▪      HW support for fine-grain local checkpointing
       Graceful Degradation                      ▪
                                                                20 ID
                                                        Continue HW operation with degraded capacity with full HW functionality
                                                              11 NV
                                                 ▪      Example: HBM dynamic page retirement on Detectable and Uncorrectable Errors (DUE)
                                                               ah


       Self-recovery                             ▪      Retry transactions that can recover from transient failures
                                                             sn
                                                          Ki




                                                 ▪      Example: Invalidate TLB entry on parity error and do a page walk
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                             9
     R
             ik
                          Ki
                             sn
                               ah
                              11 NV
                                20 ID
                                  34 IA
                                    8 Co
                                      20 n
                                        25 fide
                                          -1 nt
                                            1- ia
                                              28 l O
                                                16 ra
                                                  :1 cle
                                                    2: L
                                                      4 5 ab
                                                            s
                                                                -N
                                                                     VL
10
     AVAILABILITY: ERROR CONTAINMENT
                                                                                                               VL
                              ERROR CONTAINMENT: L2 CACHE READ EXAMPLE




                                                                                                           -N
                                                                                            s
                                                                                      4 5 ab
                 GPU HW                       GPU Driver




                                                                                    2: L
                                                                     Step                                   Actions




                                                                                  :1 cle
           Compute                                                    1     A memory read accesses hits in L2 cache, data has DUE
                                                              CUDA




                                                                                16 ra
            Engine               5
                                                                            ▪ L2 cache returns the data as poisoned




                                                                              28 l O
                          4
                                                                            ▪ L2 cache tags the data as poisoned for internal storage
                                                                      2




                                                                            1- ia
                                                  7            6            ▪ Future L2 hits return data with poison




                                                                          -1 nt
       1         2                                                          ▪ L2 eviction will write poisoned data to HBM




                                                                        25 fide
                                                                      3     L2 Cache notifies the GD about the DUE. GD reports XID-172 (w/ 48)




                                                                      20 n
                                                                      4     Execution halts on receiving poison. No new memory accesses are issued




                                                                    8 Co
           L2 Cache             3            GPU Driver (GD)
                                                                            Engine notifies GD after all outstanding memory responses are drained.
                                                                      5




                                                                  34 IA
                                                                            GD reports XID-94


                                                                20 ID
                                                                            GD halts further execution and notifies an error to CUDA, stalled engine
                                                              11 NV   6
                                                                            is reset and GD reports XID-94.
                                                                      7     Cuda sets sticky error state and enforces a process restart
                                                               ah
                                                             sn
                                                          Ki
                                                      ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                      11
                                                                                                                  VL
                               ERROR CONTAINMENT: MEMORY READ EXAMPLE




                                                                                                              -N
                                                                                            s
                                                                                      4 5 ab
                 GPU HW                       GPU Driver




                                                                                    2: L
                                                                       Step                                    Actions




                                                                                  :1 cle
           Compute                                                      1     A memory read accesses data with DUE
                                                              CUDA




                                                                                16 ra
            Engine               6
                                                                        2     Data is returned as-is with inline poison indicator




                                                                              28 l O
                          5
                                                                        3     HBM reports DUE to GD. GD reports XID-63




                                                                            1- ia
                                                  9            7




                                                                          -1 nt
                                                                              ▪ L2 cache stores the data as poisoned and forwards poisoned data




                                                                        25 fide
                                                                        4     ▪ Future L2 hits return data with poison
                                                                              ▪ L2 eviction will write poisoned data to HBM
                          4




                                                                      20 n
                                                                        5     Execution halts on receiving poison. No new memory accesses are issued




                                                                    8 Co
           L2 Cache                          GPU Driver (GD)
                                                                   8    6     Engine notifies GD after all outstanding memory responses are drained.




                                                                  34 IA
                                                                              GD halts further execution and notifies an error to CUDA, stalled engine

                                                                20 ID
            1       2                                                   7
                                                              11 NV           is reset and GD reports XID-94
                                                                        8     GD removes the faulty page from future allocation
                HBM              3
                                                               ah


                                                                        9     Cuda sets sticky error state and enforces a process restart
                                                             sn
                                                          Ki




           End Result: CUDA aborts with an error and faulty page is removed from allocation until next GPU reset. Faulty page is row-
                                                      ik




           remapped during next GPU reset. HW does not have to be offlined immediately
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                        12
                                                                                                               VL
                             ERROR CONTAINMENT: MEMORY WRITE EXAMPLE




                                                                                                           -N
                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
            Compute                                                  Step                                   Actions




                                                                                  :1 cle
             Engine
                                                                            ▪   GPU receives a PCIe downstream write request with EP bit set to 1
                                                                      1




                                                                                16 ra
                                                                            ▪   GPU can optionally report poison in downstream data packet




                                                                              28 l O
                 3
                                                                      2     ▪   HBM stores the line as poisoned. No error is reported to RM




                                                                            1- ia
        2
                                                                            ▪   A future reader of poisoned data will find a DUE.




                                                                          -1 nt
               HBM               1           PCIe                     3
                                                                            ▪   Memory read example has details on poisoned data response




                                                                        25 fide
                                                                      20 n
                                                                    8 Co
       Rules for Handling Poisoned Writes




                                                                  34 IA
                                                                20 ID
       ▪ A poisoned write request will store the data as poisoned (in L2 cache and HBM)
                                                              11 NV
       ▪ A partial write request will be stored as poisoned data if either the written data or stored data is poisoned
                                                               ah


       ▪ A fully covered write request with no poison will clear poisoned state of the stored data
                                                             sn
                                                          Ki




       ▪ An atomic request will store the result as poisoned data if either the request payload or stored data is poisoned.
                                                     ik




         Poisoned data will be returned, if applicable (depending on the atomic instruction)
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                     13
                                                                                                              VL
                                                      UNIT SPECIFIC POISON HANDLING




                                                                                                             -N
                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
         Engine Halt                                  Halt Poisoned Stream      No Halt: Return MMU_NACK           No Halt: persistent poison




                                                                                  :1 cle
                                                                                16 ra
                                                         Copy Engine (CE)                                                   corrupt tag




                                                                              28 l O
           Compute
                                                        Faulting    Active                MMU                              L2 Cache




                                                                            1- ia
            Engine                                      Stream     Streams




                                                                          -1 nt
                                                                        25 fide
             poison                                     poison                            poison




                                                                      20 n
                                                                    8 Co
       ▪ See memory                          ▪ CE has multiple DMA streams      ▪ MMU may see poisoned            ▪ Address information is lost




                                                                  34 IA
         read example                                                             page tables during                when L2 tag is corrupt
                                             ▪ Only the stream(s) receiving

                                                                20 ID
                                                                                  page walk
                                               poison halt    11 NV                                               ▪ Memory state of GPU is no
                                                                                ▪ MMU_NACK is returned              longer reliable
                                             ▪ Poisoned data sourced by CE is
                                                                                  to the unit requesting
                                                               ah

                                               not copied to the destination                                      ▪ L2 returns persistent poison for
                                                                                  page translation
                                                                                                                    all future read requests
                                                             sn



                                                                                ▪ Treated like any
                                                                                                                  ▪ GPU reset is required for
                                                          Ki




                                                                                  translation error inside
                                                                                                                    recovery
                                                     ik




                                                                                  the requesting unit
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                       14
                                                                                                                       VL
                                                                   XID INDICATIONS




                                                                                                                   -N
                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
      XID                                                         Likely cause
      48                                                          Indicates UCE in SRAM/DRAM. Details in XID string.




                                                                                16 ra
                                                                              28 l O
      63                                                          Row remap pending due to HBM UCE
      64                                                          Row remap either already pending or failed due to HBM UCE




                                                                            1- ia
                                                                          -1 nt
      94                                                          Poison consumed & hardware contained




                                                                        25 fide
      95                                                          Hardware uncontained due poison unaware consumption. Containment provided via SW
                                                                  mechanism.




                                                                      20 n
                                                                    8 Co
      154 (new)                                                   GPU recovery action changed: Specifies action needed to clear the effects from a previous fault
                                                                  and get GPU back to operational state




                                                                  34 IA
      156 (new)                                                   Resource retirement event (TPC repair)


                                                                20 ID
      157 (new)                                                   Resource retirement event failure (TPC repair)
                                                              11 NV
      160 (new)                                                   Resource retirement event (HBM memory channel repair)
                                                               ah

      161 (new)                                                   Resource retirement event failure (no HBM memory channel repair available) – generally
                                                                  observed in conjunction with XID-64
                                                             sn



      171 (new)                                                   Indicates UCE in DRAM. Observed in conjunction with a corresponding XID-48.
                                                          Ki




      172 (new)                                                   Indicates UCE in SRAM. Observed in conjunction with a corresponding XID-48.
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                 15
     R
         ik
              Ki
                 sn
                   ah
                  11 NV
                    20 ID
                      34 IA
                        8 Co
                          20 n
                            25 fide
                              -1 nt
                                1- ia
                                  28 l O
                                    16 ra
                                      :1 cle
                                        2: L
                                          4 5 ab
                                                s
                                                    -N
                                                         VL
     HBM RAS
16
                                                                                                  VL
                                                              HBM MEMORY RESILIENCE




                                                                                              -N
                                                                    RAS Features for DRAM




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
                                                                                16 ra
                                                                              28 l O
                                                       Ampere          Hopper           Blackwell      Rubin




                                                                            1- ia
                  Memory cell/                         Page            Row Remapping Row Remapping Row Remapping




                                                                          -1 nt
                                                                        25 fide
                  row failures                         Retirement




                                                                      20 n
                  Large scale                                          Channel          Channel        Channel




                                                                    8 Co
                  failures                                             sparing (H200)   sparing        sparing; Bank



                                                                  34 IA
                                                                                                       Sparing
                                                                20 ID
                                                              11 NV
                                                               ah
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                            17
                                                                                                      VL
                                                               HBM MEMORY RESILIENCE




                                                                                                   -N
                                                              Error Correction and Detection capabilities




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
                                                       HBM2E               HBM3             HBM3E           HBM4




                                                                                16 ra
                                                                              28 l O
                  GPU                                  Ampere,             Hopper           Blackwell,      Rubin




                                                                            1- ia
                  generation(s)                        Hopper                               Hopper




                                                                          -1 nt
                                                                        25 fide
                  DRAM                                 None                272/32, Reed-    272/32, Reed-   272/32, Reed-
                  (OD-ECC)                                                 Solomon          Solomon         Solomon




                                                                      20 n
                                                                    8 Co
                                                                           SSC              SSC             SSC



                                                                  34 IA
                  E2E                                  64/8,    20 ID      256/16,          256/16,         256/16,
                                                              11 NV
                  (Sideband)                           SEC-DED             SEC-DED or       SEC-DED or      SEC-DED or
                                                               ah


                                                                           CRC              CRC             CRC
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                 18
                                                                                                                             VL
                                                                      IN FIELD REPAIR




                                                                                                                        -N
                                                              Runtime Memory (HBM and GDDR) repair




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
•     https://docs.nvidia.com/deploy/a100-gpu-mem-error-mgmt/index.html




                                                                                  :1 cle
                                                                                16 ra
•     Policies that exercise these repair mechanisms are explained in the following slides




                                                                              28 l O
                                                                            1- ia
          Repair




                                                                          -1 nt
                                              Environment                              Condition and Symptom                            Root Cause           Applicability
        Mechanism




                                                                        25 fide
                                                                                                                                                            HBM: Hopper,
                                                                      Correctable errors (No XID) or XID-171 (w/ 48)




                                                                      20 n
                                                                                                                                                           Blackwell, Rubin




                                                                    8 Co
      Row remapping          Runtime, reported via driver Memory      Uncorrectable ECC Errors, and then either:                        HBM/GDDR
         (driver)            ECC: Correctable/Uncorrectable errors    - XID 63 (Page Retirement Event)                                    Errors
                                                                                                                                                         GDDR: Ampere, Ada,
                                                                      - XID 64 (Page Retirement Failure)




                                                                  34 IA
                                                                                                                                                         Blackwell (and later)


                                                                20 ID
                                                              11 NV                                                                                        Blackwell (Initial
                                                                                                                                                               Support):
                                                                      XID-171 (w/ 48) Uncorrectable ECC Errors, and then
                                                                                                                                                            97.00.7D.00.00
      Channel repair         Runtime, reported via driver Memory      either:
                                                                                                                                        HBM Errors
                                                               ah


         (driver)            ECC: Uncorrectable errors                - XID 160 (Resource Retirement Event)
                                                                                                                                                         CUDA 12.9 (R575) /
                                                                      - XID 161 (Resource Retirement Failure)
                                                             sn



                                                                                                                                                          CUDA 12.8 (R570
                                                                                                                                                              TRD3)*
                                                          Ki




    * FW >= 97.00.D9.00.29 (B200)/97.10.4C.00.06 (B300)/91.00B9.00.2C (GB200)/ 97.10.4A.00.05 (GB300) critical for channel repair proper functionality
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                           19
                                                                                                                                             VL
                                        HBM ERRORS – DRAM ECC - CORRECTABLE




                                                                                                                                           -N
                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
                                                                                16 ra
                                      Error Logging




                                                                              28 l O
                                Correctable Error Count++




                                                                            1- ia
                                                                          -1 nt
                                                                        25 fide
                    OD-ECC CEm
                                                                              2nd CEm error to the                       Row Remap          XID-154: GPU Drain   Defective row(s)
                        error                             Scrub*
                                                                                 same address?                         pending (XID-63)          & Reset          mapped out
                   (No XID report)




                                                                      20 n
                                                                    8 Co
                                                                  34 IA
                                         Error not visible
                                          downstream,


                                                                20 ID
                                                                   *Scrub initiated to avoid error count bloat + avoid transition to UCE
                                        Reset pending = 0
                                                              11 NV
                                                               ah
                                                             sn
                                                          Ki
                                                     ik




      Interrupt Storm condition (XID-92 emitted): If we exceed a rate of interrupts in a short period of time, CE interrupt is disabled until the
                                                  R




                                                                 next driver load
NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                                         20
                                                                                                                                                                         VL
                                          HBM ERRORS – DRAM ECC - UNCORRECTABLE




                                                                                                                                                                   -N
          **Present firmware requires Node Reboot for channel repair, but future firmware versions will be optimized to




                                                                                                            s
                                                                                                      4 5 ab
                                            limit the blast radius with GPU Bus Reset




                                                                                                    2: L
                                                                                                  :1 cle
                                                                                                                                            Row Retirement




                                                                                                16 ra
                                                                                                                       No                                                   RMA
                                                                                                                                            Failure (XID-64)




                                                                                              28 l O
                                                                                            1- ia
                                                                                                             Row remap          Yes           Row Remap                  XID-154: GPU Drain     Defective row(s)
                                                                                              No              resources




                                                                                          -1 nt
                                                                                                                                            pending (XID-63)                  & Reset            mapped out
                                                                                                              available?




                                                                                        25 fide
                        Error Logging
                 Uncorrectable Error Count++




                                                                                      20 n
                                                                                  Failure count >




                                                                                    8 Co
                                                               Dynamic
                                                                              repair threshold/bank?   Yes                            Yes
OD-ECC UCE error                                                 Page                                          Spare channel                  Channel Retirement            XID-154 – Reboot/        Defective Channel
                                         Scrub*                                         OR
(XID-171 + XID-48)                                              Offline                                          available?                    Event (XID –                      Reset**               Swapped Out
                                                                                 Failure in spare




                                                                                  34 IA
                                                                 (RM)
                                                                                       row?




                                                                                20 ID
                     Poison on       *Scrub initiated to avoid error count    11 NV                                                               Row remap        Yes
                     response            bloat (poison is preserved)                                                                                                           Row Remap             XID-154: GPU Drain    Defective row(s)
                                                                                                                           No                      resources
                                                                                                                                                                             pending (XID-63)             & Reset           mapped out
                                                                                                                                                   available?
                                                                               ah


  Contained                       UnContained
                                                                             sn



 HBM Error –                      HBM Error –                                                                                                                               Row+Channel
   (XID-94)                         (XID-95)                                                                                                              No             Retirement Failure            RMA
                                                                          Ki




                                                                                                                                                                          (XID-64+XID-161)
                                                                   ik
                                                              R




  ** XID-154 currently asks for GPU reset, but reboot is needed currently for channel repair to take effect

NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                                                                               21
                                                                                                                 VL
                                         HBM ERRORS – SIDEBAND - CORRECTABLE




                                                                                                             -N
                                                   (Before CUDA 13.1 (RM 590), OD-ECC Correctable policy is used)




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
                                                                                16 ra
                                                                                 Error Logging




                                                                              28 l O
                                                                           Correctable Error Count++




                                                                            1- ia
                                                                          -1 nt
                                                                        25 fide
                                                              Sideband CE error
                                                               (No XID report)




                                                                      20 n
                                                                    8 Co
                                                                  34 IA
                                                                                      Error not visible downstream,

                                                                20 ID
                                                              11 NV                         Reset pending = 0
                                                               ah
                                                             sn
                                                          Ki
                                                     ik




      Interrupt Storm condition (XID-92 emitted): If we exceed a rate of interrupts in a short period of time, CE interrupt is disabled until the
                                                  R




                                                                 next driver load
NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                22
                                                                                                                                    VL
                                    HBM ERRORS – SIDEBAND - UNCORRECTABLE




                                                                                                                            -N
                             (Before CUDA 13.1 (RM 590), OD-ECC Uncorrectable policy is used)




                                                                                            s
                                                                                      4 5 ab
        **Present firmware requires Node Reboot for channel repair, but future firmware versions will be optimized to




                                                                                    2: L
                                          limit the blast radius with GPU Bus Reset




                                                                                  :1 cle
                                                                                16 ra
                                                                                                                                    Channel




                                                                              28 l O
                                                                                                         No                        Retirement              RMA
                              Error Logging
                                                                                                                               Failure* (XID-161)




                                                                            1- ia
                       Uncorrectable Error Count++




                                                                          -1 nt
                                                                        25 fide
   Sideband ECC UCE                                            Failure count >    Yes                    Yes
                                                                                        Spare channels         Channel Retirement       XID-154 – Reboot   Defective Channel
         error                                                repair threshold/




                                                                      20 n
                                                                                          available?            Event (XID –                (Reset**)        Swapped Out




                                                                    8 Co
   (XID-171 + XID-48)                                         pseudochannel?




                                                                  34 IA
                                                                20 ID
                             Poison on
                             response                         11 NV
                                                               ah
                                                             sn



          Contained                            UnContained
         HBM Error –                           HBM Error –
                                                          Ki




           (XID-94)                              (XID-95)
                                                     ik
                                                  R




  ** XID-154 currently asks for GPU reset, but reboot is needed currently for channel repair to take effect

NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                             23
                                                                                                                    VL
                                                                     HANDLING HBM ERRORS




                                                                                                                -N
                                                                                            s
       Graceful degradation when HBM Detectable and Uncorrectable Errors (DUE) are encountered. Applies to




                                                                                      4 5 ab
       transient and permanent errors




                                                                                    2: L
                                                                                  :1 cle
                                         Reduced HBM capacity                                                    Full HBM capacity




                                                                                16 ra
                                                                              28 l O
              HBM                 Offline                       Continue operation with    GPU          Row-remap           GPU operation at
              DUE               Faulty Page                    reduced memory capacity    Reset      faulty HBM Pages       full HBM capacity




                                                                            1- ia
                                                                          -1 nt
                                                                        25 fide
                                                                                                                                         Time




                                                                      20 n
                                                                    8 Co
                                                              Page Offlining                                 Row-remapping




                                                                  34 IA
         Trigger                 HBM Detectable & Uncorrectable Error (DUE)               GPU reset with one or more faulty HBM pages


                                                                20 ID
         Actions                 Remove faulty pages from memory allocation
                                                              11 NV                       Replace faulty pages with spare pages, accessible at
                                                                                          the same physical address
                                                               ah


         Implications            ▪    Continued operation at reduced memory               ▪   Full memory capacity
                                      capacity                                            ▪   Holes filled to provide contiguous physical memory
                                                             sn



                                 ▪    Holes in physical memory
                                                          Ki




         Spare limit             ▪    Max 8 row-remaps per HBM bank or 512 row-remaps per GPU
                                                     ik




                                 ▪    RMA when row-remapper capacity is reached
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                        24
     R
          ik
                  Ki
                     sn
                       ah
                      11 NV
                        20 ID
                          34 IA
                            8 Co
                              20 n
                                25 fide
                                  -1 nt
                                    1- ia
                                      28 l O
                                        16 ra
                                          :1 cle
                                            2: L
                                              4 5 ab
                                                    s
                                                        -N
                                                             VL
     SRAM ERROR HANDLING
25
                                                                                                                     VL
                                                                  SRAM & DRAM UCE




                                                                                                                 -N
                                                                        Recovery Action




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
        For tenant/CSP, upon any DRAM UCE (XID 48 w/ 171) or SRAM UCE (XID 48 w/ 172):




                                                                                16 ra
                                                                              28 l O
        1. Check the “SRAM Threshold Exceeded” flag from nvidia-smi. If that is set, RUN_FIELDDIAGS.




                                                                            1- ia
                                                                          -1 nt
        2. Check if XID-157 (TPC Retirement Failure), or XID-161 (Channel Retirement Failure), or XID-64 (DRAM Retirement




                                                                        25 fide
           Failure) are emitted. If any, RUN_FIELDDIAGS.




                                                                      20 n
        3. Otherwise, if XID-154 (GPU_RECOVERY_ACTION_CHANGED) is emitted, follow its suggestion.




                                                                    8 Co
                                                                  34 IA
        4. Otherwise, RESTART_APP if that is killed.

        5. Otherwise, IGNORE.
                                                                20 ID
                                                              11 NV
                                                               ah
                                                             sn



        • Notes on Item 4: When an SRAM UCE (XID 48 with 172) occurs outside the TPC and leads to an application crash, restarting the application resolves the
                                                          Ki




          issue in the majority of cases. Nonetheless, the tenant or CSP may choose to perform a GPU reset to ensure that all correlated or latent faults are fully
          cleared and to accelerate the increment of the SRAM threshold counter.
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                   26
                                                                                                                                                              VL
                                                                                    SRAM UCE: TPC




                                                                                                                                                        -N
                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
                                                                                                                   RESTART_APP




                                                                                16 ra
                                                                          Contained Errors




                                                                              28 l O
                                                                                                                                                                        Healthy GPU
                                  TPC Uncorrected       Log Errors,                      SRAM                        Threshold not exceeded




                                                                            1- ia
                                  SRAM Errors           XID-172 (w/ 48)                Threshold                    (absence of XID-156/157)
                                                                                       Exceeded?




                                                                          -1 nt
                                                                                                   XID-156                                XID-154             GPU




                                                                        25 fide
                                                                                                   Resource Retirement Event              Pending GPU Reset   Reset

                                                                                                   XID-157




                                                                      20 n
                                                                                                   Resource Retirement Failure                                           RMA




                                                                    8 Co
                                                                                                   & set SRAM Threshold Flag


                                 GPU Driver




                                                                  34 IA
                                                                20 ID
             Environment                                      11 NV       Symptom                                                     Root Cause                      Repair                 Applicability
                                                               ah


                                              XID-172 (w/ 48) DBE ECC Errors, and then either:                                                                                        TPC Ready: CUDA 12.8 (R570)
 Runtime, reported via Driver                                                                                                                                     TPC repair
                                                             sn



                                              - XID 156 (Resource Retirement Event)                                               TPC SRAM Errors                                       Hopper: 96.00.8A.00.00
 - TPC ECC UCEs                                                                                                                                                    (driver)
                                              - XID 157 (Resource Retirement Failure)                                                                                                  Blackwell: 97.00.40.00.00
                                                          Ki
                                                     ik
                                                    R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                                                            27
                                                                                                                                                              VL
                                                                                  SRAM UCE: LTS




                                                                                                                                                           -N
                                                                                       s
                                                                                 4 5 ab
                                                                               2: L
                                                                                                                                         XID-154
                                                                                                                                                                     GPU Reset




                                                                             :1 cle
                                                                                                                                         Recovery action
                                                                                                                                         changes
                                                                     Uncontained Errors
                                                                                           95                  RESTART_ALL_APPs




                                                                           16 ra
                                                                                                                                                                    Node Reboot




                                                                         28 l O
                                                                    Contained ?
                                                                                              Was
                                                                                          Remote Access
                                                                                                                   IGNORE                                                  …
                                                                                                                                       Exceptions flow




                                                                       1- ia
                                                                     -1 nt
                                                                                            94                    RESTART_APP          XID-154 only when reset is needed
                                                                      Contained Errors




                                                                   25 fide
                                                                                                                                                                               Healthy GPU
                              LTS Uncorrected     Log Errors,                        SRAM                           Threshold Not Exceeded




                                                                 20 n
                              SRAM Errors         XID-172 (w/ 48)                  Threshold                       (absence of XID-160/161)




                                                               8 Co
                                                                                   Exceeded?

                                                                                                  XID-160                                XID-154              Node
                                                                                                  Resource Retirement Event              pending node         Reboot




                                                             34 IA
                                                                                                                                         reboot




                                                           20 ID
                                                                                                  XID-161
                             GPU Driver                                                           Resource Retirement Failure                                                   RMA
                                                         11 NV                                    & set SRAM Threshold Flag



          Environment                                                 Symptom                                                       Root Cause                         Repair                  Applicability
                                                          ah
                                                        sn



                                          XID-172 (w/ 48) DBE ECC Errors, and then either:
                                                     Ki




Runtime, reported via driver                                                                                                                                     Channel repair              WIP LTS ECC UCEs:
                                          - XID 160 (Resource Retirement Event)                                                 LTS SRAM Errors
- WIP LTS ECC UCEs                                                                                                                                                  (driver)                 targets CUDA 13.1
                                          - XID 161 (Resource Retirement Failure)
                                                 ik
                                                R




• Node reboot for Blackwell after XID-160 is needed.
• Before
NVIDIA      13.1, once
       CONFIDENTIAL.     threshold
                     PROVIDED        is met,
                              UNDER NDA.      the
                                         DO NOT    SRAM threshold flag will be set, w/o attempting to repair. (no XID 160 or 161)
                                                DISTRIBUTE.                                                                                                                                               28
                                                                                                                                                                           VL
                                                       SRAM UCE: OUTSIDE OF TPC/LTS




                                                                                                                                                                 -N
                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                                                                                         XID-154




                                                                                  :1 cle
                                                                                                                                                         Recovery action               GPU Reset
                                                                                                                                                         changes
                                                                                      Uncontained Errors




                                                                                16 ra
                                                                                                               95                    RESTART_ALL_APPs
                                                                                                                                                                                      Node Reboot




                                                                              28 l O
                                                                                    Contained ?
                                                                                                                  Was
                                                                                                              Remote Access
                                                                                                                                        IGNORE                                              …




                                                                            1- ia
                                                                                                                                                        Exceptions flow




                                                                          -1 nt
                                                                                                                94                      RESTART_APP     XID-154 only when reset is needed
                                                                                       Contained Errors




                                                                        25 fide
                                                                                                                                                                                       Mark HW as




                                                                      20 n
                                       Uncorrected            Log Errors,                              SRAM               Threshold Not Exceeded                                       usable
                                                              XID-172 (w/ 48)                        Threshold




                                                                    8 Co
                                       SRAM Errors
                                                                                                     Exceeded?                                                                         (For ultra-high
                                                                                                                                  successful                                           importance tasks:
                                                                                                                                                                                       run Diags to gain
                                                                                                                       In-field




                                                                  34 IA
                                                                                                                                                                                       confidence)
                                                                                         “SRAM Threshold Exceeded”     SRAM repair
                                                                                         Flag Set in Nvidia-smi




                                                                20 ID
                                                                                                                                                                                       RMA
                                                              11 NV                                                   Run FieldDiag & repair                                Not
                                                                                                                                                                          repaired

                                      GPU Driver                                Transient suggests ~90%                In field
                                                                                chance of transient issues.            SRAM repair
                                                               ah


                                                                                                                       Ampere: No
                                                                                Not-transient includes both            Hopper: No
                                                             sn



                                                                                intermittent and permanent             Blackwell: No
                                                                                faults                                 Rubin: Planned
                                                          Ki
                                                     ik
                                                     R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                                                                29
                                                                                                                                                                                  VL
                                                              SRAM ERRORS - CORRECTED




                                                                                                                                                                           -N
                                                                                            s
                                                                                      4 5 ab
                                          Log Errors,                  Determine               Others
                    Corrected                                          SRAM fault
                    SRAM Errors           no XID
                                                                        location




                                                                                    2: L
                                                                                            force L2 flush to




                                                                                  :1 cle
                                                                                            clear transient CE

                                                                                            Transient




                                                                                16 ra
                                                                                                                         Non-
                                                                              L2                    Is it              Transient




                                                                              28 l O
                                                                                                 transient
                                                                                                      ?
                                                                                                                                                                                   Mark HW as




                                                                            1- ia
                                                                                                                                                                                   usable
                                                                                                                     B300 or




                                                                          -1 nt
                                                                              SM                                      later     No CE interrupts.
                                                                                                  Product?                      Counter is updated                                 (For ultra-high
                                                                                                                                                                                   importance tasks:




                                                                        25 fide
                                                                                                                                by polling.
                                                                                                         B200 or                                                                   run Diags to gain
                                                                                                         earlier                                                                   confidence)




                                                                      20 n
                                                                                                                                Force CTXSW to




                                                                    8 Co
                                                                                                 Transient?                     flush transient CE
                                                                                                                       Yes




                                                                  34 IA
                                                                                                          No




                                                                20 ID
                                                              11 NV       XID-92
                                                                      (may lead to
                                                                  significant perf loss*)                                                                          successful                            successful

                                                              Excessive                                                                                  In-field                           In field                             RMA
                                                               ah

                                                              errors?                                                                                    SRAM repair                        TPC repair
                                                                                                                                                                                  Not                                   Not
                                                                                                                                                                                repaired                              repaired
                                                             sn



                                                                                                                                                     Run FieldDiag & Repair
                                                          Ki




                                                              Significant perf loss*                           Transient suggests ~90%                   In field                           In field
                                                        ik




                                                                                                               chance of transient issues.               SRAM repair                        TPC repair
                                                    R




                                                              Significant perf loss can only
                                                              be possible if the error rate is                 Non-transient includes both               Ampere: No                         Ampere: No
                                                              >>100s / min.                                    intermittent and permanent                Hopper: No                         Hopper: Yes
                      GPU Driver
                                                              So Nvidia suggest to ignore                      faults                                    Blackwell: No                      Blackwell: Yes
                                                              errors at a rate of <100 / min                                                             Rubin: Planned                     Rubin: Planned
NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                                                                                            30
                                                                                                         VL
                                 SRAM ERRORS - CORRECTED CHANGES IN B300




                                                                                                     -N
                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
                                                                                16 ra
       Intermittent or permanent faults caused SRAM ECC Corrected Errors (CE) from SM: NO functional impacts.




                                                                              28 l O
                                                                            1- ia
       Repeated CEs cause interrupt storms, impacts performance:




                                                                          -1 nt
                                                                        25 fide
       -    Issue in B200 and prior generations:




                                                                      20 n
           ▪     GPU processing is stalled when CE interrupt are pending, need GPU driver to handle




                                                                    8 Co
           ▪     Error rate of >100 counts / mins may cause performance degradation. Guidance to customers:




                                                                  34 IA
                 https://apps.nvidia.com/PID/ContentLibraries/Detail?id=1116581

                                                                20 ID
                                                              11 NV
       -    Fix in B300 and later: No SM CE interrupts. No performance impact.
                                                               ah


           ▪     Achieved by permanently masking those CE interrupts. GPU driver will still poll hardware error counters registers
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                          31
     R
         ik
              Ki
                 sn
                   ah
                  11 NV
                    20 ID
                      34 IA
                        8 Co
                          20 n
                            25 fide
                              -1 nt
                                1- ia
                                  28 l O
                                    16 ra
                                      :1 cle
                                        2: L
                                          4 5 ab
                                                s
                                                    -N
                                                         VL
       HANDLING
     GPU MMU ERROR

32
                                                                            GPU MMU FAULTS




                                                                                                                                          VL
                                                                                                                                    -N
                                                                                            s
           Error type                                                 Reported Errors                                                    Policies




                                                                                      4 5 ab
                                                                                    2: L
           MMU ECC UnCorr Error                        No Xid                                         No recovery action from Driver/SW




                                                                                  :1 cle
           • HW-recovered                                                                             • GPU MMU HW automatically retried, the faulty location is added to the
           • (HW issue in MMU)                                                                           denylist (feature added since GH100)




                                                                                16 ra
           MMU ECC UnCorr Error                        Xid-172 (w/ 48) Uncorrectable DRAM ECC error   •   MMU retry could not resolve (since unique error counter has exceeded




                                                                              28 l O
           • HW-unrecovered                                                                               the limit)
           • (HW issue in MMU)




                                                                            1- ia
           MMU received poison                         Xid-94 Contained ECC error                     •   Follow the playbook of XID-172 from other units to root cause the issue.




                                                                          -1 nt
           • (HW issue outside of MMU)                 FAULT_TYPE_POISONED




                                                                        25 fide
           MMU page faults - HW/SW caused              Xid-31 GPU Memory Page Fault                   The error may stem from hardware or software.
           • (HW/SW issues in/outside of MMU)          FAULT_TYPE_PDE
                                                       FAULT_TYPE_PTE




                                                                      20 n
                                                                    8 Co
                                                       FAULT_TYPE_VA_LIMIT_VIOLATION
                                                       FAULT_TYPE_PRIV_VIOLATION
                                                       FAULT_TYPE_RO_VIOLATION




                                                                  34 IA
                                                       FAULT_TYPE_WO_VIOLATION
                                                       FAULT_TYPE_PITCH_MASK_VIOLATION


                                                                20 ID
                                                       FAULT_TYPE_WORK_CREATION
                                                              11 NV
                                                       FAULT_TYPE_UNSUPPORTED_APERTURE
                                                       FAULT_TYPE_CC_VIOLATION
                                                       FAULT_TYPE_UNSUPPORTED_KIND
                                                               ah

                                                       FAULT_TYPE_REGION_VIOLATION
                                                       FAULT_TYPE_ATOMIC_VIOLATION
                                                             sn



                                                       FAULT_TYPE_UNBOUND_INST_BLOCK (no chance
                                                       for app to cause this issue, but driver may)
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                                          33
                                                                                                                                         VL
                                                                          MMU WORKFLOWS




                                                                                                                               -N
                                                                                            s
                                                                                      4 5 ab
      •WORKFLOW_XID_13




                                                                                    2: L
               •    Repeat TPC and GPC, diff SMs: RUN_DCGMEUD (possible HW issue); if pass




                                                                                  :1 cle
                    RUN_FIELDDIAGS




                                                                                16 ra
               •    Repeat TPC and GPC, single SM: RUN_DCGMEUD (possible HW issue); if pass                                                                  Can Not Duplicate
                                                                                                                                              Error is a
                    RUN_FIELDDIAGS                                                                                                                                             Ignore




                                                                              28 l O
                                                                                                      XID-13/31 on                           isolated or
                                                                                                      Node A                                repeating in
                                                                                                                                              Node A ?
               •    Solo, no burst: INVESTIGATE_APP




                                                                            1- ia
                                                                                                                                                   Reoccurring in Node A




                                                                          -1 nt
               •    Not Repeat TPC and GPC: INVESTIGATE_APP




                                                                        25 fide
                                                                                                                                           Check and Fix              Fixed
                                                                                                                                                                               It was an App SW
               •    Non-prod environment: INVESTIGATE_APP                                                                                   App issues;                        issue
                                                                                                                                            Still Errors ?




                                                                      20 n
               •    If known good APP and Solo: REPORT_ISSUE




                                                                    8 Co
                                                                                                                                                    Still Errors in Node A


      •WORKFLOW_XID_31                                                                                                                      Run w/ same
                                                                                                                                                                       Fail




                                                                  34 IA
                                                                                                                                                                               It is a SW issue
                                                                                                                                           driver and app
                                                                                                                                             in Node B
               o    Multiple runs needed to establish pattern


                                                                20 ID
                                                              11 NV                                            Running & failing diags               Pass in Node B
               o    Repeat MMU faults to same GPU (via PCI-ID): RUN_DCGMEUD (possible HW issue); if            will confirm faulty HW
                    pass RUN_FIELDDIAGS
                                                                                                                                           Run DCGEUD &                 Fail   Follow normal RMA
                                                                                                                                             FIELDDIAG
                                                               ah

                                                                                                                                                                               In Node A
               o    Repeat MMU faults to diff GPU (via PCI-ID): INVESTIGATE_APP                                                               in Node A
                                                             sn



                                                                                                                                                    Pass
               o    Solo, no burst: INVESTIGATE_APP
                                                          Ki




                                                                                                                                         RMA request with
               o    If known good APP: REPORT_ISSUE                                                                                      instructions to
                                                     ik




                                                                                                                                         reproduce errors
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                                                        34
     R
            ik
                       Ki
                          sn
                            ah
                           11 NV
                             20 ID
                               34 IA
                                 8 Co
                                   20 n
                                     25 fide
                                       -1 nt
                                         1- ia
                                           28 l O
                                             16 ra
                                               :1 cle
                                                 2: L
                                                   4 5 ab
                                                         s
                                                             -N
                                                                  VL
     AVAILABILITY: SELF-RECOVERY
35
                                                                                                                VL
                                                                          SELF-RECOVERY




                                                                                                            -N
                                                                                            s
                                                                                      4 5 ab
       L1 caches and TLBs self-invalidate an entry with parity error and re-fetch from memory




                                                                                    2: L
                                                                                  :1 cle
                                                                                16 ra
                                                              L1 Data Cache                                            TLB




                                                                              28 l O
         Trigger                  ECC or parity error, in either data or tag arrays      Parity error in either looked-up or translated address




                                                                            1- ia
                                                                          -1 nt
         Actions                  Invalidate the entry, and treat it as miss




                                                                        25 fide
         Recovery                 ▪    Persistent retries at the same structure are indicative of permanent faults




                                                                      20 n
                                  ▪    SW should mark the part as faulty under this condition, HW continues to retry




                                                                    8 Co
                                                                  34 IA
                                                                20 ID
                                                              11 NV
                                                               ah
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                       36
     R
          ik
                    Ki
                       sn
                         ah
                        11 NV
                          20 ID
                            34 IA
                              8 Co
                                20 n
                                  25 fide
                                    -1 nt
                                      1- ia
                                        28 l O
                                          16 ra
                                            :1 cle
                                              2: L
                                                4 5 ab
                                                      s
                                                          -N
                                                               VL
     PCIE GEN6 (BLACKWELL+)
37
                                                                                                VL
                                                               SUMMARY OF PCIE RAS




                                                                                            -N
                                                                                            s
            • PCIe Gen6 (Blackwell+) with Advanced Error Reporting (AER)




                                                                                      4 5 ab
                                                                                    2: L
                • Supports FEC, LCRC and ECRC




                                                                                  :1 cle
                • Poison forwarding in upstream and downstream transactions (EP bit)




                                                                                16 ra
                                                                              28 l O
            • Internal SRAM protections (ECC or parity)




                                                                            1- ia
                                                                          -1 nt
            • Real and fake error injection at physical layer




                                                                        25 fide
            • DPC capability at system level (supported at root port)




                                                                      20 n
                                                                    8 Co
            • Proprietary and spec-defined correctable errors (CE) handling



                                                                  34 IA
                                                                20 ID
                                                              11 NV
                                                               ah
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                          38
                                                                                                VL
                                                               PCIE POISON SUPPORT




                                                                                            -N
                                                                                            s
            • PCIe forwards ingress/egress poison as defined by the Spec.




                                                                                      4 5 ab
                                                                                    2: L
            • Poison egress from GPU




                                                                                  :1 cle
                                                                                16 ra
                •     Forwarded from internal traffic sources (e.g. L2 cache and DRAM)




                                                                              28 l O
                •     Generated on uncorrectable SRAM ECC errors for portion of the PCIe controller




                                                                            1- ia
                                                                          -1 nt
                                                                        25 fide
            • Poison ingress to GPU




                                                                      20 n
                •     Forwarded to internal requesters from external sources




                                                                    8 Co
                                                                  34 IA
                •     AER reporting performed per PCIe spec

                •
                                                                20 ID
                      Controller optionally converts Completions with Status=UR/CA to poison on ingress
                                                              11 NV
                                                               ah
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                               39
                                                                                                VL
                                                    PCIE INTERNAL SRAM PROTECTION




                                                                                            -N
                                                                                            s
            • Like SRAMs in other IPs in GPU, internal SRAM parity/ECC errors in PCIe controller are




                                                                                      4 5 ab
              considered transient until the threshold has been reached.




                                                                                    2: L
                                                                                  :1 cle
                •     (please see SRAM correctable and uncorrectable error handling section)




                                                                                16 ra
                                                                              28 l O
            • Parity and uncorrected ECC errors are reported as interrupt.




                                                                            1- ia
                                                                          -1 nt
                • They are considered fatal leading to GPU hot-reset.




                                                                        25 fide
            • Errors are logged in InfoROM via other GPU interfaces and they do not go through PCIe.




                                                                      20 n
                                                                    8 Co
                                                                  34 IA
                                                                20 ID
                                                              11 NV
                                                               ah
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                            40
                                                                                                VL
                                                              PCIE FAILURES AND RECOVERY




                                                                                            -N
                                                                                            s
            • Poison and ECC/parity uncorrectable error (UCE) recovery procedure:




                                                                                      4 5 ab
                                                                                    2: L
                • Uncontained poison consumption -> kill all app contexts.




                                                                                  :1 cle
                                                                                16 ra
                • Contained poison consumption -> kill affected app context.




                                                                              28 l O
                • Uncontained UCE error in PCIE controller internal buffers -> kill all app contexts and reset




                                                                            1- ia
                                                                          -1 nt
                  GPU.




                                                                        25 fide
                • Errors affecting UVM -> Reboot OS.




                                                                      20 n
                                                                    8 Co
            • With SRIOV, errors can be contained to VFs, use VF AER, etc.



                                                                  34 IA
                                                                20 ID
            • NVIDIA GPU driver handles all GPU interrupts but does not handle AER (left to kernel/aerdrv)
                                                              11 NV
            • Posted deadlock timeout interrupt is fatal leading to GPU reset.
                                                               ah
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                      41
                                                                                                VL
                                                              PCIE LINE ERROR MECHANISMS




                                                                                            -N
            • FEC in Gen6 (Blackwell+) and CRC along with replay will act as correction method below a




                                                                                            s
                                                                                      4 5 ab
              certain threshold.




                                                                                    2: L
                                                                                  :1 cle
                • All mandatory counters, interrupts, rate measurements are implemented to PCIe
                  specification




                                                                                16 ra
                                                                              28 l O
                • Proprietary per-lane FBER counters with extended widths are preferable to small spec-




                                                                            1- ia
                  defined counters




                                                                          -1 nt
                                                                        25 fide
                • Proprietary, flexible FBER rate threshold interrupt is preferable to fixed-rate spec-defined
                  mechanism




                                                                      20 n
                                                                    8 Co
            • Error rates above a certain rate can lead to PCIE Recovery State which causes
              performance degradation.


                                                                  34 IA
                                                                20 ID
            • Error rates higher than the recovery threshold may lead to link-down, requiring GPU reset.
                                                              11 NV
            • NVidia-SMI (in-band command line) and SMBPBI (OOB) can be used to read the error
                                                               ah


              correction and recovery counts.
                                                             sn




            • Field Diag and NVQual also measure correction and recovery counters and check
                                                          Ki




              against NVIDIA-defined thresholds, no less stringent than PCIe spec.
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                      42
                                                                                                             VL
                                                              PCIE LINE ERROR POLICIES




                                                                                                            -N
            • Transient line errors result in a single recovery event. Persistent recovery events are sign of




                                                                                            s
                                                                                      4 5 ab
              required service.




                                                                                    2: L
            • Line errors can’t be isolated to an application.




                                                                                  :1 cle
                                                                                16 ra
            • Service and recovery actions to be taken:




                                                                              28 l O
                • In case of fatal errors GPU will be unavailable/reset and OOB is necessary to retrieve telemetry.




                                                                            1- ia
                                                                          -1 nt
                • In case of non-fatal but above single recovery threshold, service routine is recommended.




                                                                        25 fide
                • In case of non-fatal but above spec BER threshold, service routine is recommended.




                                                                      20 n
                                                                    8 Co
                • If not fatal but below threshold it can be safely ignored.




                                                                  34 IA
                    •     We expect a low but non-zero quantity of FBER and CRC errors on all PCIe links.


                                                                20 ID
            • Errors above spec defined BER could be associated with higher risk of SDC.
                                                              11 NV
            • Example service/failure-analysis routine*:
                                                               ah
                                                             sn



                • Take the GPU offline, run field diag, narrow down to failing physical link.
                                                          Ki




                • For failing link, service the hardware as required (e.g. cleaning connectors, swap SXM module)
                                                     ik
                                                  R




            * This is a procedural suggestion; official customer RMA instructions still need to be followed
NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                           43
                                                                                                     VL
                                                         PCIE-RELATED ERROR LOGGING




                                                                                                  -N
                                                                                            s
            •    3 ways: XIDs in sys logs on the node, OOB messages through SMBPBI, Running “nvidia-smi” on the node




                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
         Error ID                                        Related PCIe mechanism




                                                                                16 ra
         Xid 172 (w/ 48)                                 Internal hardware ECC/Parity    "PCIe" in Xid Text




                                                                              28 l O
         Xid 79                                          PCIe fatal link errors          Conflated with ALL GPU fatal issues and




                                                                            1- ia
                                                                          -1 nt
                                                                                         link partner PCIe errors




                                                                        25 fide
         Xid 167                                         PCIe fatal timeout error




                                                                      20 n
                                                                    8 Co
         Xid TBD                                         Corrected rate > threshold



                                                                  34 IA
         SMBPBI opcode 0x21 Corrected and Fatal events                                   OOB, retrievable after link-down
                                                                20 ID
                                                              11 NV
         SMBPBI opcode TBD                               "Sticky" corrected              OOB, retrievable after link-down
                                                         rate>threshold
                                                               ah
                                                             sn



         nvidia-smi pci --                               Corrected errors – raw counts   Interpretation needed for rate
                                                          Ki




         getErrorCounters
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                 44
     R
         ik
              Ki
                 sn
                   ah
                  11 NV
                    20 ID
                      34 IA
                        8 Co
                          20 n
                            25 fide
                              -1 nt
                                1- ia
                                  28 l O
                                    16 ra
                                      :1 cle
     NVLINK

                                        2: L
                                          4 5 ab
                                                s
                                                    -N
                                                         VL
45
                        BASIC NVLINK TOPOLOGY AND TRANSACTION FLOW




                                                                                                           VL
                                                                                                       -N
       Compute/copy                                     NVLink                                        NVLink          L2 cache &
       engines                                          controller                                    controller      memory system




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                      Source                                 NVLink                                Target




                                                                                  :1 cle
                                       GPU                    1. Tx request Switch(es) 2. Rx request                GPU




                                                                                16 ra
                                                                              28 l O
              HBM                                                                                                     ...      HBM




                                                                            1- ia
                                                                          -1 nt
                                                              4. Rx response              3. Tx response




                                                                        25 fide
                                                                      20 n
                                                                    8 Co
                                                                  34 IA
        sysmem                                                                                                               sysmem
         (+EGM) Grace CPU
                                                                20 ID
                                                              11 NV        NVLink Response packet          Grace CPU          (+EGM)
                                                                            error field, poison bit
                                                                                                                        Target memory
                                                               ah


                                        • Larger systems have multiple switch hops                                      can be HBM or EGM
                                                             sn



                                        • Direct-connect (GPU-to-GPU) systems have no NVLink switches
                                                          Ki




▪ NVLink response errors
                                                     ik




   ▪ STO_ERR (detected at source GPU, triggers cross-contain, brings down all active peer-enabled contexts)
                                                  R




   ▪ PRIV_ERR (detected at source or target GPU and returned to source GPU; some cases trigger cross-contain)
NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                           46
                                                              SUMMARY OF NVLINK RAS




                                                                                                           VL
                                                                           NVLink




                                                                                                       -N
 •    Generations of NVLink




                                                                                            s
          •     Ampere: NVL3 (50 Gb/s NRZ copper / 53.125 Gb/s PAM4 optical), Hopper: NVL4 (106.25 Gb/s)




                                                                                      4 5 ab
          •     Blackwell: NVL5 (212.5 Gb/s), Rubin: NVL6, R150: NVL6.2 (introduces x1 links)




                                                                                    2: L
                                                                                  :1 cle
 •    STO_ERR (Source Timeout error).




                                                                                16 ra
          •     Transaction Layer timeout counter detects packet loss. Non-fatal error; local port enters contain mode and triggers "cross-




                                                                              28 l O
                contain" mode:




                                                                            1- ia
                    ▪    All NVLinks immediately enter contain mode.




                                                                          -1 nt
                                                                        25 fide
                    ▪    Drop new Tx requests and new Rx responses to prevent data corruption.
          •     Non-fatal from HW standpoint. All active peer-enabled contexts on the GPU - both usermode and kernel - are impacted. Context




                                                                      20 n
                owners must be notified in order to ensure program correctness and complete recovery.




                                                                    8 Co
 •    Datapath RAMs protected with ECC.



                                                                  34 IA
                                                                20 ID
          •     SBE correction. DBE is contained and is fatal to GPU.
                                                              11 NV
                    •    DBE forces link down.
                    •    DBE has extremely low (practically zero) FIT. Requires PF FLR on local GPU to recover. Other GPUs not impacted directly.
                                                               ah


          •     HW engine for periodic scrub of Routing RAMs storing static data.
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                   47
                                                      SUMMARY OF NVLINK RAS (CONT)




                                                                                                         VL
                                                                           NVLink




                                                                                                     -N
 •    Microcontroller RAMs protected with parity (NVL3/NVL4) and ECC (NVL5/NVL6).




                                                                                            s
                                                                                      4 5 ab
 •    Link forced down due to DBE in pipeline or fatal error in Link/Physical layers. Requires PF FLR to recover.




                                                                                    2: L
                                                                                  :1 cle
 •    PRIV_ERR (Privilege error)




                                                                                16 ra
           •    Non-fatal. Signaled for source GPU Remap table programming error and for target GPU MMU (FLA TLB) programming error.




                                                                              28 l O
                                                                            1- ia
           •    For source PRIV_ERR: In NVL5, port enters contain mode, triggers "cross-contain" (see previous slide); in NVL6, contain/cross-contain




                                                                          -1 nt
                is programmable: contain/cross-contain enabled only for PRIV_ERR due to invalid Remap Table entries.




                                                                        25 fide
 •    Poison support




                                                                      20 n
                                                                    8 Co
           •     Poison bit in NVLink packet set if there is DBE in payload data.




                                                                  34 IA
                                                                20 ID
           •     Propagates through NVLink fabric and GPU datapath to GPU memory destination where data is poisoned.
                                                              11 NV
 •      CRC protection on link (for NVL3 and NVL4; dropped in NVL5 in favor of stronger FEC algorithm)
                                                               ah


           •     Physical layer retry on CRC error.
                                                             sn
                                                          Ki




           •    No ECRC.
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                 48
                                                      SUMMARY OF NVLINK RAS (CONT)




                                                                                                           VL
                                                                              NVLink




                                                                                                      -N
 •    All NVLink transactions are non-posted, so can attribute network errors to the source GPU




                                                                                            s
                                                                                      4 5 ab
           •    Reads, writes, Atomics all have response packet sent from target GPU to source GPU.




                                                                                    2: L
                                                                                  :1 cle
           •    Response packet contains error status field.




                                                                                16 ra
           •    Transaction timeout error (STO_ERR) unique - signaled locally at source GPU; response does not flow on NVLink fabric




                                                                              28 l O
                                                                            1- ia
                    ▪     In contrast, PRIV_ERR can be signaled at source GPU or target GPU.




                                                                          -1 nt
                                                                        25 fide
           •    Applies to all single and multi-node GPU configurations.




                                                                      20 n
 •    More details on NVL5 customer-visible handling and recovering flows for each NVLink error available in NVIDIA Service




                                                                    8 Co
      RAS Catalog: 1116117 NVIDIA Server RAS Catalog.




                                                                  34 IA
           •    Recovery actions are evolving with each product to minimize GPU fatal errors and minimize blast radius.

                                                                20 ID
                                                              11 NV
           •    Link failure diagnosability features are evolving with each product, to help pinpoint location of fabric failures causing packet drops
                and STO_ERR.
                                                               ah
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                   49
                                                                 NVLINK XID INDICATIONS




                                                                                                                                 VL
 Only selected XIDs are shown. Refer to Server RAS catalog for full list: 1116117 NVIDIA Server RAS Catalog.




                                                                                                                           -N
 ▪ Note: XIDs associated with RLW unit in NVL5 (Blackwell) and NVL6 (Rubin) replace equivalent SXIDs for NVSwitch NPORT in




                                                                                            s
   NVL3 (A100) and NVL4 (H100) because Remap/routing layer moved from NVSwitch to GPU starting with NVL5 (Blackwell).




                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
 XID                                                      Subcode                                  Likely cause
 74 (NVLINK_ERROR)                                        n/a                                      Marginal link integrity or mechanical connection.




                                                                                16 ra
                                                                                                   Fatal, requires GPU reset. 1




                                                                              28 l O
 92 (EXCESSIVE_SBE_INTERRUPTS)                            n/a                                      Internal RAM marginal or faulty.
                                                                                                   Non-fatal but may require replacing GPU.




                                                                            1- ia
                                                                          -1 nt
 137 (NVLINK_FLA_PRIV_ERR)                                n/a                                      Signaled at source Node, when fault reported at target GPU MMU PRIV_ERR, likely due
                                                                                                   to illegal NVLink peer-to-peer access made by application.




                                                                        25 fide
                                                                                                   Non-fatal.

 145 (NVLINK_RLW_ERROR)                                   00100 (RLW_REMAP)                        Source GPU detects PRIV_ERR due to system or application software error (invalid addr




                                                                      20 n
                                                                    8 Co
                                                                                                   or request type, or inconsistent MMU vs. Remap Table entry).
                                                                                                   Non-fatal, triggers contain for NVL5 (contain can be disabled for NVL6).




                                                                  34 IA
                                                          00110 (RLW_RXPIPE)                       Source or target GPU detects DLID mismatch, likely due to system
                                                                                                   software programming error (source GPU Remap table or NVSwitch routing table).



                                                                20 ID
                                                                                                   Non-fatal; packet is dropped; leads to STO_ERR at source GPU.
                                                              11 NV
                                                                                                   Or
                                                                                                   Signaled at source Node, when fault reported at target GPU MMU PRIV_ERR, likely due
                                                               ah

                                                                                                   to illegal NVLink peer-to-peer access made by application. (This case is reported
                                                                                                   together with XID-137)
                                                             sn



                                                                                                   Non-fatal.
                                                          Ki




                                                          00111 (RLW_SRC_TRACK)                    Source GPU detects response timeout (STO_ERR) due to packet drop in fabric or at
                                                                                                   target GPU.
                                                     ik




                                                                                                   Non-fatal, triggers contain.
                                                  R




 149 (NVLINK_NETIR_ERROR)                                 010001 (NETIR_LNK_EVT/NETIR_LINK_DOWN)   Fault in link controller, connector, PCB trace, or cable. Fatal, requires GPU reset.1
                                                          00000 (NETIR_BER_EVENT)                  Potential signal integrity issues detected. Informational only but may lead to STO_ERR
NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                        at source if errors rates persist at a high rate. Possible leading indicator of faulty
                                                                                                                                                                                   50     link.
 1.     Per-link reset not available in Blackwell, Rubin; recovery requires GPU PF FLR.
                                                        NVLINK XID INDICATIONS (CONT)




                                                                                                                        VL
 Additional, less common XIDs shown here Only selected XIDs are shown. Refer to Server RAS catalog for full list: 1116117




                                                                                                                  -N
 NVIDIA Server RAS Catalog.




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
 XID                                                      Subcode                       Likely cause
 144 (SAW_MVB)                                            (Multiple Subcodes)           Packet buffer RAM DBE due to HW fault. Fatal, requires GPU reset..1




                                                                                16 ra
                                                                              28 l O
 146 (TLW_TX or TLW_RX)                                   (Multiple Subcodes)           Packet buffer RAM DBE due to HW fault. Fatal, requires GPU reset.1

 (n/a) 147 (TREX)                                                                       TREX not enabled in production (RTT telemetry function provided by TREX is not in NVL5 POR).




                                                                            1- ia
                                                                          -1 nt
 148 (NVLPW_CTRL)                                                                       PRI error caused by bug in system software.




                                                                        25 fide
 150 (MSE Watchdog)                                                                     Likely due to HW fault in RISC-V CPU or memory. Fatal, requires GPU reset   .1




                                                                      20 n
                                                                    8 Co
                                                                  34 IA
                                                                20 ID
1.    Per-link reset not available in Blackwell, Rubin; recovery requires GPU PF FLR.
                                                              11 NV
                                                               ah
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                              51
     R
         ik
              Ki
                 sn
                   ah
                  11 NV
                    20 ID
                      34 IA
                        8 Co
                          20 n
                            25 fide
                              -1 nt
                                1- ia
                                  28 l O
                                    16 ra
     C2C

                                      :1 cle
                                        2: L
                                          4 5 ab
                                                s
                                                    -N
                                                         VL
52
                                                                                                VL
                                                              SUMMARY OF CHIP-2-CHIP RAS




                                                                                            -N
                                                                                            s
                                                                        NVLINK-C2C




                                                                                      4 5 ab
               ▪ Bi-directional poison propagation support.




                                                                                    2: L
                                                                                  :1 cle
               ▪ Physical layer error -




                                                                                16 ra
                                                                              28 l O
                         o Link CRC with replay for link error detection and recovery.




                                                                            1- ia
                         o Link errors are correctable and not fatal.




                                                                          -1 nt
                                                                        25 fide
               ▪ Excessive errors may lead to GPU hang or timeout




                                                                      20 n
               ▪ XID-121 -




                                                                    8 Co
                         o GPU driver raises XID-121 when excessive errors are detected by the link.




                                                                  34 IA
                         o XID-121 is informational with no corrective action.

                                                                20 ID
                                                              11 NV
               ▪ C2C errors recovery action is FLR (on Blackwell) to GPU (Hopper needs ACPI_RST).
                                                               ah


                         o It will reset the GPU, which will reset and retrain C2C.
                                                             sn



                         o It does not crash CPU
                                                          Ki




               ▪ Error injection capability for HW validation and SW verification (it will trigger CRC retry).
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                      53
     R
            ik
                        Ki
                           sn
                             ah
                            11 NV
                              20 ID
                                34 IA
                                  8 Co
                                    20 n
                                      25 fide
                                        -1 nt
                                          1- ia
                                            28 l O
                                              16 ra
                                                :1 cle
                                                  2: L
                                                    4 5 ab
                                                          s
                                                              -N
                                                                   VL
     SILENT DATA ERROR MITIGATION
54
                                                                                                          VL
                                                     SILENT DATA ERRORS MITIGATION




                                                                                                      -N
                         Silent Data Error is due to Undetected Errors by Built-In Detection Mechanisms




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
      These Undetected Errors, caused by Permanent or Transient Faults, Corrupt Application Output.




                                                                                16 ra
                                                                              28 l O
      Permanent Faults




                                                                            1- ia
      •     Enhancing Built-In Detection Mechanisms to Augment Runtime Detection Coverage




                                                                          -1 nt
                                                                        25 fide
      •     Detection:




                                                                      20 n
           •    Structural (IST) or Functional Diagnostics to Detect Faults after or during Mission Execution Time




                                                                    8 Co
           •    Algorithmic Based Error Detection (ABED) to Detect Anomalies During Mission Runtime




                                                                  34 IA
      •     In Field Repair (where possible)

                                                                20 ID
                                                              11 NV
      Transient Faults
                                                               ah


      •     All Critical SRAM Structures ECC or Parity Protected
                                                             sn



      •     Column Interleaving to Eliminate Multi-Bit Errors in SRAM Logical Words
                                                          Ki




      •     ABED if needed
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                          55
     R
         ik
               Ki
                  sn
                    ah
                   11 NV
                     20 ID
                       34 IA
                         8 Co
                           20 n
                             25 fide
                               -1 nt
                                 1- ia
                                   28 l O
                                     16 ra
                                       :1 cle
                                         2: L
                                           4 5 ab
                                                 s
                                                     -N
                                                          VL
     IN FIELD REPAIR
56
                                                                                                                  VL
                                                                          IN FIELD REPAIR




                                                                                                                 -N
                                                                                FieldDiag repairs




                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
                                                                                16 ra
             Environment                                      Error Log / Sequence                  Root Cause           Repair              Applicability




                                                                              28 l O
                                             Bad Nvidia chip                                                            TPC repair    Ready: Blackwell (and later)
 FieldDiag:




                                                                            1- ia
                                             OK - GPU tuning candidate                              TPC Errors          (fielddiag)
 - IST Errors (MBIST and LBIST)




                                                                          -1 nt
                                             OK - GPU is tuned successfully / GPU tuning failed                                        WIP: Hopper (LBIST-only)




                                                                        25 fide
                                             Bad Nvidia chip
 FieldDiag:                                                                                                             LTS repair
                                             OK - GPU tuning candidate                              LTS Errors                        Ready: Blackwell (and later)




                                                                      20 n
 - IST Errors (MBIST and LBIST)                                                                                         (fielddiag)
                                             OK - GPU is tuned successfully / GPU tuning failed




                                                                    8 Co
 FieldDiag:                                  CRC checksum mis-compare / ECC errors, etc.
                                                                                                                        TPC repair    WIP: Hopper, Blackwell (and




                                                                  34 IA
 - Functional Tests Errors (ECC              OK - GPU tuning candidate                              TPC Errors
                                                                                                                        (fielddiag)             later)
   UCEs or result mis-match)                 OK - GPU is tuned successfully / GPU tuning failed


                                                                20 ID
 FieldDiag:                                  Bad memory / ECC errors, etc.                                                            Ready: Blackwell (and later)
                                                              11 NV                                                     LTS repair
 - Functional Tests Errors (ECC              OK - GPU tuning candidate                              LTS Errors
                                                                                                                        (fielddiag)
   UCEs or result mis-match)                 OK - GPU is tuned successfully / GPU tuning failed                                              WIP: Hopper
                                                               ah


 FieldDiag:                                  MODS runs functional tests and finds faulty rows and                                           Ready: Hopper
                                                             sn



                                                                                                                      Row remapping
 - Functional Tests Errors (HBM              perform row remapping based on policy enforced by      HBM Errors
                                                                                                                        (fielddiag)
                                                          Ki




 ECC UCEs)                                   MODS cmd line.                                                                            WIP: Blackwell (and later)
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                            57
     R
         ik
              Ki
                 sn
                   ah
                  11 NV
                    20 ID
                      34 IA
                        8 Co
                          20 n
                            25 fide
                              -1 nt
                                1- ia
                                  28 l O
                                    16 ra
                                      :1 cle
                                        2: L
     BACKUP


                                          4 5 ab
                                                s
                                                    -N
                                                         VL
58
                                                                                                                          VL
                                                                               GLOSSARY




                                                                                                                      -N
                                                                                            s
                                                                                      4 5 ab
                                                                                    2: L
                                                                                  :1 cle
                                                                                16 ra
      ABBREVIATION                          DESCRIPTION




                                                                              28 l O
                                                                            1- ia
      GCC                                   Global Constant Cache – used to store instructions and constant data




                                                                          -1 nt
      MMU                                   Memory Management Unit




                                                                        25 fide
      TLB                                   Translation Lookahead Buffer




                                                                      20 n
      OFA                                   Optical Flow Accelerator. Dedicated hardware for Stereo / Optical Flow (i.e., estimate motion of object from one frame to




                                                                    8 Co
                                            the next). DL Application: Video Classification
      GSP                                   GPU System Processor. Microcontroller that runs subset of GPU driver




                                                                  34 IA
                                                                20 ID
      FSP                                   Foundation Security Processor. Root of Trust for boot, firmware security, and attestation.
      SEC
                                                              11 NV
                                            Security Engine. Used for Confidential Compute and Digital Rights Management (DRM)
      PMU                                   Power Management Unit
                                                               ah
                                                             sn
                                                          Ki
                                                     ik
                                                  R




NVIDIA CONFIDENTIAL. PROVIDED UNDER NDA. DO NOT DISTRIBUTE.                                                                                                      59
