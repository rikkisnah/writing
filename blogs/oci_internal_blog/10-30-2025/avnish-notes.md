Avnish's Notes



* Google (insert pics)
    * Simulation is a major theme — Google is launching G4 VMs based on RTX Pro GPUs.
    * Manageability: Google showcases observability of health and firmware, with actions via UX and CLI.
        * Visualize nodes needing maintenance, firmware updates, or running slow and take action.
    * Inference gateway integrates with NVIDIA’s NeMo framework.
    * Inference gateway load balancing: KV cache is well distributed/balanced; throughput is balanced and latency better managed.
    * Inference quick start: customers provide workload inputs; Google recommends part specs and manifests to deploy to production; predicts KV cache utilization across offerings.
    * Gemini APIs generally available in Google GDC regions.
    * GDC Connected and GDC Air-Gapped: bringing end-to-end capabilities to those clouds.
    * Gemini Enterprise Search available on GDC with Gemini.
* NVIDIA Mission Control (insert pic)
    * Integrated checks with SLURM (pre and post runs).
    * Customers may need to evacuate racks to facilitate tray repairs (preference-dependent).
    * Prefer tray swaps within a rack when possible (depends on customer).
    * Use a spare rack to run long-running partner diagnostics while trays are replaced.
    * NVIDIA planning to add workload stress in partner diagnostics.
    * Claimed to scale to hundreds of thousands of GPUs.
    * Health checks between SLURM runs complete in ~2 minutes.
    * Philosophy: run quick checks to decide when to sideline servers for deeper analysis on a different rack, and replace trays proactively (over-provisioning).
    * Accepted tradeoff: “bone piles” of trays while collaborating with NVIDIA on bugs. 
    * Advantages from SLURM integration
        * Can return a tray to the customer during experimentation/debug; if it fails again, detect quickly via SLURM logs and move the workload to avoid the node.
            * Repeat failures/returns from customers are used to drive the next repair action.
            * Treat repeat returns as a signal to improve triage and repair rather than something to avoid.
        * Move trays to a spare rack for diagnostics and backfill with a healthy tray quickly. Instead of proving a tray is bad before bringing in a spare, bring in the spare aggressively and diagnose the faulty tray offline. Requires buffer capacity for diagnostics and may increase total spares because some swapped hosts may not be broken.
        * Combine quick health checks with repeat-return signals: if a quick check fails, do deeper diagnostics; if quick check passes but workload fails repeatedly, perform deep diagnosis.
        * Considerations for OCI
            * Change approach to repeat returns (use them as a useful signal rather than avoiding them).
            * Leverage offline racks for diagnostics instead of in-place diagnostics.
* Jensen
    * Discussed integrated design and simulation of data centers for GB300 and beyond to identify ideal layouts, plus a design/test center for the same.
    * No cables inside GB300.
    * Emphasis on simulation and Omniverse SKU for digital twins and designing factories/robots of the future.
    * Open models across multiple verticals tied to NVIDIA architecture — channeling developer momentum to NVIDIA hardware via open source.
    * 
        
    * 
        
* Jensen’s oracle slide 
* NVIDIA DGX talk
    * Nothing particularly notable here.
    * NVIDIA photonics
        * NVIDIA Spectrum-X via co-packaged optics reduces power by ~3.5×, enabling greater scale at the same power and limited cross–data center (~2 km).
        * Avoids deep buffers, reducing latency and jitter and improving performance.
        * (insert pics)
            
            
            






