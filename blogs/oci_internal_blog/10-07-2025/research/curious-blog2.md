# 🧠 Blog Series Outline: “From Gundu to Guru — Understanding LLMs & AI Tools on OCI”

**Target Audience:** AI2 Compute SDEs  
**Format:** 6-part blog series, 3–4 min read each  
**Objective:** Explain how LLMs and AI tooling work on OCI, bridging fundamentals with internal application for SDEs. Designed for internal and eventual external publication.

---

## 📌 Series Overview

| # | Topic | Goal | Key Assets |
|---|-------|------|------------|
| 1 | Why LLMs Matter for AI2 Compute | Establish shared baseline. Explain why understanding LLMs is relevant to infra engineers. | Leadership emails, org goals, OCI AI vision deck |
| 2 | Tokenization, Embeddings & Vectorization | Explain how input is converted for training/inference. Tie to OCI infra. | Diagrams, code snippets, tokenizer examples |
| 3 | LLM Training Fundamentals | Demystify model training loops, datasets, and compute demand. Map to OCI GPU infra. | Training pipeline diagram, Confluence notes on GPU cluster setup |
| 4 | Inference & Serving on OCI | Show how trained models run at scale. Explain infra stacks, latency, throughput. | Internal architecture diagrams, perf dashboards |
| 5 | AI Tooling on OCI | Walk through tools (Perplexity, Claude, Gemini, Grok, Copilot, ChatGPT). Show workflow integration for SDE productivity. | Internal enablement emails, screenshots, usage guides |
| 6 | Building Efficient AI Workflows | Present practical recipes for using tools and infra effectively. End with call to action. | Sample workflows, Slack threads, diagrams |

---

## 📝 Section Goals

### 1. **Why LLMs Matter for AI2 Compute**
- Contextualize LLMs in the broader OCI AI strategy.  
- Show relevance to infra work: GPU clusters, networking, serving stacks.  
- Motivate the series.

### 2. **Tokenization, Embeddings & Vectorization**
- Explain tokens and vocabularies simply.  
- Show embedding math at a high level.  
- Tie vectorization to GPU acceleration and OCI infra.

### 3. **LLM Training Fundamentals**
- Outline typical training pipeline.  
- Explain compute scaling, distributed training, data parallelism.  
- Highlight where AI2 Compute infra fits (e.g., BM.GPU.H100.8, NVSwitch domains).

### 4. **Inference & Serving on OCI**
- Describe inference stack (token streaming, batching, routing).  
- Cover scaling, fault domains, and latency tradeoffs.  
- Use internal infra diagrams to make it concrete.

### 5. **AI Tooling on OCI**
- List key tools used internally and externally.  
- Map each tool to its role in the workflow (research, drafting, verifying, polishing).  
- Provide practical tips and internal context.

### 6. **Building Efficient AI Workflows**
- Synthesize previous sections into actionable recipes.  
- Show “good vs bad” workflows.  
- End with a clear “next steps” for SDEs (experimentation, sharing patterns, contributions).

---

## 📂 Required Assets

- 📧 Leadership/Org emails on OCI AI direction (context for Part 1)  
- 📊 Confluence pages on GPU infra, training clusters, NVSwitch design (Parts 3–4)  
- 🖼 Diagrams: tokenization flow, training loop, serving stack, workflow recipes  
- 📚 Internal tool usage guides (Grok, Gemini, Claude, Copilot, ChatGPT)  
- 🧵 Slack threads showing real workflows (Part 6 examples)

---

## 🪜 Suggested Workflow for Drafting

1. **Research (Perplexity)** — Collect Confluence, internal emails, diagrams.  
2. **Draft (Claude)** — Generate initial Markdown per section.  
3. **Structure & Synthesis (ChatGPT)** — Tighten structure, flow, and clarity.  
4. **Fact Verification (Gemini)** — Validate OCI-specific details.  
5. **Tone Polish (Grok)** — Adjust language for publication.  
6. **Publish (Copilot)** — Format for SharePoint and LinkedIn.

---
