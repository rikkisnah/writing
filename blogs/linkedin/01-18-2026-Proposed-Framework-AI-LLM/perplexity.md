A practical, agent-agnostic repo should treat prompts, agent instructions, and long-term context as **first-class Markdown artifacts** alongside code. Done well, any LLM tool (Claude, Copilot/Codex, Cline, etc.) can reliably “boot” into the project, understand architecture and history, and pick up the next task without special tooling. [builder](https://www.builder.io/blog/agents-md)

Below is a structure you can adapt directly into your blog, tailored to OCI AI² Compute and your intake → design → Jira → TDD flow.

***

## Core AI-aware files (repo root)

These repo-root files define identity, process, and agent behavior in a way that works across tools.

- `README.md` – **Identity for humans (and a starting point for agents)**  
  - Purpose: Project overview, how to run, environments, primary entrypoints.  
  - Why: LLMs often treat `README.md` as the first context, and repo-level prompt generators use it as part of their context window for better prompts and completions. [openreview](https://openreview.net/forum?id=MtGmCCPJD-)

- `CONTRIBUTING.md` – **Contribution contract**  
  - Purpose: Coding standards, branching model, review rules, commit message conventions, test requirements.  
  - Why: Helps agents follow project-specific workflows (e.g., always add tests, update changelog) when you reference this file in agent instructions. [discuss.huggingface](https://discuss.huggingface.co/t/best-practices-for-coding-llm-prompts/164348)

- `CHANGELOG.md` – **Temporal narrative**  
  - Purpose: Human-readable log of changes, tagged versions, and notable fixes.  
  - Why: Acts as a chronological “memory spine,” helping agents understand recent shifts and avoid resurrecting old patterns. [heyitworks](https://heyitworks.tech/blog/modular-agent-tasks/)

- `AGENTS.md` – **Primary agent persona & rules**  
  - Purpose: A repo-level instruction file that describes architecture, stack, constraints, and strict do/don’t rules for any coding agent. [github](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
  - Recommended sections (blog can include a sample):
    - Project summary and stack (languages, frameworks, infra).
    - Architectural patterns (e.g., hexagonal, layered, service boundaries).
    - File layout and where specific responsibilities live.
    - Coding standards that matter most (error handling, logging, dependency boundaries).
    - Safety/guardrails (never touch certain files, how to handle secrets).
    - “When in doubt, ask” guidance: how to propose changes via comments or TODOs.  
  - Rationale: AGENTS.md is emerging as a de facto convention, supported by Copilot and easy to consume as unstructured context in other tools. [agents](https://agents.md)

- `TASKS.md` – **Work-order queue for agents**  
  - Purpose: Small, high-signal “next steps” list that agents can safely execute, mapped to Jira or sprint items.  
  - Suggested structure:
    - “Now” tasks: 3–7 concise items with acceptance criteria and related Jira IDs.
    - “Upcoming” tasks: Backlog items that are not yet active.
    - “Done (recent)” tasks: Short list with links to PRs/commits.  
  - Rationale: “Work-order prompts” work best when they’re explicit, versioned, and Markdown-native. [reddit](https://www.reddit.com/r/AugmentCodeAI/comments/1qeawib/how_do_you_manage_workorder_prompts_for_ai_coding/)

- `MEMORY.md` (or `.agent/MEMORY.md`) – **Curated long-term memory**  
  - Purpose: Summarized project history and lessons that agents should revisit before significant refactors.  
  - Recommended sections:
    - Architecture intent: “Why the system is shaped this way”.
    - Known sharp edges and historical bugs.
    - Anti-patterns to avoid (e.g., “do not add new business logic in controllers”).
    - “We tried X and reverted because…” entries.  
  - Rationale: Community practice for “memory via Markdown” uses dedicated files and/or an `.agent` directory to provide durable guidance beyond transient chat history. [github](https://github.com/agentsmd/agents.md/issues/71)

***

## `.agent/` directory as an agent control plane

To keep the repo agent-agnostic while still leveraging emerging conventions, use a dedicated `.agent/` directory (or `.agents/` if you want to align with existing proposals) as the “control plane” for AI/LLM usage. [builder](https://www.builder.io/blog/agents-md)

Suggested layout (which your blog can show as a tree):

```bash
.agent/
├── README.md          # How this repo uses agents
├── AGENT.md           # Canonical agent persona (can reference root AGENTS.md)
├── TASKS.md           # Task queue in finer detail (per-sprint / per-epic)
├── MEMORY.md          # Curated, high-signal memory
├── PROMPTS.md         # Canonical prompt snippets & patterns
├── STYLE.md           # Code style, patterns, and anti-patterns
└── SESSIONS/
    ├── 2026-01-18-ec2-refactor.md
    └── ...
```

Key ideas:

- `.agent/README.md`  
  - Explains how agents should interpret this directory, precedence between root `AGENTS.md` and `.agent/AGENT.md`, and how to map `TASKS.md` entries to Jira and TDD artifacts. [lord](https://lord.technology/2024/09/10/repository-to-prompt-tools.html)

- `.agent/PROMPTS.md`  
  - Holds reusable prompt templates for:
    - “Implement a story with TDD.”
    - “Refactor with safety constraints.”
    - “Write or update design docs from code.”  
  - Aligns with research on repository-level prompt generation, which uses repository structure and curated prompt proposals to improve code completion quality. [openreview](https://openreview.net/forum?id=MtGmCCPJD-)

- `.agent/SESSIONS/`  
  - Optional log of important agent sessions: “what prompt was used”, “what files changed”, “what issues discovered”.  
  - This creates a lightweight provenance trail for work-order prompts. [reddit](https://www.reddit.com/r/AugmentCodeAI/comments/1qeawib/how_do_you_manage_workorder_prompts_for_ai_coding/)

This directory is generic enough for Claude, Copilot/Codex, Cline, and internal OCI agents: each can be configured to read `.agent/` on startup.

***

## Mapping to OCI intake → design → Jira → TDD

In the blog, show how the repository structure mirrors your endorsed workflow so both humans and agents navigate the same artifacts.

- Project intake / endorsed work  
  - Capture problem definition and scope in `docs/intake/PROJECT-ID.md`.  
  - Link this from `README.md` and reference it in `AGENT.md` so agents know the business context. [discuss.huggingface](https://discuss.huggingface.co/t/best-practices-for-coding-llm-prompts/164348)

- Architect / Tech Lead POC or write-up  
  - Use `design/hld.md` and `design/lld.md` derived from your OCI `hld-template.md` and `lld-template.md`, implemented directly in the repo.  
  - Put a short “For agents” section in each design doc summarizing:
    - Key invariants.
    - Where to add new code for related features.
    - Constraints around performance or cost. [wandb](https://wandb.ai/wandb_fc/genai-research/reports/Introduction-to-Agents-md--VmlldzoxNDEwNDI2Ng)

- Design Doc / ECAR  
  - Store under `design/ecar.md`, keeping the full template but adding a closing “Agent notes” subsection.  
  - This mirrors your internal ECAR flow but keeps everything Markdown-native and accessible to LLMs without special tooling.

- Sprint Jira tasks  
  - Maintain a bi-directional mapping:
    - Jira → `TASKS.md`: each active ticket appears as a bullet with link and acceptance criteria.
    - `TASKS.md` → Jira: each bullet has the ticket ID embedded.  
  - This lets agents act on well-formed “work-order prompts” stored in versioned Markdown rather than ephemeral chat messages. [reddit](https://www.reddit.com/r/AugmentCodeAI/comments/1qeawib/how_do_you_manage_workorder_prompts_for_ai_coding/)

- TDD / implementation  
  - Encourage a pattern where every substantive agent change:
    - Adds/updates tests first.
    - Updates `CHANGELOG.md` and, if relevant, `MEMORY.md` with a brief “lesson learned”.  
  - You can advocate a convention for “agent-authored changes” (e.g., a commit marker), then periodically summarize those into `MEMORY.md`. [arxiv](https://arxiv.org/html/2503.12687v1)

***

## Memory, style, and lessons learned

To satisfy your requirement for persistent “memory” without tying to any single vendor’s implementation, use layered Markdown artifacts.

- `MEMORY.md` (global memory)  
  - High-signal lessons only; avoid dumping raw logs.  
  - Each entry includes:
    - Date.
    - Trigger (bug, incident, refactor, performance issue).
    - Decision and rationale.
    - Implication for future code (what agents must do differently). [reddit](https://www.reddit.com/r/GithubCopilot/comments/1oofbt5/another_way_the_agents_can_have_memory_md_files/)

- `docs/area-name/MEMORY.md` (local memory)  
  - Co-located with code (e.g., `services/user/MEMORY.md`) so that agents reading that directory see localized context and rules, in line with recommendations to nest agent guidance files. [github](https://github.com/agentsmd/agents.md/issues/71)

- `STYLE.md` or `conventions/STYLE.md`  
  - Consolidates coding conventions, naming rules, error-handling strategies, logging schemas, and “approved” patterns.  
  - AGENT files should point here so agents treat it as the single source of truth for style. [github](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)

- `ops/runbook.md` and `ops/rca/`  
  - Your internal runbook and RCA templates can sit here, and agents can be instructed to:
    - Draft initial RCAs from logs and code changes.
    - Suggest runbook updates whenever operational behavior changes. [arxiv](https://arxiv.org/html/2503.12687v1)

***

## Research: existing patterns and emerging standards

In the blog, call out that this proposal harmonizes several industry trends without being tool-specific.

- AGENTS.md ecosystem  
  - AGENTS.md has become a simple open format for guiding code agents, sitting alongside README and used by Copilot and other tools. [agents](https://agents.md)
  - Proposals exist to standardize a dedicated `.agent` directory for comprehensive project configuration, including memory and behavior, which you can adopt and extend. [github](https://github.com/agentsmd/agents.md/issues/71)

- Task / work-order repositories  
  - Patterns for “task repositories” emphasize separate Markdown files for project outline, technical details, environment constraints, credentials handling, MCP configuration, and success criteria, all under a dedicated `tasks/` tree. [superlinked](https://superlinked.com/vectorhub/articles/research-agent)
  - Discussions around “work-order prompts” highlight provenance, lineage, and Markdown-native authoring—supported by the `.agent/TASKS.md` + `SESSIONS/` approach. [reddit](https://www.reddit.com/r/AugmentCodeAI/comments/1qeawib/how_do_you_manage_workorder_prompts_for_ai_coding/)

- Repo-level prompt generation research  
  - Research on repository-level prompt generation demonstrates that using repository structure and cross-file context improves LLM performance without needing model weight access, especially for code completion. [openreview](https://openreview.net/forum?id=MtGmCCPJD-)
  - Your standardized files give such tools clean, high-signal inputs, enhancing both external assistants and any future OCI-native agent tooling.

- Emerging “repo-to-prompt” tools  
  - Tools that transform repositories into prompts increasingly rely on predictable documentation layouts and customizable templates, which align directly with your Markdown-first, convention-driven design. [lord](https://lord.technology/2024/09/10/repository-to-prompt-tools.html)

***

## Example table of key files

You can reuse and extend this table in the blog to summarize the “standard, repeatable” approach:

| File / Path             | Purpose          | Audience        | Key Question Answered |
|-------------------------|------------------|-----------------|----------------------------------------------------------------|
| `README.md`             | Identity         | Humans & agents | What is this project and how do I run or integrate it? |
| `CONTRIBUTING.md`       | Process          | Devs & agents   | How do I change code correctly and get it merged? |
| `AGENTS.md`             | Persona          | AI agents       | How should an agent behave in this repo and what are the rules? |
| `.agent/TASKS.md`       | Momentum         | AI agents       | Which concrete tasks should be executed next, and what is “done”? |
| `.agent/MEMORY.md`      | Context          | AI agents       | What have we learned from past bugs, incidents, and refactors? |
| `design/hld.md`         | Architecture     | Humans & agents | What is the high-level system design and its invariants? |
| `design/lld.md`         | Detailed design  | Humans & agents | How are modules, APIs, and data structures organized? |
| `ops/runbook.md`        | Operations       | SRE & agents    | How do we operate, debug, and recover this system? |
| `conventions/STYLE.md`  | Code style       | Devs & agents   | What patterns, naming, and practices are mandatory here? |
| `CHANGELOG.md`          | History          | Humans & agents | What changed over time and when did key shifts happen? |

This gives you a concrete, vendor-neutral blueprint you can position as “AI-aware repository conventions for OCI AI² Compute,” grounded in emerging AGENTS.md conventions, repo-to-prompt research, and practical agent task patterns. [heyitworks](https://heyitworks.tech/blog/modular-agent-tasks/)
