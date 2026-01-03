# NCCL Demystified: From First Principles to OCI GPU Infrastructure

## Why NCCL Exists

Training large AI models across multiple GPUs hinges on efficient communication. GPUs must frequently exchange gradients, synchronize parameters, and share intermediate activations—otherwise, even the most powerful hardware idles while awaiting data transfers. The NVIDIA Collective Communication Library (NCCL) addresses this bottleneck with hardware-optimized primitives tailored to GPU interconnects like NVLink, NVSwitch, PCIe, and InfiniBand. By minimizing latency and maximizing bandwidth, NCCL ensures that communication scales with compute, enabling efficient distributed training.

## Understanding NCCL Collectives

NCCL provides five core collective operations essential for distributed deep learning:

- **AllReduce**: Aggregates data (e.g., via sum or average) from all GPUs and broadcasts the result back to every participant. In backpropagation, this sums local gradients across GPUs, yielding averaged gradients for all to update their models.

- **AllGather**: Gathers unique data chunks from each GPU and distributes the full collection to everyone. For example, if GPU 0 holds [A], GPU 1 holds [B], and GPU 2 holds [C], AllGather ensures all GPUs end with [A, B, C].

- **ReduceScatter**: Reduces data across all GPUs while scattering unique portions of the result to each. Starting with identical full tensors on all GPUs, it produces sharded reduced outputs, ideal for model parallelism.

- **Broadcast**: Originates data from a root GPU and replicates it to all others, useful for initializing shared parameters or distributing hyperparameters.

- **Reduce**: Gathers and reduces data from all GPUs to a single root, supporting centralized architectures like parameter servers.

These primitives form the foundation of frameworks like PyTorch Distributed and Horovod.

## NCCL Algorithms and Protocols

NCCL dynamically selects algorithms and protocols based on message size, GPU count, and network topology for optimal performance:

- **Ring**: Chains GPUs in a loop for sequential data relay. It scales linearly and suits small-to-medium messages but incurs higher latency for large ones.

- **Tree**: Builds hierarchical trees for parallel reduction and distribution, excelling in latency for medium-sized messages across many GPUs.

- **SplitTree**: Parallelizes multiple trees to process data chunks concurrently, boosting bandwidth for large messages.

Protocols dictate data movement efficiency:

- **Simple**: Direct transfers for high throughput on large payloads.

- **LL (Low-Latency)**: Streamlined overhead for small messages.

- **LL128**: An enhanced LL variant using 128-byte chunks, optimized for modern NVLink and InfiniBand hardware.

Auto-selection typically outperforms manual overrides, but tuning can unlock gains in constrained environments.

## Running NCCL Tests on OCI

NCCL-tests benchmark communication performance and validate setups. Oracle Cloud Infrastructure (OCI) GPU shapes demand tailored configurations to leverage their topologies. Below are examples for key shapes; adjust hostfiles and GPU counts for scale.

### GB200 Configuration
GB200 NVL72 racks deliver massive intra-rack bandwidth via NVLink and NVSwitch. Use IMEX (intra-node multi-rail exchange) for topology awareness.

```bash
# Example for partial rack (scale --host and -np for full 72-GPU NVL72)
mpirun --mca btl_tcp_if_include eth0 --map-by ppr:4:node \
  --host 10.0.14.178:4,10.0.9.172:4 \
  -x NCCL_DEBUG=WARN \
  -x NCCL_CUMEM_ENABLE=1 \
  -x NCCL_NET_PLUGIN=sys \
  -x NCCL_NVLS_ENABLE=1 \
  -x NCCL_MNNVL_ENABLE=1 \
  -x NCCL_IB_HCA=^mlx5 \
  -x NCCL_IB_DISABLE=1 \
  -np 8 \
  /opt/oci-hpc/nccl-tests/build/all_reduce_perf -b 8 -e 16G -f 2 -g 1
```

For full-rack testing (-np 72), expect 900+ GB/s bus bandwidth on large messages via NVSwitch (theoretical unidirectional: 900 GB/s from 18 × 400 Gbps ASICs). Over InfiniBand, ib_write hits 385 Gbps (96% line rate), but AllReduce yields ~136 GB/s due to algorithmic overhead.

### H100/H200 Configuration
These shapes use 8 GPUs per node with NVLink and RoCE-enabled InfiniBand.

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
  /opt/oci-hpc/nccl-tests/build/all_reduce_perf -b 1G -e 16G -f 2 -g 1
```

Aggregate bandwidth reaches 360–400 GB/s, driven by 8 × 400 Gbps links per node.

### MI300X Configuration
AMD's MI300X uses RCCL (Radeon Collective Communications Library). Tune for 8 GPUs/node and RoCEv2.

```bash
mpirun --bind-to numa \
  --mca oob_tcp_if_exclude docker,lo \
  --mca btl_tcp_if_exclude docker,lo \
  --mca btl ^openib \
  -npernode 8 \
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
  --np 16 \
  /opt/rccl-tests/build/all_reduce_perf -b 8 -e 16G -f 2 -g 1
```

## Critical NCCL Parameters

Key environment variables for tuning:

- **NCCL_DEBUG**: Logging levels (e.g., WARN for production, INFO for debugging, TRACE for exhaustive traces).

- **NCCL_ALGO**: Override algorithm (Ring, Tree, SplitTree). Defaults to auto-selection.

- **NCCL_PROTO**: Choose protocol (Simple for bandwidth, LL/LL128 for latency).

- **NCCL_IB_HCA**: Pin to specific InfiniBand HCAs (e.g., mlx5 devices on OCI).

- **NCCL_IB_TC**: Traffic class for RoCE (OCI recommends 41 or 105).

- **NCCL_IB_GID_INDEX**: GID entry for RoCEv2 (typically 3 on OCI).

- **NCCL_TOPO_FILE**: Supply a custom topology XML if auto-detection falters.

## Common OCI-Specific Issues

- **"NCCL WARN NET/IB: No device found"**: NCCL can't reach InfiniBand. Confirm mlx5 devices (`ibv_devinfo`), set NCCL_IB_HCA explicitly, and validate RDMA setup.

- **Suboptimal GPU-NIC Mapping**: Mismatched affinities degrade performance. Use OCI's `dr-hpc` tool for topology; cross-check with `nvidia-smi topo -m` (or `rocm-smi` for AMD).

- **Mismatched mlx5 Enumeration**: Device order varies; list HCAs explicitly in NCCL_IB_HCA instead of patterns.

- **Environment Propagation Failures**: SSH/multi-node setups drop vars. Prefix with `-x` in mpirun for reliable export.

## Understanding NCCL Output

NCCL-tests output includes:

- **Bus Bandwidth**: Raw transfer rate, factoring in algorithmic redundancy (e.g., rings duplicate data).

- **Algorithm Bandwidth**: Effective end-to-end throughput. For AllReduce on *n* ranks, approximate as bus bandwidth × (2 × (*n*-1) / *n*).

On OCI, NVLink shines intra-rack (near-linear scaling in GB200), while InfiniBand handles cross-rack with bandwidth trade-offs. Treat GB200 racks as "super-nodes" when NVLink dominates.

## Key Takeaways

NCCL's auto-optimizations shine in production, but manual insight accelerates troubleshooting and fine-tuning. OCI shapes vary: GB200 maximizes NVSwitch/IMEX, H100/H200 balances NVLink/RoCE, and MI300X demands RCCL-specific tweaks.

Performance gaps (e.g., GB200's 900+ GB/s NVLink vs. 136 GB/s IB AllReduce) arise from overheads—prioritize algorithm bandwidth for real-world metrics. Debug systematically: Enable INFO logging, audit topologies, and propagate vars. With these, OCI clusters unlock NCCL's full potential for AI at scale.

## References

1. [NVIDIA NCCL User Guide](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/overview.html)
2. [NVIDIA NCCL Tests Repository](https://github.com/NVIDIA/nccl-tests)
3. [OCI HPC GitHub Repository](https://github.com/oracle-quickstart/oci-hpc)
4. [NCCL Test Performance Metrics](https://github.com/NVIDIA/nccl-tests/blob/master/doc/PERFORMANCE.md)
5. OCI GPU Architecture and NCCL Optimization (Internal Documentation)
6. Burn-in Orchestrator NCCL Test Suite (OCI Internal)
7. GB200 Cross-Rack InfiniBand Testing Results (OCI Confluence)
8. [AMD RCCL Documentation](https://rocm.docs.amd.com/projects/rccl/en/latest/)