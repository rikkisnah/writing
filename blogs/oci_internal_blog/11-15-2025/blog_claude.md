# NCCL Demystified: From First Principles to OCI GPU Infrastructure

## Why NCCL Exists

When training large AI models across multiple GPUs, communication becomes the critical bottleneck. GPUs need to exchange gradients, synchronize parameters, and share intermediate results constantly. Without optimized communication, even the fastest GPUs sit idle waiting for data. NCCL (NVIDIA Collective Communication Library) solves this by providing highly optimized, hardware-aware communication primitives that exploit GPU interconnect technologies like NVLink, NVSwitch, PCIe, and InfiniBand.

## Understanding NCCL Collectives

NCCL implements five fundamental collective operations that form the backbone of distributed training:

**AllReduce** combines data from all GPUs and distributes the result back to everyone. During gradient aggregation in distributed training, each GPU computes local gradients, AllReduce sums them across all GPUs, and everyone receives the averaged gradient.

**AllGather** collects distinct data from each GPU and shares the complete dataset with all GPUs. If GPU0 has [A], GPU1 has [B], GPU2 has [C], after AllGather, all GPUs have [A,B,C].

**ReduceScatter** performs reduction and distributes unique portions to each GPU. Starting with all GPUs having full data, it reduces and scatters so each GPU ends with a unique chunk of the reduced result.

**Broadcast** sends data from one GPU to all others. The root GPU's data replicates to every other GPU in the cluster.

**Reduce** aggregates data from all GPUs to a single destination GPU, useful for centralized parameter servers.

## NCCL Algorithms and Protocols

NCCL intelligently selects algorithms based on message size and topology. The **Ring** algorithm passes data in a circular pattern, optimal for small messages with linear scaling. The **Tree** algorithm creates hierarchical communication patterns, reducing latency for medium messages. **SplitTree** divides data into chunks processed by different trees simultaneously, maximizing bandwidth for large transfers.

Protocol selection affects how data moves through the network. **Simple** protocol transfers data directly, best for large messages. **LL (Low Latency)** optimizes for small messages with reduced overhead. **LL128** enhances LL with 128-byte chunks for better throughput on modern hardware.

## Running NCCL Tests on OCI

NCCL tests validate cluster communication and measure achievable bandwidth. Here's how different OCI GPU shapes are configured:

### GB200 Configuration
```bash
# GB200 uses NVLink fabric with IMEX for optimal topology
mpirun --mca btl_tcp_if_include eth0 --map-by ppr:4:node \
  --host 10.0.14.178:4,10.0.9.172:4 \
  -x NCCL_DEBUG=WARN \
  -x NCCL_CUMEM_ENABLE=1 \
  -x NCCL_NET_PLUGIN=sys \
  -x NCCL_NVLS_ENABLE=1 \
  -x NCCL_MNNVL_ENABLE=1 \
  -x NCCL_IB_HCA=^mlx5 \
  -x NCCL_IB_DISABLE=1 \
  -np 72 \
  /opt/oci-hpc/nccl-tests/build/all_reduce_perf -b 8 -e 16G -f 2 -g 1
```

GB200's architecture delivers exceptional NVLink bandwidth. Testing shows 900+ GB/s at large message sizes through the NVSwitch fabric, with theoretical unidirectional bandwidth of 900 GB/s (18 switch ASICs × 400 Gbps ÷ 8). For InfiniBand, GB200 achieves 385 Gbps (96% line rate) in ib_write tests, though NCCL AllReduce over IB reaches approximately 136 GB/s due to algorithm overhead.

### H100/H200 Configuration
```bash
mpirun --mca pml ucx --bind-to numa \
  -npernode 8 \
  --mca coll ^hcoll \
  -x NCCL_DEBUG=WARN \
  -x NCCL_NET_PLUGIN=<detected-path> \
  -x UCX_TLS=tcp \
  -x UCX_NET_DEVICES=eth0 \
  -x NCCL_IB_HCA="mlx5_..." \
  --np <#gpus> \
  --hostfile <hostfile> \
  /opt/oci-hpc/nccl-test/build/all_reduce_perf -b 1G -e 16G -f 2 -g 1
```

H100/H200 achieves approximately 360-400 GB/s aggregate bandwidth, leveraging 8×400 Gbps connections per node.

### MI300X Configuration
```bash
mpirun --bind-to numa \
  --mca oob_tcp_if_exclude docker,lo \
  --mca btl_tcp_if_exclude docker,lo \
  --mca btl ^openib \
  -np 128 \
  -x NCCL_DEBUG=VERSION \
  -x NCCL_IB_HCA=mlx5_0,mlx5_2,mlx5_3,mlx5_4,mlx5_5,mlx5_7,mlx5_8,mlx5_9 \
  -x NCCL_SOCKET_IFNAME=rdma0 \
  -x NCCL_IB_TC=41 \
  -x NCCL_IB_SL=0 \
  -x NCCL_IB_GID_INDEX=3 \
  -x NCCL_IB_QPS=2 \
  -x NCCL_IB_SPLIT_DATA_ON_QPS=4 \
  -x NCCL_ALGO=Ring \
  --host hpc-node-1:8,hpc-node-2:8 \
  -N 8 -np 16 \
  /opt/rccl-tests/build/all_reduce_perf -b 8 -e 16G -f 2 -g 1
```

## Critical NCCL Parameters

**NCCL_DEBUG** controls logging verbosity (WARN/INFO/VERSION/TRACE). Use WARN for production, INFO for basic debugging, TRACE for deep troubleshooting.

**NCCL_ALGO** forces specific algorithms (Ring/Tree/SplitTree). Auto-selection typically performs best unless debugging specific issues.

**NCCL_PROTO** selects protocol (Simple/LL/LL128). Simple excels for large messages, LL for latency-sensitive small messages.

**NCCL_IB_HCA** specifies InfiniBand devices. On OCI, use mlx5 devices matching your RDMA NICs.

**NCCL_IB_TC** sets InfiniBand traffic class (OCI recommends 41 or 105 for RoCE).

**NCCL_IB_GID_INDEX** selects the GID table entry (typically 3 for RoCEv2 on OCI).

**NCCL_TOPO_FILE** provides custom topology when auto-discovery fails.

## Common OCI-Specific Issues

**"NCCL WARN NET/IB: No device found"** occurs when NCCL cannot access InfiniBand devices. Verify mlx5 devices exist, check NCCL_IB_HCA settings, and ensure proper RDMA configuration.

**Incorrect GPU-NIC mapping** causes suboptimal routing. OCI's dr-hpc tool generates topology maps. Verify with `nvidia-smi topo -m` and ensure each GPU maps to appropriate RDMA interfaces.

**Out-of-order mlx5 enumeration** breaks expected device ordering. Use explicit device lists in NCCL_IB_HCA rather than wildcards.

**Multi-node SSH environment propagation** fails to pass NCCL variables. Always use `-x` flags with mpirun to explicitly propagate environment variables.

## Understanding NCCL Output

NCCL reports several bandwidth metrics. **Bus bandwidth** represents the data transfer rate as observed by the algorithm, accounting for redundant transfers in ring or tree patterns. **Algorithm bandwidth** shows the effective application-level throughput. For AllReduce, multiply bus bandwidth by (2×(n-1)/n) to get algorithm bandwidth, where n is the number of ranks.

OCI's topology significantly impacts NCCL behavior. GB200's NVSwitch fabric enables near-linear scaling within racks. Cross-rack communication over InfiniBand shows different characteristics—bandwidth drops but remains substantial for large-scale training. The architecture treats each 72-GPU rack as a giant single node when NVLink is utilized effectively.

## Key Takeaways

NCCL automatically optimizes communication patterns, but understanding its behavior helps diagnose issues and tune performance. On OCI, each GPU shape requires specific configuration—GB200 leverages IMEX and NVSwitch, H100/H200 uses traditional NVLink with InfiniBand, and MI300X requires RCCL with specific GID indices.

Bandwidth numbers vary dramatically based on test parameters. GB200 achieves 900+ GB/s over NVLink but approximately 136 GB/s over InfiniBand for NCCL AllReduce. The gap between theoretical and achieved bandwidth stems from algorithm overhead, protocol selection, and topology constraints.

When troubleshooting, start with NCCL_DEBUG=INFO to understand topology discovery, verify device enumeration matches expectations, and ensure environment variables propagate correctly across nodes. Remember that bus bandwidth and algorithm bandwidth measure different things—focus on algorithm bandwidth for actual application performance.

## References

1. NVIDIA NCCL User Guide: https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/overview.html
2. NVIDIA NCCL Tests Repository: https://github.com/NVIDIA/nccl-tests
3. OCI HPC GitHub Repository: https://github.com/oracle-quickstart/oci-hpc
4. NCCL Test Performance Metrics: https://github.com/NVIDIA/nccl-tests/blob/master/doc/PERFORMANCE.md
5. OCI GPU Architecture and NCCL Optimization (Internal Documentation)
6. Burn-in Orchestrator NCCL Test Suite (OCI Internal)
7. GB200 Cross-Rack InfiniBand Testing Results (OCI Confluence)
8. AMD RCCL Documentation: https://rocm.docs.amd.com/projects/rccl/en/latest/