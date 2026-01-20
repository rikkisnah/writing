# Your Repository Wasn't Built for AI. That's a Problem.

Most engineering teams treat AI coding assistants like autocomplete on steroids. Drop Claude or Copilot into a codebase, give it a task, watch it struggle. The assistant asks obvious questions. It ignores existing patterns. It hallucinates file paths.

The issue isn't the model. The issue is the repository.

Repositories were designed for humans. READMEs assume a reader who can wander through folders and pick up context. Code comments assume familiarity with the project's history. Architecture decisions live in someone's head, or in a Confluence page nobody updates.

AI agents can't wander. They need explicit instructions, stable context, and a clear next step. They need repositories that speak their language.

## What Context Engineering Actually Means

Prompt engineering gets the attention. Write better prompts, get better outputs. That's true, but incomplete.

Context engineering is the harder problem. It's about structuring the information around the prompt so the model doesn't start from scratch every session. It's about encoding architecture, constraints, history, and conventions into files the agent can read.

Think of it this way. A good prompt is a question. Good context is all the background that makes the question meaningful. Without context, even perfect prompts produce generic answers.

For product engineering, context engineering means treating your repository as an interface for AI agents. Not just code and docs. A control surface.

## The Standard Files

After reviewing emerging patterns across open source projects and internal cloud infrastructure workflows, a clear structure emerges. These files work across Claude, Copilot, Cline, and other assistants.

**AGENT.md** defines the rules. What coding patterns to follow. What files never to touch. What safety constraints apply. Think of it as an onboarding document written specifically for an AI collaborator. Include the tech stack, architectural patterns, error handling conventions, and anything you'd tell a new engineer on day one. Be explicit about boundaries. Production configs are off limits. Secrets never get hardcoded. Certain directories require human review before changes. Agents follow rules they're given. They don't infer rules from context.

**TASKS.md** captures momentum. Not the full backlog. The next concrete step. Keep it small, maybe three to seven items with clear acceptance criteria. Link to your ticketing system if needed, but keep the actionable work here in plain text. Agents work best with unambiguous next steps. Include what "done" looks like for each task. If the task needs tests, say so. If it touches specific files, name them. Vague tasks produce vague results.

**MEMORY.md** holds lessons learned. Architectural intent that isn't obvious from code. Bugs that took days to diagnose. Refactors that failed and why. Anti-patterns specific to this project. This file prevents the agent from repeating mistakes and provides continuity across sessions.

These three files form the core. Everything else supports them.

## A Practical Structure

Here's a layout that maps to typical product development workflows, from requirements through design through sprint execution:

```
repo/
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── AGENT.md
├── TASKS.md
├── MEMORY.md
├── design/
│   ├── hld.md
│   ├── lld.md
│   └── decisions/
├── prompts/
│   └── templates/
├── conventions/
│   ├── coding-style.md
│   └── metadata-schema.yaml
├── ops/
│   └── runbook.md
└── src/
```

The design folder holds high-level and low-level design documents. When architects produce POC writeups or formal design docs, they live here. Agents can reference them to understand system intent before modifying code.

The prompts folder stores reusable prompt templates. Common patterns for test generation, refactoring, documentation updates. Version these like code.

Conventions captures the coding standards and schemas that apply project-wide. Explicit rules beat implicit expectations.

Ops holds runbooks and operational procedures. Agents can draft incident responses or suggest runbook updates when behavior changes.

## Why Markdown

Everything uses Markdown. No proprietary formats. No tooling dependencies.

Markdown is readable by humans. Parsable by agents. Diffable in git. Portable across any AI tool that accepts text input.

This matters for durability. The specific assistants you use today will change. The repository structure shouldn't need to change with them.

## Mapping to Product Development

This structure aligns with how work actually flows in enterprise engineering.

Requirements and intake get captured in design documents. Architecture decisions reference the design folder and get logged in a decisions subdirectory or in MEMORY.md. Sprint tasks translate into TASKS.md entries with clear completion criteria.

During implementation, the agent reads AGENT.md for rules, MEMORY.md for context, and TASKS.md for what to do next. Developers use the conventions folder for consistency. After implementation, lessons learned go back into MEMORY.md.

The loop closes. Each cycle leaves the repository smarter for the next session.

## What MEMORY.md Actually Contains

This file deserves special attention. It's the most overlooked piece.

Bad memory files dump raw logs and verbose notes. Good memory files contain curated, high-signal entries. Each entry includes what happened, why it mattered, and what to do differently.

Examples of useful memory entries: a decision to avoid a specific library due to performance issues in production, a bug that only reproduces under certain state conditions, a refactoring approach that caused cascading test failures.

The format is simple. Date, trigger, decision, implication. Keep entries short. Agents will scan this before significant work.

## Scaling for Larger Teams

For complex projects, root-level files get cluttered. Move the AI-specific files into a dedicated directory like `.agent/` and leave a pointer file at the root.

Inside that directory, you can split AGENT.md into specialized rule files. Testing rules in one file. Documentation rules in another. Refactoring constraints in a third. Tell the agent which rule file applies for the current task.

Add a sessions subdirectory to log significant agent interactions. What prompt was used. What files changed. What issues surfaced. This creates provenance without overhead.

Multiple developers using different AI tools can reference the same `.agent/` folder. One team member on Claude Code, another on Cursor, a third on Copilot. They all read the same source of truth. Consistency comes from the repository, not the tooling.

## The Research Behind This

These patterns aren't invented. GitHub analyzed over 2,500 repositories with agent instruction files. The common factors in successful implementations: specific personas, executable commands provided early, clear boundaries around what agents should never do.

Academic research on repository-level prompt generation shows that structured context improves completion quality without requiring model fine-tuning. The model doesn't need to be smarter. It needs better inputs.

Industry surveys on prompt engineering emphasize the same point. Role definition, constraints, examples, and memory all contribute to reliable outputs. These elements belong in version-controlled files, not ephemeral chat sessions.

## What Changes

Adopting this structure requires treating prompts and context as first-class engineering artifacts. That means code review for AGENT.md changes. Versioning for prompt templates. Retrospectives that update MEMORY.md.

It also means resisting the temptation to rely on chat-based interactions alone. Chat is useful for exploration. But durable context belongs in the repository where it survives across sessions and across team members. What you learn in one conversation should persist for the next.

The agents will get smarter. The models will improve. But they'll always need context. The repositories that provide it will get better results than those that don't.

That's the tradeoff. Invest in structure now, or repeat the same prompts forever.

---

## References

1. GitHub Blog. "How to write a great agents.md: Lessons from over 2,500 repositories." GitHub AI and ML, 2024. https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/

2. Anthropic. "Effective context engineering for AI agents." Anthropic Engineering, 2024. https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents

3. Schulhoff, Sander et al. "The Prompt Report: A Systematic Survey of Prompting Techniques." arXiv, June 2024. https://arxiv.org/abs/2406.06608

4. Sahoo, Pranab et al. "A Systematic Survey of Prompt Engineering in Large Language Models: Techniques and Applications." arXiv, February 2024. https://arxiv.org/abs/2402.07927

5. AGENTS.md Specification. "A simple open format for guiding code agents." https://agents.md

6. Weng, Lilian. "Prompt Engineering." Lil'Log, March 2023. https://lilianweng.github.io/posts/2023-03-15-prompt-engineering

7. Prompt Engineering Guide. "LLM Agents." https://www.promptingguide.ai/research/llm-agents

8. Builder.io. "Improve your AI code output with AGENTS.md." Builder Blog, 2024. https://www.builder.io/blog/agents-md

9. AWS Machine Learning Blog. "Prompt engineering techniques and best practices: Learn by doing with Anthropic's Claude 3 on Amazon Bedrock." https://aws.amazon.com/blogs/machine-learning/prompt-engineering-techniques-and-best-practices-learn-by-doing-with-anthropics-claude-3-on-amazon-bedrock/

10. PromptHub. "Prompt Engineering Principles for 2024." https://www.prompthub.us/blog/prompt-engineering-principles-for-2024