[Purpose [1](#purpose)](#purpose)

[A100 [1](#a100)](#a100)

[H100 / H200 [1](#h100-h200)](#h100-h200)

[MI300X [1](#mi300x)](#mi300x)

[GB200 [1](#gb200)](#gb200)

[Appendix [1](#appendix)](#appendix)

[Appendix A -- Bookmarks
[2](#appendix-a-bookmarks)](#appendix-a-bookmarks)

[Appendix B -- Prerequisites
[2](#appendix-b-prerequisites)](#appendix-b-prerequisites)

# Purpose

This page lists the NCCL Parameters for GPU SKUs in OCI. NCCL Parameters
are tricky by nature. This page lists the parameters that Compute has
validated in its test environment.

# A100

In progress\...

# H100 / H200

+-----------------------------------------------------------------------+
| mpirun \--mca pml ucx \\                                              |
|                                                                       |
| \--bind-to numa \\                                                    |
|                                                                       |
| -npernode 8 \\                                                        |
|                                                                       |
| \--mca coll \^hcoll \\                                                |
|                                                                       |
| -x NCCL_DEBUG=WARN \\                                                 |
|                                                                       |
| -x NCCL_NET_PLUGIN=\<detected-path\> \\                               |
|                                                                       |
| -x UCX_TLS=tcp \\                                                     |
|                                                                       |
| -x UCX_NET_DEVICES=eth0 \\                                            |
|                                                                       |
| -x NCCL_IB_HCA=\"mlx5\_\...\" \\                                      |
|                                                                       |
| \--np \<#gpus\> \\                                                    |
|                                                                       |
| \--hostfile \<hostfile\> \\                                           |
|                                                                       |
| /opt/oci-hpc/nccl-test/build/all_reduce_perf -b 1G -e 16G -f 2 -g 1   |
+=======================================================================+
+-----------------------------------------------------------------------+

# MI300X

Compute SME: [\@Jeff Jin](mailto:guoxing.jin@oracle.com)

Ref:
<https://confluence.oraclecorp.com/confluence/display/AAGE/Scale+testing+for+BKC-24-12-10>

<https://confluence.oraclecorp.com/confluence/display/AAGE/Scale+testing+for+BKC-24-12-10>

<https://confluence.oraclecorp.com/confluence/display/AAGE/NPI+Scale+testing+for+MI300X+BKC-24-12-10>

+-----------------------------------------------------------------------+
| *\# Don\'t forget to set the number of nodes and GPUs per node*       |
|                                                                       |
| /usr/mpi/gcc/openmpi-4.1.5rc2/bin/mpirun \--bind-to numa \--mca       |
| oob_tcp_if_exclude docker,lo \--mca btl_tcp_if_exclude docker,lo      |
| \--mca btl \^openib -np 128 -x NCCL_DEBUG=VERSION -x                  |
| NCCL_IB_HCA=mlx5_0,mlx5_2,mlx5_3,mlx5_4,mlx5_5,mlx5_7,mlx5_8,mlx5_9   |
| -x NCCL_SOCKET_IFNAME=rdma0 -x NCCL_IB_TC=41 -x NCCL_IB_SL=0 -x       |
| NCCL_IB_GID_INDEX=3 -x NCCL_IB_QPS=2 -x NCCL_IB_SPLIT_DATA_ON_QPS=4   |
| -x NCCL_ALGO=Ring \--host hpc-node-1:8,hpc-node-2:8 -N 8 -np \$(2\*8) |
| /opt/rccl-tests/build/all_reduce_perf -b 8 -e 16G -f 2 -g 1           |
+=======================================================================+
+-----------------------------------------------------------------------+

# GB200

Compute SME: [\@Niharika Sharma](mailto:niharika.s.sharma@oracle.com)

Note: You need IMEX to be set up
<https://dyn.slack.com/archives/C095W2Y8C7J/p1752261596119919?thread_ts=1752250888.071679&cid=C095W2Y8C7J>

Ref: [NCCL over NVLink and IB on
GB200.pptx](https://oracle.sharepoint.com/:p:/r/teams/AI2ComputeCollaboration/Shared%20Documents/Projects/GPU%20SKUs/GB200/Presentations/MDC%20GB200%20CPV%20Onboarding%20Training/NCCL%20over%20NVLink%20and%20IB%20on%20GB200.pptx?d=w43cc588322164063b9aead529cdc15f7&csf=1&web=1&e=ta8r2p)

+-----------------------------------------------------------------------+
| *\# Don\'t forget to set the host file and change the np to the       |
| number of nodesx4 GPUs*                                               |
|                                                                       |
| /usr/bin/mpirun \--mca btl_tcp_if_include eth0 \--map-by ppr:4:node   |
| \--host \<10.0.14.178:4,10.0.9.172:4\...\> -x NCCL_DEBUG=WARN -x      |
| NCCL_CUMEM_ENABLE=1 -x NCCL_NET_PLUGIN=sys -x NCCL_NVLS_ENABLE=1 -x   |
| NCCL_MNNVL_ENABLE=1 -x NCCL_IB_HCA=\^mlx5 -x NCCL_IB_DISABLE=1 -np 72 |
| /opt/oci-hpc/nccl-tests/build/all_reduce_perf -b 8 -e 16G -f 2 -g 1   |
+=======================================================================+
+-----------------------------------------------------------------------+

# Appendix

## Appendix A -- Bookmarks

\[1\] NCCL Environment variables:
<https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/env.html>

<https://github.com/NVIDIA/nccl>

\[2\] RCCL Environment variables:
<https://rocm.docs.amd.com/projects/rccl/en/latest/api-reference/library-specification.html>

<https://github.com/rocm/rccl>

\[3\] OCI Solutions Architecture team:
<https://github.com/oracle-quickstart/oci-hpc/blob/master/samples/gpu/>

## Appendix B -- Prerequisites

+-----------------------------------------------------------------------+
| sudo iptables --F                                                     |
|                                                                       |
| *\# GB200*                                                            |
|                                                                       |
| /etc/nvidia-imex/nodes_config.cfg                                     |
|                                                                       |
| sudo systemctl restart nvidia-imex.service                            |
+=======================================================================+
+-----------------------------------------------------------------------+
