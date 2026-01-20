# Your Repository Was Not Built for AI Agents

Most teams are still treating AI coding assistants like search engines with opinions. Drop in a prompt, get some code, copy-paste it, hope it works. This is the wrong model.

The problem is not the AI. The problem is your repository. It was built for humans. AI agents cannot read between the lines. They cannot pick up on tribal knowledge. They cannot infer that "we never do it that way" from a Slack thread three months ago.

So they hallucinate. They repeat mistakes. They ignore conventions. And developers blame the tools.

## The Missing Layer

Here is what happens in most repositories. A developer asks Claude or Copilot to add a feature. The agent reads some files, makes reasonable guesses, produces code. The code compiles. But it violates three internal conventions, uses a deprecated pattern, and duplicates logic that already exists somewhere else.

The agent did not know. It could not know. There was no document that said "this is how we do things here."

README files are not enough. They explain what the project does. They do not explain what rules the code follows. Contributing guides cover PR process. They do not cover architectural intent.

The gap is structural. Repositories lack a layer that speaks directly to AI agents.

## A Proposed Framework

What follows is not a standard. It is a proposal. The idea is simple: treat AI agent instructions as first-class artifacts in your repository.

Four files. That is the core.

**AGENT.md** defines the agent persona and operating rules. What coding standards must be followed. What patterns are forbidden. What files should never be touched. Think of it as a behavior contract between the repository and any AI that operates within it.

**TASKS.md** provides a queue of work. Not a backlog of features. A short list of concrete next steps with acceptance criteria. Agents work best when the next action is unambiguous.

**MEMORY.md** captures lessons learned. Past decisions. Known bugs. Anti-patterns to avoid. The "why" behind design choices. This is the durable context that prevents agents from making the same mistakes twice.

**PROMPTS.md** collects reusable prompt templates. Standard patterns for common operations. This supports consistency across sessions and developers.

These sit at the root alongside README and CONTRIBUTING.

## Structure in Practice

Here is what the repository looks like:

```
repo/
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── AGENT.md
├── TASKS.md
├── MEMORY.md
├── PROMPTS.md
├── design/
│   ├── hld.md
│   ├── lld.md
│   └── ecar.md
├── conventions/
│   ├── coding-style.md
│   └── metadata-schema.yaml
├── ops/
│   └── runbook.md
└── src/
```

The `design/` folder holds architecture documents. High-level design. Low-level design. Change records. These connect to your existing workflow. Intake to POC to design doc to sprint tasks to implementation.

The `conventions/` folder captures coding standards, naming rules, approved patterns. AGENT.md points here so agents treat it as the single source of truth.

For larger repositories, consider a `.agent/` directory:

```
.agent/
├── AGENT.md
├── TASKS.md
├── MEMORY.md
├── PROMPTS.md
├── rules/
│   ├── test-agent.md
│   └── docs-agent.md
└── sessions/
    └── 2026-01-18-feature-x.md
```

The `rules/` folder allows sub-agent specialization. Different rules for writing tests versus writing documentation. The `sessions/` folder logs what prompts were used, what files changed, what issues were discovered. A lightweight provenance trail.

## What Goes in Each File

**AGENT.md** should include:

- Project summary and tech stack
- Architectural patterns in use
- File layout and where responsibilities live
- Coding standards that matter most
- Safety boundaries (what to never touch)
- Error handling and logging expectations

Keep it concrete. No aspirational language. Just rules.

**TASKS.md** should include:

- "Now" tasks: 3-7 items with acceptance criteria
- "Upcoming" tasks: backlog for visibility
- "Done" tasks: recent completions with PR links

Update it after each work session. Agents read it. So should humans.

**MEMORY.md** should include:

- Architecture intent (why the system is shaped this way)
- Known sharp edges and historical bugs
- Past decisions that were reversed and why
- Anti-patterns to avoid

Each entry gets a date, a trigger (bug, incident, refactor), and the implication for future code.

## Why This Matters

GitHub analyzed over 2,500 AGENTS.md files across repositories. The patterns that work: specific personas, executable commands early in the document, clear boundaries. The patterns that fail: vague instructions, missing context, no constraints.

Research on repository-level prompt generation shows that structured documentation improves LLM performance without needing model weight access. The files become input context. Better input, better output.

Anthropic's guidance on context engineering for agents emphasizes that prompt engineering has evolved. Managing memory, tools, and history for long-horizon agents requires explicit documentation. You cannot stuff everything into a system prompt. The context must live in the repository.

McKinsey found developers using AI tools complete tasks 20-50% faster. But that is the average. The variance is enormous. Teams with clear conventions and documentation see the high end. Teams without them see frustration.

## Connecting to the Development Lifecycle

This structure maps to the standard product development flow.

Intake and endorsed work gets captured in README and initial TASKS entries.

POC and tech lead writeup goes into design/hld.md.

Design review and approval populates design/lld.md and design/ecar.md.

Sprint tasks translate into TASKS.md items with ticket references.

TDD and implementation uses AGENT.md for rules, MEMORY.md for context, TASKS.md for direction.

The repository becomes the single source of truth for both humans and agents. No more context switching between Jira, Confluence, and Slack to find out how things work.

## The Uncomfortable Part

None of this is automatic. Someone has to write these files. Someone has to maintain them. That is work.

MEMORY.md requires discipline. After each bug fix, after each architectural decision, someone needs to write it down. Most teams will not do this consistently.

TASKS.md goes stale. People forget to update it. The queue drifts out of sync with reality.

AGENT.md becomes outdated when the codebase evolves and no one updates the rules.

This is the same problem as documentation. Everyone agrees it is valuable. Few teams maintain it.

The question is whether the payoff justifies the cost. For teams using AI agents heavily, probably yes. For teams using them occasionally, probably not.

## Where This Goes

The AGENTS.md convention is emerging as a de facto standard. GitHub Copilot reads it. Claude Code reads it. Cursor reads it. The file becomes a shared interface between your repository and whatever AI tool your developers use.

The memory and task layers are less established. They require more discipline. They provide more benefit.

What happens next depends on whether teams treat AI agents as tools to be fed prompts or as collaborators that need context. The repository structure reflects that choice.

---

## References

1. GitHub Blog. "How to write a great agents.md: Lessons from over 2,500 repositories." [github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)

2. Anthropic. "Effective context engineering for AI agents." [anthropic.com/engineering/effective-context-engineering-for-ai-agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

3. AGENTS.md. "A simple open format for guiding code agents." [agents.md](https://agents.md)

4. Builder.io. "Improve your AI code output with AGENTS.md." [builder.io/blog/agents-md](https://www.builder.io/blog/agents-md)

5. Prompt Engineering Guide. "LLM Agents." [promptingguide.ai/research/llm-agents](https://www.promptingguide.ai/research/llm-agents)

6. Schulhoff, Sander et al. "The Prompt Report: A Systematic Survey of Prompting Techniques." arXiv, June 2024. [arxiv.org/abs/2406.06608](https://arxiv.org/abs/2406.06608)

7. Sahoo, Pranab et al. "A Systematic Survey of Prompt Engineering in Large Language Models: Techniques and Applications." arXiv, February 2024. [arxiv.org/abs/2402.07927](https://arxiv.org/abs/2402.07927)

8. McKinsey & Company. "The economic potential of generative AI: The next productivity frontier." 2023.

9. OpenReview. "Repository-Level Prompt Generation for Large Language Models of Code." [openreview.net/forum?id=MtGmCCPJD-](https://openreview.net/forum?id=MtGmCCPJD-)

10. HumanLayer. "Writing a good CLAUDE.md." [humanlayer.dev/blog/writing-a-good-claude-md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
