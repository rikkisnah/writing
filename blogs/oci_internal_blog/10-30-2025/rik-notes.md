#
Rik's Notes

## Oct 29, 2025 — Highlights

### Accelerating the Physical Era: Digital Twins & Real-Time Simulation (DCS1184)

- Digital twins (high-fidelity, real-time virtual models) are essential for simulation and optimization before real-world deployment.
- NVIDIA Omniverse enables operational twins for smart cities, energy, and industrial systems.
- **OCI implication**: Omniverse-based twin workflows can run on OCI GPU superclusters for scalable, cross-platform simulation and accelerated AI training.

### Quick Start to Accelerated Quantum Supercomputing (DCS51159)

- Hybrid quantum/classical compute connects QPUs and GPUs for advanced error correction, modeling, and simulation.
- NVIDIA NVQ Link introduces a scalable GPU–QPU integration architecture.
- **OCI implication**: Potential future support for hybrid quantum workflows leveraging NVIDIA’s quantum stack integrated with classical supercomputing on OCI.

### The AI Factory & the American Future: National Innovation Strategy (DCS1087)

- “AI Factories” are full-stack architectures integrating compute, storage, networking, and orchestration for industrial AI.
- Partnerships among NVIDIA, DOE, and Oracle are building large GPU-powered AI factories (e.g., Equinox, Solstice) to strengthen U.S. innovation.
- **OCI implication**: OCI superclusters serve as a template for secure, sovereign, and scalable AI factories.

### CUDA 13.0 — New Features and Beyond

- Adds foundational support for Blackwell GPUs, unified Spark integration, and expanded Arm and math library optimization.
- Enhances tile-based programming and developer tooling for high-performance workloads.
- **OCI implication**: Accelerates deep learning and HPC workloads on OCI Blackwell and GB200 instances.

### Fast Pass to Multi-GPU, Multi-Node Clusters for Scientists (DCS1027)

- Simplified orchestration of multi-GPU, multi-node clusters drastically cuts analytics and ETL time.
- New NVIDIA libraries streamline scaling from workstation to production.

### Next Generation U.S. Supercomputing Systems (DC51081)

- Los Alamos’ new Mission/Vision systems leverage NVIDIA’s Vera Rubin platform for advanced AI and scientific computing.
- Focus areas: national security, open science, hybrid AI-quantum workloads, and high-speed networking.
- **OCI implication**: Architectural parallels with OCI’s GPU superclusters highlight enterprise-to-government scalability.

## Oct 28, 2025 — Highlights

### Jensen Huang Keynote — Conference Highlight

- Met Jensen in person — see the LinkedIn post: [Recap with photos](https://www.linkedin.com/posts/activity-7389076413364068352-jicG?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAFgvLIBqVk5T49epjnTrQSu_gC1dAfLh48)
- Watch the keynote: [YouTube video](https://www.youtube.com/watch?v=lQHK61IDFH4)

> “OCI is at the center of the world’s largest AI supercomputers.” — Jensen Huang

### DOE AI Supercomputers

- Solstice → 100,000 NVIDIA Blackwell GPUs on OCI for Argonne National Lab
- Equinox → 10,000 Blackwell GPUs (launch 2026)
- Combined ≈ 2,200 exaflops for national security, science, and energy research
- Clay Magouyrk announcement: OCI provides secure, high-performance AI infrastructure for government and research

### Next-Gen GPU and Platform Expansion

- OCI is a lead partner for Grace-Blackwell NVL72 and Blackwell architecture rollouts
- Joint work on agentic AI, sovereign cloud, and NVIDIA AI Enterprise integration on OCI
- Focus on enterprise AI factories and scientific workflows

### Strategic Partnerships

- OCI central to national AI infrastructure and DOE initiatives
- Blueprint for rapid deployment of large-scale AI systems supporting science and enterprise

### Announcements Summary

| Item | Key Detail | OCI Role |
| --- | --- | --- |
| Solstice | 100k Blackwell GPUs; ~2,200 exaflops | DOE supercomputer on OCI |
| Equinox | 10k Blackwell GPUs (2026) | Scientific R&D on OCI |
| Agentic AI + Sovereign Cloud | Enterprise AI integration | Core cloud provider |
| NVL72 Rollouts | AI factories & research accelerators | Early deployment on OCI |

## Class Notes

1. Trustworthy AI for Government (DCS1313) — focused on secure and ethical AI in public missions.
   - Applied NVIDIA’s Trust Center principles and NIST’s AI Risk Framework.
   - DOE and federal case studies using NeMo for compliant LLMs.
   - Emphasis on sovereign AI and measurable mission impact.

2. GPUs and AI at the Edge (Oracle at Booth #216) — Oracle–NVIDIA collaboration for low-latency edge AI.
   - Oracle Distributed Cloud with NVIDIA Jetson/IGX for tactical inference.
   - Announced Solstice (100K Blackwell GPUs) & Equinox (10K GPUs).
   - Demos: cuOpt + AI Vector Search; 2.7× kernel gains; industrial use cases.

3. Optimize GPU Apps with CUDA (CWEDC1256) — interactive session with CUDA engineers.
   - Profiling via Nsight Systems/Compute; fix bottlenecks in memory and occupancy.
   - Kernel tuning, coalesced memory, shared tiling, multi-GPU with NCCL.
   - Practical checklist and resources for post-session optimization.