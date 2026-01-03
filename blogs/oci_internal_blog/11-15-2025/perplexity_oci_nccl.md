For running NCCL on Oracle Cloud Infrastructure (OCI), especially with multi-node GPU clusters, you need to set both NCCL environment variables and network parameters to optimize communication and ensure correct topology detection. Below are key OCI-specific NCCL commands and network-related environment variables commonly used in production and benchmarking scenarios.[1][2][3][4]

### Common NCCL Environment Variables for OCI

- **NCCL_SOCKET_FAMILY**: Force IPv4 or IPv6 usage.
  ```
  export NCCL_SOCKET_FAMILY=AF_INET
  ```
  Use `AF_INET6` for IPv6.[2][5]

- **NCCL_SOCKET_IFNAME**: Specify the network interface (e.g., `ens1f0`, `ib0`).
  ```
  export NCCL_SOCKET_IFNAME=ens1f0
  ```
  Replace with your actual interface name.[5][2]

- **NCCL_IB_TC**: InfiniBand traffic class (OCI recommended: 41 or 105).
  ```
  export NCCL_IB_TC=41
  ```
  For RoCE, use `NCCL_IB_TC=105`.[3]

- **NCCL_IB_SL**: InfiniBand service level (OCI recommended: 0 or 5).
  ```
  export NCCL_IB_SL=5
  ```
  Adjust based on your network setup.[3]

- **NCCL_IB_QPS_PER_CONNECTION**: Number of QPs per connection (default: 4).
  ```
  export NCCL_IB_QPS_PER_CONNECTION=4
  ```
  Increase for higher throughput if needed.[3]

- **NCCL_NET**: Force NCCL to use a specific network (e.g., InfiniBand or Socket).
  ```
  export NCCL_NET="IB"
  ```
  Use `"Socket"` for Ethernet.[2]

- **NCCL_OOB_NET_ENABLE** and **NCCL_OOB_NET_IFNAME**: Enable out-of-band communication and specify interface.
  ```
  export NCCL_OOB_NET_ENABLE=1
  export NCCL_OOB_NET_IFNAME=ens1f0
  ```
  Useful for multi-NIC setups.[2]

- **NCCL_CROSS_NIC**: Allow rings/trees to use different NICs.
  ```
  export NCCL_CROSS_NIC=1
  ```
  Improves inter-node performance with multiple NICs.[2]

### Example OCI NCCL Test Command

```bash
# Set environment variables for OCI
export NCCL_SOCKET_FAMILY=AF_INET
export NCCL_SOCKET_IFNAME=ens1f0
export NCCL_IB_TC=41
export NCCL_IB_SL=5
export NCCL_NET="IB"
export NCCL_OOB_NET_ENABLE=1
export NCCL_OOB_NET_IFNAME=ens1f0
export NCCL_CROSS_NIC=1

# Run NCCL test (all_reduce_perf example)
mpirun -np 2 -H node1,node2 ./build/all_reduce_perf -b 8 -e 16G -f 2 -g 8
```
Replace `node1,node2` with your actual node hostnames or IPs, and adjust the number of GPUs (`-g`) as needed.[4][6][1]

### OCI Network Configuration Notes

- Ensure your VCN, subnets, and security lists allow traffic between nodes on the required ports (typically 22 for SSH, and ports for NCCL communication).[7][8]
- Use the correct network interface names as shown in your OCI instance (check with `ip addr` or `ifconfig`).
- For InfiniBand, verify that the IB driver and fabric are correctly set up and that the traffic class and service level match your network configuration.[3]

These commands and environment variables are essential for running NCCL efficiently on OCI GPU clusters and are widely used in both benchmarking and production workloads.[1][4][2][3]

[1](https://blogs.oracle.com/cloud-infrastructure/post/run-lightning-fabric-nvidia-gpus-oci)
[2](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/env.html)
[3](https://blogs.oracle.com/cloud-infrastructure/post/gpu-oci-ai-and-hpc-jobs)
[4](https://blogs.oracle.com/cloud-infrastructure/post/accelerate-distributed-deep-learning-with-oci)
[5](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/index.html)
[6](https://github.com/NVIDIA/nccl-tests)
[7](https://docs.oracle.com/iaas/autonomous-database-shared/doc/access-control-rules-autonomous.html)
[8](https://docs.oracle.com/en-us/iaas/Content/KeyManagement/Tasks/ekms_setting_up_network_components.htm)
[9](https://docs.oracle.com/en/solutions/deploy-nvidia-ai-on-oci-gvt-region/review-and-validate-configuration1.html)
[10](https://github.com/oracle-quickstart/oci-hpc-oke)
[11](https://docs.public.content.oci.oraclecloud.com/en-us/iaas/compute-cloud-at-customer-isolated/c3i/config-initial-gui.htm)
[12](https://docs.nvidia.com/multi-node-nvlink-systems/multi-node-tuning-guide/nccl.html)
[13](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa-start-nccl.html)
[14](https://docs.public.content.oci.oraclecloud.com/en-us/iaas/tools/oci-cli/3.69.0/oci_cli_docs/cmdref/network/virtual-circuit/update.html)
[15](https://docs.oracle.com/en/learn/lab_virtual_network/index.html)
[16](https://www.juniper.net/documentation/us/en/software/jvd/jvd-ai-dc-evpn-multitenancy/appendix_d_how_to_run_nccl_tests_using_autoconfigured_ipv6_address.html)
[17](https://learn.microsoft.com/en-us/samples/azure/azureml-examples/run-nccl-tests-on-gpu-to-check-performance-and-configuration/)
[18](https://massedcompute.com/faq-answers/?question=What+are+the+optimal+settings+for+NCCL+parameters+in+a+multi-node+distributed+deep+learning+environment%3F)
[19](https://www.youtube.com/watch?v=DICo2-eRPC4)
[20](https://massedcompute.com/faq-answers/?question=How+to+configure+NCCL+to+troubleshoot+network+connectivity+issues%3F)