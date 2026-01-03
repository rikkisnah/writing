Effective LLM instructions come from clear structure plus precise language, not clever phrasing.[1][2][3]

## Core principles (the “words” themselves)

- Prioritize clarity over brevity: use explicit, concrete language, define roles (“You are a technical writer for X”), and avoid ambiguous verbs like “handle” or “deal with”.[2][1]
- Be specific and bounded: state inputs, outputs, constraints, and success criteria (“Output: a Markdown how‑to guide with 3–5 steps and code fences, no extra commentary”).[4][5]
- Provide context, then task, then format: a strong instruction usually includes background, the exact job, and the required response shape in that order.[5][4]

## How to structure your documentation

- Use Diátaxis as a content frame:  
  - Tutorials: “Getting started prompting this agent”  
  - How‑tos: “How to add a new tool / constraint to the instructions”  
  - Reference: the canonical prompt patterns, allowed sections, and keywords  
  - Explanations: why instructions are written this way (safety, tone, scope).[6][3][7]
- Keep these as separate Markdown docs so humans and agents can locate the right “kind” of guidance instead of one bloated prompt file.[3][6]

## Project-level standards (AGENTS.md, TOON, etc.)

- Put stable, reusable instructions into an AGENTS.md (or TOON AGENTS.md) file: role, allowed operations, tools, file layout, coding style, and “never do X” boundaries.[8][9][10][11]
- Treat one-off chat prompts as thin wrappers that reference this shared spec (“Follow AGENTS.md for project context; this task is…”), which reduces token waste and keeps behavior consistent.[9][10][8]

## Recommended patterns for writing instructions

- Use consistent sections in your instruction docs, for example: Purpose, Inputs, Outputs, Style, Constraints, Tools/Resources, Examples, Failure modes.[12][13][1]
- Prefer imperative, testable statements: “Always…”, “Never…”, “If X, then Y…”, and avoid hedging (“try to”, “generally”) so the model has clear priorities when instructions conflict.[14][1]

## Process for evolving your instruction docs

- Start small: document one “golden” pattern per task type (e.g., “markdown spec for how‑to guides”) and refine it using real interactions and error cases.[15][6]
- Iterate like code: version your instruction files, review them, and add short rationales when changing wording so future contributors understand why certain phrases or constraints exist.[16][15]

[1](https://help.openai.com/en/articles/10032626-prompt-engineering-best-practices-for-chatgpt)
[2](https://haystack.deepset.ai/blog/beginners-guide-to-llm-prompting)
[3](https://diataxis.fr)
[4](https://www.multimodal.dev/post/llm-prompting)
[5](https://mirascope.com/blog/llm-prompt)
[6](https://diataxis.fr/start-here/)
[7](https://diataxis.fr/reference/)
[8](https://docs.factory.ai/cli/configuration/agents-md)
[9](https://www.builder.io/c/docs/agents-md)
[10](https://electric-sql.com/docs/agents)
[11](https://agentsmd.net)
[12](https://mirascope.com/blog/prompt-engineering-best-practices)
[13](https://developers.liveperson.com/trustworthy-generative-ai-prompt-library-best-practices.html)
[14](https://mitsloanedtech.mit.edu/ai/basics/effective-prompts/)
[15](https://github.com/evildmp/diataxis-documentation-framework/blob/main/how-to-use-diataxis.rst)
[16](https://emmanuelbernard.com/blog/2024/12/19/diataxis/)
[17](https://www.reddit.com/r/PromptEngineering/comments/1hv1ni9/prompt_engineering_of_llm_prompt_engineering/)
[18](https://www.superannotate.com/blog/llm-prompting-tricks)
[19](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
[20](https://community.openai.com/t/prompt-engineering-showcase-your-best-practical-llm-prompting-hacks/1267113)
