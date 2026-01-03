Here is a **clean, consolidated, LLM-ready master prompt** suitable for generating the full 1000–1200-word NCCL + OCI blog. No wording changed semantically—just clarified, tightened, and standardized.

---

# **Purpose**

Produce a **1000–1200 word** technical blog that explains **NCCL from first principles** and shows how these principles apply to **OCI / AI2 Compute GPU infrastructure**.
The blog must use the reference materials listed below and include concrete examples from **GB200**, **H100**, and **H200** GPU shapes on OCI.

---

# **Blog Requirements**

## **1. NCCL Fundamentals (First Principles)**

Explain NCCL clearly and from first principles:

* Why NCCL exists
* GPU peer-to-peer communication
* Collective operations:

  * AllReduce, AllGather, ReduceScatter, Broadcast, Reduce
* Include small, intuitive examples of data movement for each collective
* Explain NCCL algorithms: Ring, Tree, SplitTree
* Explain NCCL protocols: LL, LL128, Simple

## **2. NCCL Tests (`nccl-tests`)**

Describe how `nccl-tests` work and how to interpret results:

* Key NCCL environment variables:

  * `NCCL_DEBUG`
  * `NCCL_ALGO`
  * `NCCL_PROTO`
  * `NCCL_IB_DISABLE`
  * `NCCL_TOPO_FILE`
  * Variables related to RDMA, PCIe, and NVLink
* Include example NCCL test command lines (based on reference repos)
* Include example output and explain:

  * Bandwidth values
  * Algorithm selection
  * Protocol selection
* Explain how each parameter affects performance

## **3. NCCL Test Parameters (Dedicated Section)**

Explain the purpose, default behavior, and performance impact of commonly used NCCL test parameters:

* `NCCL_DEBUG`
* `NCCL_ALGO`
* `NCCL_PROTO`
* `NCCL_MAX_NRINGS`
* `NCCL_IB_DISABLE`
* `NCCL_NET_GDR_LEVEL`
* `NCCL_TOPO_FILE`
* `NCCL_SHM_DISABLE`
* Any additional parameters referenced in the provided documents

## **4. Common NCCL-Test Issues on OCI (Dedicated Section)**

Describe common OCI-specific problems when running NCCL tests:

* `NCCL WARN NET/IB: No device found`
* Incorrect GPU–NIC mapping
* Topology discovery failures
* PCIe/NUMA misalignment
* RDMA disabled unexpectedly
* Multi-node issues due to SSH or SLURM environment propagation
* Mismatched NCCL/CUDA versions
* Slurm node configuration errors
* Out-of-order mlx5 device enumeration

For each:

1. Show the error pattern.
2. Explain the root cause.
3. Provide the corrective action.

## **5. OCI GPU Shape Examples**

For **GB200**, **H100**, **H200**, and additional OCI shapes as referenced:

* Include the NCCL test command lines used in production/burn-in
* Describe topology behavior:

  * NVLink
  * NVSwitch
  * PCIe Gen4/Gen5
  * RDMA NIC (ConnectX-7/8) mapping
* Use NCCL bandwidth numbers from the references (do not invent values)
* Summarize topology differences and how NCCL chooses communication paths
* Incorporate insights from:

  * OCI HPC repo
  * Perplexity NCCL research
  * Perplexity OCI-specific NCCL analysis
  * Nikhil’s explanation of GB200 bandwidth
  * Burn-in orchestrator NCCL logic

## **6. Explanation of NCCL Output & Logs**

Clarify:

* Bus bandwidth vs. algorithm bandwidth
* Raw vs. effective bandwidth
* GPU Direct RDMA behavior
* How NCCL discovers topology (PCIe graph, NVLink, InfiniBand, SHARP)
* How to interpret log levels (`INFO`, `WARN`, `TRACE`)
* Why different OCI GPU shapes produce different NCCL behaviors even with the same GPU

## **7. Writing Requirements**

* Total length: **1000–1200 words**
* Concise, technically accurate, and accessible
* Conversational but precise tone
* Logical flow:
  **First principles → collectives → algorithms → NCCL tests → OCI topology → examples → debugging → references**

## **8. Reference Section**

End the blog with a **numbered reference section**. Every factual claim or dataset must map to one of the referenced documents below.

---

# **Reference Materials to Use (All Required)**

Use only information from these sources. Do **not** invent data not supported by them.

1. **OCI HPC GitHub repo** (NCCL + SLURM examples)
   `/mnt/data/src/oci-hpc`
   [https://github.com/oracle-quickstart/oci-hpc](https://github.com/oracle-quickstart/oci-hpc)

2. **Perplexity NCCL research**
   `perpexity_research.md`
   (General NCCL & NCCL tests)

3. **Perplexity research specific to OCI NCCL tests**
   `perpplxity_oci_nccl.md`
   (OCI GPU topology + NCCL behavior)

4. **Nikhil’s Slack explanation — GB200 bandwidth & NCCL interpretation**
   `/mnt/data/src/rikkisnah/oci-runbooks/blogs/oci_internal_blog/11-15-2025/nikhil_explains_gb200_bandwidth_nccl.md`

5. **Burn-in orchestrator codebase** (real-world NCCL test commands)
   `/mnt/data/src/burn-in-orchestrator`

6. **NVIDIA NCCL User Guide**
   [https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/overview.html](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/overview.html)

7. **OCI Compute — Golden NCCL Commands**
   `OCI Compute Golden NCCL Commands for GPUs.md`

8. **OCI Network Engineers — NCCL Basics**
   `OCI Network CCL Basics for Network Engineers.pdf`

---

# **Deliverable**

Produce a **single, self-contained 1000–1200 word blog** that includes:

* NCCL fundamentals
* Explanation of collectives
* Algorithms and protocols
* NCCL tests and parameters
* Common NCCL-test errors on OCI
* OCI-specific examples across GB200, H100, H200
* A structured reference section

---

If you want, I can now generate the **full blog** from this prompt.
