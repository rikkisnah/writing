Best practice is to write prompts that are clear, specific, and structured around a well-defined outcome, with explicit context and output requirements.[1][2][3]

## Core content of a good prompt

- Start from the goal: decide what you want (summary, plan, code, critique, etc.) and write that as a direct instruction using action verbs like “write”, “analyze”, or “generate”.[4][5][6]
- Include essential context and constraints: who the audience is, what source material to use, domain assumptions, and any limits on length, style, or format.[7][3][6]
- Specify the output format: bullet list, JSON, Markdown section layout, or step-by-step procedure, so the model can shape its response correctly.[8][9][4]

## Style and wording guidelines

- Choose simple, unambiguous language; being slightly longer and explicit usually beats short but vague phrasing.[10][3]
- Prefer positive, testable instructions (“Include X”, “Use Y steps”, “Avoid Z by doing…”) instead of only negative rules (“don’t do…”), which are easier for models to misinterpret.[10][8]
- Break complex tasks into smaller prompts or sub-steps rather than one giant request, iterating with follow-up prompts to refine results.[1][4]

## Structural patterns that work well

- Use a consistent internal structure such as: Role (who the model is), Task (what to do), Context (background, inputs), Constraints (rules, safety, scope), and Output (exact format).[11][9][1]
- When reliability matters, provide at least one short example of a good response (“few-shot” prompting) to anchor the model’s behavior.[2][11][1]
- For longer workflows, document reusable prompts or patterns in a shared spec (e.g., AGENTS.md or similar), and keep chat-time prompts as thin, task-specific overlays.[12][13][14]

[1](https://help.openai.com/en/articles/6654000-best-practices-for-prompt-engineering-with-the-openai-api)
[2](https://cloud.google.com/discover/what-is-prompt-engineering)
[3](https://haystack.deepset.ai/blog/beginners-guide-to-llm-prompting)
[4](https://www.techtarget.com/searchenterpriseai/tip/Prompt-engineering-tips-and-best-practices)
[5](https://www.claude.com/blog/best-practices-for-prompt-engineering)
[6](https://mitsloanedtech.mit.edu/ai/basics/effective-prompts/)
[7](https://www.multimodal.dev/post/llm-prompting)
[8](https://dev.to/get_pieces/10-prompt-engineering-best-practices-23dk)
[9](https://www.reddit.com/r/PromptEngineering/comments/1arou9e/how_do_you_write_a_good_llm_prompt/)
[10](https://www.digitalocean.com/resources/articles/prompt-engineering-best-practices)
[11](https://mirascope.com/blog/llm-prompt)
[12](https://www.builder.io/c/docs/agents-md)
[13](https://electric-sql.com/docs/agents)
[14](https://agentsmd.net)
[15](https://www.lakera.ai/blog/prompt-engineering-guide)
[16](https://clearimpact.com/effective-ai-prompts/)
[17](https://www.grammarly.com/blog/ai/generative-ai-prompts/)
[18](https://www.atlassian.com/blog/artificial-intelligence/ultimate-guide-writing-ai-prompts)
[19](https://www.huit.harvard.edu/news/ai-prompts)
[20](https://www.reddit.com/r/PromptEngineering/comments/1kggmh0/google_dropped_a_68page_prompt_engineering_guide/)
[21](https://grow.google/prompting-essentials/)
[22](https://www.reddit.com/r/PromptEngineering/comments/1hv1ni9/prompt_engineering_of_llm_prompt_engineering/)
[23](https://www.prompthub.us/blog/10-best-practices-for-prompt-engineering-with-any-model)
