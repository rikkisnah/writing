# NVIDIA_COPYRIGHT_BEGIN
#
# Copyright 2024 by NVIDIA Corporation.  All rights reserved.  All
# information contained herein is proprietary and confidential to NVIDIA
# Corporation.  Any use, reproduction, or disclosure without the written
# permission of NVIDIA Corporation is prohibited.
#
# NVIDIA_COPYRIGHT_END

##################################################################################
#                                                                                #
#                    GB200 NVL 72 2:4 Rack (L11)  partnerdiag                    #
#                                                                                #
##################################################################################

  What is it?
  -----------
  "GB200 NVL 72 2:4 Rack" partnerdiag diagnostics is a tool to isolate HW failures on Nvidia "GB200 NVL 72 2:4 Rack" products.

  Running partner diagnostics
  ---------------------------
  1) cd <Diag Package Directory>
  2) Run Partner Manufacturing Diagnostics:
  - Mfg  :
    - Run on switch nodes
      ./partnerdiag --mfg --run_spec=spec_gb200_nvl_72_2_4_switch_nodes_partner_mfg.json --primary_diag_ip=<IP>
    - Run on compute nodes
      ./partnerdiag --mfg --run_spec=spec_gb200_nvl_72_2_4_compute_nodes_partner_mfg.json --primary_diag_ip=<IP>
    - Run CBC Eeprom Check test on both compute and switch nodes
      ./partnerdiag --mfg --run_spec=spec_gb200_nvl_72_2_4_cable_cartridge_partner.json --primary_diag_ip=<IP>
          Useful options:
              Default Redfish Endpoints are mentioned using key 'rf_endpoints.CBC_Eeprom_list' in spec file. Change them as needed.
              By default, the diag uses https, for http set 'ishttps' to false and change the 'curl_options' in spec file.
  - Field :
    - Level 1
      ./partnerdiag --field --level1 --primary_diag_ip=<IP>
    - Level 2
      ./partnerdiag --field --level2 --primary_diag_ip=<IP>
  3) PASS/FAIL/RETEST will be displayed when partnerdiag finishes execution.
  4) Run ./partnerdiag --help for more details on options

  Useful Options
  --------------
  1) --skip_tests=<virtual_id>,<virtual_id> --> Skips the specified list of tests.
  2) --test=<virtual_id>,<virtual_id> --> Tests the specified list of tests.

  Contacts
  --------

  Please email NVIDIA CQE team
