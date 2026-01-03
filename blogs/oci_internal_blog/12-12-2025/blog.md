# From the Front Lines: What Our Architects Are Hearing from OCI GPU Customers

*A conversation with John Shelley, Arnaud Froidmond, and Oguz from Strategic Accounts and Solutions Architecture*

---

In the world of enterprise AI, there's often a gap between what engineering teams build and what customers actually experience. To bridge that gap, we sat down with three architects who live in customer conversations every single day: John Shelley from Strategic Customer Engineering, and Arnaud Froidmond and Oguz from the North America Solutions Architecture team focused on GPUs.

These three have a combined view spanning from our largest strategic accounts—customers spending $100–200 million annually—down to AI startups who, as Arnaud put it, "barely know how to SSH into a node." Their insights reveal not just what makes OCI's GPU infrastructure compelling, but what customers truly struggle with and where we're headed next.

## Two Teams, One Mission

The organizational structure might seem complex at first glance. John's Strategic Customer Engineering team works with Oracle's largest AI customers—those with significant annual consumption rates (ACR) who often command direct executive attention. Arnaud and Oguz's team handles the next 100–150 GPU customers, focusing on scale and repeatability.

But as John emphasized, the line isn't rigid. "We constantly reach out to each other to share patterns and lessons learned. It's a strong partnership."

Arnaud added with characteristic French wit: "We joke around, but in reality there's a lot of overlap. Both teams often engage with the same customers. Ultimately, it doesn't matter who helps—as long as the customer succeeds."

And when problems emerge? "It usually affects everyone regardless of size," Oguz noted. "We work closely together to fix what's broken."

## What Makes OCI Different

When customers compare clouds for GPU workloads, three differentiators consistently emerge.

**Bare Metal Matters.** Other hyperscalers rely heavily on virtualization, which consumes memory and CPU resources while adding complexity through SR-IOV and passthrough configurations. With OCI, customers get the entire system with full control—no hypervisor underneath. For AI workloads that push hardware to its limits, this direct access translates to better performance and simpler debugging.

**RoCE Networking Changes the Game.** John came to Oracle from Azure with preconceptions. "I believed RoCE was bad and InfiniBand was great. After testing OCI's RoCE, I was amazed at how comparable it is in performance and ease of use."

But the advantages go beyond performance parity. RoCE scales better than InfiniBand and benefits from Ethernet's faster evolution—800G NICs are arriving on the RoCE roadmap sooner than InfiniBand equivalents. The architecture itself, developed internally by IC7 Jag Prar (the JFAB fabric is literally named after him—"Jag's Fabric"), avoids the proprietary fabric manager dependencies that limit InfiniBand's scalability.

**Expert Access.** Having architects like John, Arnaud, and Oguz directly engaged with customers makes a measurable difference. These aren't support ticket handlers—they're engineers who understand the full stack, from GPU silicon to distributed training frameworks.

## The Three Workloads Shaping Our Infrastructure

Arnaud broke down the GPU workloads they see into three categories.

**Large-scale AI training** remains the most demanding. Thousands of GPUs working in concert, where a single node failure or cable flap can halt an entire training run. These workloads are fragile by nature—collective operations require all participants, and one slow node can bottleneck an entire cluster.

**Inference** represents a different challenge. Generally simpler and often single-node, inference workloads typically don't require RDMA and frequently run in Kubernetes environments. The team receives fewer support calls for inference, though the volume of inference workloads continues to grow.

**Emerging workloads** like healthcare (more traditional HPC patterns) and robotics are growing quickly. These often blend AI with simulation and require different optimization strategies than pure training or inference.

Across all three categories, one theme dominated the conversation: **storage is critical**. "GPUs need data—fast object storage, Lustre, FSS," Arnaud emphasized. "Data throughput is often the real bottleneck."

## What Customers Struggle With Most

Oguz's answer to this question was immediate and pointed.

**First: accepting that hardware failures are normal.** "Customers treat hardware failures as exceptional. At scale, they're not." He referenced research on large-scale ML cluster reliability [[1]](#references) showing that with 500 GPUs, failures happen every few days. With 16,000 GPUs, failures are expected in every job.

The implication is profound: customers need automated repair, checkpointing, and fault tolerance built into their workloads from day one. Treating failures as edge cases leads to operational disaster at scale.

**Second: storage design must be first-class.** "GPUs without a solid data pipeline sit idle. Storage design must be first-class, not an afterthought." Too many customers provision massive GPU clusters and then bolt on storage as an afterthought, only to discover their expensive accelerators are starved for data.

## How OCI Addresses Reliability at Scale

The solution starts with comprehensive health checks—both passive monitoring and active probing—combined with smart auto-remediation. But as Oguz explained, the challenge is balance.

"Sometimes you reboot. Sometimes you reset GPUs. Sometimes you degrade performance but keep workloads running. The goal is resilience without interruption."

Overreacting to every anomaly creates its own problems: unnecessary downtime, thrashing, and customer frustration. The art is knowing when a GPU reset suffices, when a full node reboot is warranted, and when graceful degradation is the right answer. OCI's health check and auto-remediation capabilities are documented in DR-HPC v2 [[2]](#references).

The multi-planar network architecture represents perhaps the most exciting reliability innovation. "Disjoint planes mean failures degrade performance but don't stop workloads," Oguz explained. When one network plane experiences issues, workloads continue on the remaining planes—slower, perhaps, but running.

## The Trajectory That Excites Us

The growth trajectory these architects have witnessed is remarkable.

"Five years ago, our first deal was tiny," Arnaud recalled. "Now we're closing deals 1,000× larger. Customers constantly push limits, and we keep breaking and redesigning OCI."

The tooling has evolved alongside the scale. Kubernetes stacks and Slurm clusters now let customers go from zero to running PyTorch in under an hour—a dramatic improvement from the early days of manual configuration.

John's perspective spans his time at Oracle: "When I joined, we had three strategic AI customers. Now we're deploying GFABs multiple times per year. We're talking 128,000-GPU clusters with multi-planar designs."

The pace of innovation extends across the entire stack. "We're pushing compute, network, and storage to new limits," John continued. "We're bleeding, learning, and having fun."

## The Real Product

Perhaps the most valuable insight from this conversation isn't about technology at all. It's about what happens when engineering builds products that actually solve customer problems.

As the architects made clear, their role is to ensure what engineering builds turns into a crisp customer experience—and ultimately, revenue. They advocate back to engineering, help customers navigate complexity, and serve as the essential feedback loop that keeps product development grounded in reality.

The customers pushing limits today are the ones who will define what our infrastructure needs to become tomorrow. And having architects embedded in those conversations—breaking things, learning, and bringing insights back to engineering—is what makes continuous improvement possible.

For those of us building OCI's GPU infrastructure, that's the real privilege: not just creating technology, but seeing it transform how customers build the future of AI.

## References

[1] [Revisiting Reliability in Large-Scale Machine Learning Research Clusters](https://ai.meta.com/research/publications/revisiting-reliability-in-large-scale-machine-learning-research-clusters/)

[2] [OCI DR-HPC v2 Documentation](https://bitbucket.oci.oraclecorp.com/projects/CCCP/repos/oci-dr-hpc-v2/browse)

---

*For more on GPU/HPC health checks and diagnostic tooling referenced in this conversation, see the [DR-HPC v2 documentation](https://bitbucket.oci.oraclecorp.com/projects/CCCP/repos/oci-dr-hpc-v2/browse).*
