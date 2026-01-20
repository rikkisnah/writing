# A Practical Repository Framework for AI-Assisted Engineering (Prompt + Content Engineering)

I don’t buy the idea that “prompt engineering” is something you do in a chat box and then move on from.
If the work matters, it needs a place to live.

Most teams are already using LLM tools in day-to-day product engineering. Copilot. Claude. Codex. Cline. Pick your flavor.
But the repo still looks like it expects one reader, and that reader has perfect memory.

That mismatch burns time in boring ways.
An agent edits the wrong layer because nobody wrote down the boundary. It reintroduces a fix you reverted last month because the reason never left someone’s head. It copies an old pattern because the “new way” is in a Slack thread.

I want a repo contract for this. Something an agent can read and a human can audit.
OCI teams already run through intake, design, change records, sprint tasks, tests. Put that trail in the repo instead of in people’s heads.

## Prompt engineering is not the full job

Prompt engineering is the visible part.
It’s the instruction you send to a model to get an output.

The part that keeps failing later is what I’ll call content engineering.
Context engineering is another name for it.

Content engineering is everything around the prompt that makes the prompt keep working when the repo changes, the team changes, and the tool changes. It’s the rules. The memory. The task queue. The design intent. The decision log. It’s boring on purpose.

You can get a good answer from a good prompt once.
Shipping software with agents means getting good answers over and over, with drift and churn and gaps.

## What breaks when the repo has no “AI contract”

You see the same failures show up.

- The agent guesses conventions, because conventions are not written down.
- Prompts become folklore. Nobody can tell which version produced a change.
- Teams can’t reproduce an output because the prompt, model settings, and input data were never captured.
- The agent repeats old mistakes because there is no curated memory layer.

The fix is not more chat history.
The fix is a repo that carries its own instructions and history in plain text.

## The minimal file set (the “AI-ready” contract)

Start small. Put the core contract in the repo root.
If you like uppercase file names, use them. If you prefer lowercase, do that. Consistency matters more than style.

Here’s a minimal set that works across tools:

- `README.md`: identity, quickstart, entrypoints.
- `CONTRIBUTING.md`: branching, tests, lint, PR rules, “do not touch” areas.
- `AGENTS.md` (or `AGENT.md`): persona, rules, boundaries, “done”.
- `TASKS.md`: short work-order queue with acceptance criteria. Link to Jira if you use Jira.
- `MEMORY.md`: curated, durable memory. Decisions, sharp edges, past failures, “don’t do that again”.
- `CHANGELOG.md`: time-ordered narrative. It becomes a memory spine when the repo moves fast.
- `DECISIONS/` (or `docs/06-decisions/`): ADRs using a lightweight template like MADR.
- `prompts/` or `PROMPTS.md`: versioned prompts and patterns, treated like code.

You can express it as a tree:

```text
repo/
  README.md
  CONTRIBUTING.md
  AGENTS.md
  TASKS.md
  MEMORY.md
  CHANGELOG.md
  DECISIONS/
    0001-adopt-diataxis.md
    0002-adopt-madr-template.md
  prompts/
    system/
    developer/
    user/
  design/
    intake.md
    poc.md
    hld.md
    lld.md
    ecar.md
  ops/
    runbook.md
    rca.md
  src/
  tests/
```

That structure is not magic.
It’s a place to put things that teams already do, with names that tools can find.

## Map the repo to how product work already flows

Most product teams follow a pattern even when they pretend they don’t.
The names differ, the flow is familiar.

Below is the same lifecycle, but pinned to files.

1. Requirements and endorsed work
   - Capture scope and constraints in `design/intake.md`.
   - Link it from `README.md` so people stop searching for it.
2. Architecture and POC
   - Keep early experiments in `design/poc.md` (and notebooks if you use them).
   - When you learn something, write it down once. Then stop re-learning it.
3. High-level design
   - `design/hld.md` holds the shape of the system and the boundaries.
4. Low-level design
   - `design/lld.md` holds the pieces, interfaces, and rough data flow.
5. Change approval records
   - `design/ecar.md` can be a formal record, or a plain change note. The point is traceability.
6. Sprint planning and tasks
   - `TASKS.md` mirrors the active work queue. It is readable without Jira access.
7. Development and tests
   - Code changes pair with tests. Agents do not get a free pass here.
8. Deployment and ops
   - Runbooks and RCAs live in `ops/`. Agents can draft, humans review.

OCI teams already write HLDs, LLDs, and change records.
The shift is putting them in the repo, in Markdown, with stable headings and clear sections so both humans and agents can navigate them.

## Scale it up without cluttering the root

On a larger repo, the “root clutter” argument is real.
You still want the contract, you want it discoverable, and you want it organized.

One pattern is a control-plane folder like `.agent/` or `.ai/`:

```text
root/
  .ai/
    AGENT.md
    TASKS.md
    MEMORY.md
    PROMPTS.md
    STYLE.md
    specs/
    rules/
      test-agent.md
      docs-agent.md
      refactor.md
    SESSIONS/
  README.md
  CONTRIBUTING.md
  src/
```

If you do this, add a bridge file at the root so tools don’t miss it. Some tools look for `AGENTS.md` or similar in the root.
A tiny root `AGENT.md` that points to `.ai/AGENT.md` works fine. Cursor also supports a `.cursorrules` pointer.

## Concrete templates that teams can live with

If you want this to work in a real repo, the files need to be short and updateable.
Not a manifesto.

### `AGENTS.md` (or `AGENT.md`)

Keep it blunt. Put the sharp edges in the open.

```markdown
# Agent Rules

Read first: README.md, CONTRIBUTING.md, MEMORY.md

Do:
- Follow existing architecture boundaries.
- Add or update tests with code changes.
- Update TASKS.md as work completes.

Do not:
- Add dependencies without calling it out in TASKS.md.
- Change deployment config without an approved task.
- Touch secrets or credentials files.
```

### `TASKS.md`

Keep it short. Keep it current.

```markdown
# Now
- [JIRA-123] Add rate-limit handling to client retry logic
  - Done when: tests cover backoff and retry cap, runbook updated

# Upcoming
- [JIRA-141] Split service into control plane and data plane packages

# Done (recent)
- [JIRA-118] Add request id propagation across services
```

### `MEMORY.md`

This is not a dumping ground for logs.
It’s where you write down the one-line lesson that saves you later.

```markdown
Before refactors
- Check DECISIONS/ for constraints on module boundaries

2026-01-18
- Trigger: perf regression after retry policy change
- Decision: cap retries and add jittered backoff
- Implication: do not increase retry count without load test evidence
```

### Prompts as versioned artifacts (PromptOps)

If prompts matter, treat them like code: versions, owners, tests, approvals.
At minimum, capture provenance and model compatibility.

```yaml
document_type: prompt
topic: implement-story-with-tdd
version: 1.2.0
owners: team-name
created_date: 2026-01-18
updated_date: 2026-01-18
model_compatibility: [preferred-model, fallback-model]
```

The OCI templates in this repo go further with metadata schemas, Diátaxis-style doc splitting (tutorial, how-to, reference, explanation), and ADR immutability rules. It’s not “docs work”. It’s how you keep agent context from rotting.

## Notes and references

- Builder on AGENTS.md: https://www.builder.io/blog/agents-md
- AGENTS.md ecosystem: https://agents.md
- GitHub on patterns from 2,500+ `agents.md` files: https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/
- Anthropic on context engineering: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- Prompt surveys: https://arxiv.org/abs/2406.06608 and https://arxiv.org/abs/2402.07927

If you don’t write it down, the agent guesses. You clean it up.
