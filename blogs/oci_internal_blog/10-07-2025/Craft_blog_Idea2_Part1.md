# From Gundu to Guru: Understanding LLMs & AI Tools on OCI
## Part 1: Why LLMs Matter for AI2 Compute

**Series Introduction**

---

## The Infrastructure Question

You're debugging NVLink bandwidth on a BM.GPU.H100.8 instance. Network throughput looks good, GPUs are healthy, but the customer's training job is slower than expected. You check the logs and see terms like "token throughput," "context length," and "batch size." What do these actually mean? And more importantly—how do they translate to the infrastructure you're responsible for?

If you've had this moment of disconnect, you're not alone. As AI2 Compute engineers, we build and operate the infrastructure that powers LLMs—but many of us haven't had the time to connect what we provision with what our customers actually run on it.

This series bridges that gap.

---

## Why This Matters Now

OCI is betting big on AI infrastructure. We're deploying GPU clusters at unprecedented scale, optimizing NVSwitch topologies, and tuning RDMA networks for distributed training workloads. But here's the reality: **understanding LLMs isn't optional anymore for infra engineers—it's foundational.**

Here's why:

**1. Customer conversations require it**
When a customer asks, "Why is my A100 cluster underperforming for training Llama 3?" you need to know whether it's an infra issue (PCIe bottleneck, NVLink degradation) or a workload issue (poor tensor parallelism, inefficient batch sizes). That requires understanding how LLM training actually works.

**2. Capacity planning depends on it**
Provisioning GPU resources without understanding training vs. inference requirements is like ordering servers without knowing whether the workload is CPU-bound or memory-bound. LLM workloads have distinct characteristics—massive memory for training, high throughput for inference—and we need to speak that language.

**3. Our roadmap is shaped by it**
The features we prioritize—whether it's improving GPU-to-GPU interconnect, optimizing for token streaming latency, or supporting multi-node inference—come directly from understanding how LLMs consume infrastructure. If we don't understand the "why," we can't prioritize the "what."

**4. AI tooling is already changing how we work**
You've probably used ChatGPT, Copilot, Claude, or Perplexity this week. These tools run on infrastructure just like ours. Understanding how they work helps us use them better—and build better platforms for customers doing the same.

---

## What This Series Covers

Over six posts, we'll go from fundamentals to practical application:

1. **Part 1 (This Post): Why LLMs Matter for AI2 Compute**
   Establish the baseline and show relevance to infrastructure work.

2. **Part 2: Tokenization, Embeddings & Vectorization**
   Explain how text becomes numbers and why GPUs accelerate this process.

3. **Part 3: LLM Training Fundamentals**
   Demystify training pipelines, distributed compute, and where OCI GPU clusters fit.

4. **Part 4: Inference & Serving on OCI**
   Show how trained models run at scale—batching, routing, latency optimization.

5. **Part 5: AI Tooling on OCI**
   Walk through Perplexity, Claude, Gemini, Grok, Copilot, ChatGPT—what they do and how to use them effectively.

6. **Part 6: Building Efficient AI Workflows**
   Synthesize everything into actionable recipes for SDE productivity.

Each post is designed for a 3–4 minute read with diagrams, code snippets, and internal OCI examples.

---

## Who This Series Is For

This series is written for **AI2 Compute SDEs**—the engineers building, operating, and supporting GPU infrastructure on OCI. Whether you're:
- Debugging GPU health on production clusters
- Designing fault domains for multi-node training
- Responding to customer escalations about inference latency
- Evaluating new hardware for AI workloads

...this series will give you the context to connect your infrastructure work to the AI workloads running on it.

**Assumed baseline:** You know Linux, networking, and GPU basics (like the difference between A100 and H100). You don't need a PhD in machine learning—just curiosity and a willingness to connect dots.

---

## The Infra-First Lens

This isn't a machine learning theory series. We won't dive into backpropagation math or debate transformer architectures. Instead, we'll approach LLMs from an **infrastructure-first perspective**:

- How does tokenization affect memory bandwidth?
- Why do training workloads need NVLink but some inference workloads don't?
- What does "tokens per second" mean for network throughput?
- How do batching strategies impact GPU utilization?

We'll tie every concept back to the infra you touch daily: RDMA networks, GPU topologies, PCIe lanes, fault domains, and OCI's AI stack.

---

## What's Next

In **Part 2**, we'll start with the foundation: **Tokenization, Embeddings & Vectorization**. You'll learn how text becomes tensors, why vector operations matter, and how this maps to GPU memory and compute patterns.

By the end of this series, you'll be able to:
- Speak confidently about LLM workloads in customer conversations
- Optimize infrastructure with a deeper understanding of workload characteristics
- Use AI tools more effectively in your own workflows
- Contribute to OCI's AI roadmap with informed perspectives

---

## Let's Go

From "gundu" (beginner) to "guru" (expert), this journey is about building shared understanding across our team. LLMs are reshaping cloud computing, and AI2 Compute is at the center of it. Let's make sure we understand what we're building.

**See you in Part 2.**

---

**Series Navigation:**
← Part 1 (You are here) | [Part 2: Tokenization, Embeddings & Vectorization →]

---

*This is Part 1 of a 6-part series written for Oracle AI2 Compute engineers.*
*3–4 minute read | ~820 words*
