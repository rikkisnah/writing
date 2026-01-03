# NVIDIA_COPYRIGHT_BEGIN
#
# Copyright 2024 by NVIDIA Corporation.  All rights reserved.  All
# information contained herein is proprietary and confidential to NVIDIA
# Corporation.  Any use, reproduction, or disclosure without the written
# permission of NVIDIA Corporation is prohibited.
#
# NVIDIA_COPYRIGHT_END

################################################################################
#                                                                              #
#                  BLACKWELL HGX 8 GPU partnerdiag diagnostics                 #
#                                                                              #
################################################################################

  What is it?
  -----------

  BLACKWELL HGX 8 GPU partnerdiag diagnostics is a tool to isolate HW failures on Nvidia BLACKWELL HGX 8 GPU products.

  Where can I locate it ?
  -----------------------

  BLACKWELL HGX 8 GPU partnerdiag diagnostics are located as part of 629-PPPPP-KKKK-FLD-DDDDD.tgz package where:
  - PPPPP is the product code
  - KKKK  is the sku code
  - DDDDD is meant for Nvidia internal software tracking

  Installation
  -------------

  Please follow these steps:
  1) Copy 629-PPPPP-KKKK-FLD-DDDDD.tgz to your system
  2) tar xfz 629-PPPPP-KKKK-FLD-DDDDD.tgz

  Running partnerdiag diagnostics
  --------------------------------

  Please follow these steps:
  1) cd 629-PPPPP-KKKK-FLD-DDDDD
  2) Run partner ddiag
  - Mfg  : sudo ./partnerdiag --mfg --run_spec=spec_blackwell-hgx-8-gpu_partner_mfg.json --run_on_error --no_bmc
  - Field: sudo ./partnerdiag --field --run_on_error --no_bmc
  3) PASS/FAIL/RETEST will be displayed when partnerdiag finishes execution.
  4) Run ./partnerdiag --help for more details on options

  Useful Options
  --------------

  1) --skip_tests=<virtual_id>,<virtual_id> --> Skips the specified list of tests.
  2) --test=<virtual_id>,<virtual_id> --> Tests the specified list of tests.
  - e.g. Skip test coverage of CX-7/BF3 outside Blackwell HGX platform
    sudo ./partnerdiag --mfg --run_spec=spec_blackwell-hgx-8-gpu_partner_mfg.json --run_on_error --no_bmc --skip_tests=ExtThetaBgStart,ExtEyeGradeBgStart,ExtIBStress,ExtEyeGradeBgStop,ExtThetaBgStop,ExtIBconnectivity
  - e.g. Test Gpu coverage
    sudo ./partnerdiag --mfg --run_spec=spec_blackwell-hgx-8-gpu_partner_mfg.json --run_on_error --no_bmc --test=pcie,connectivity
    sudo ./partnerdiag --field --run_on_error --no_bmc --test=pcie,connectivity
  3) Regarding partner field diag, specify different test coverage for partnerdiag (the default value is --level2)
  - e.g. --level1 --> Level 1 Tests
    sudo ./partnerdiag --field --level1 --run_on_error --no_bmc
  - e.g. --level2 --> Level 2 Tests
    sudo ./partnerdiag --field --level2 --run_on_error --no_bmc

  Contacts
  --------

  Please email NVIDIA AE team
