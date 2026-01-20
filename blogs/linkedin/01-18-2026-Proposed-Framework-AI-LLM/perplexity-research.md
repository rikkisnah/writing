Here are some high-signal resources specifically on prompt design, system prompts for agents, and memory/AGENT scaffolds.

## Practitioner blogs and guides

- **Anthropic – Effective context engineering for AI agents**: Discusses how to structure system prompts, tools, and memory for multi-step agents; closest to an “AGENT.md” philosophy guide. [anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- **Prompt Engineering Guide – LLM Agents page**: Covers prompt architectures for agents (planner, tools, memory, executor) with concrete patterns and diagrams. [promptingguide](https://www.promptingguide.ai/research/llm-agents)
- **AWS + Anthropic Bedrock blog – Prompt engineering techniques and best practices**: Hands-on patterns for composing prompts and iterating, useful as a template for an internal PROMPTS.md. [aws.amazon](https://aws.amazon.com/blogs/machine-learning/prompt-engineering-techniques-and-best-practices-learn-by-doing-with-anthropics-claude-3-on-amazon-bedrock/)
- **PromptHub – Prompt Engineering Principles for 2024**: Curated list of ~20+ principles that map nicely to a checklist-style AGENT.md (roles, constraints, examples, self-critique, etc.). [prompthub](https://www.prompthub.us/blog/prompt-engineering-principles-for-2024)
- **Case Done by AI – Prompt Engineering Guide for 2024 (Substack)**: Practical, structured breakdown (role, task, context, format, examples, CoT) with XML-style tagging patterns you can port directly. [casedonebyai.substack](https://casedonebyai.substack.com/p/prompt-engineering-guide-for-2024)
- **KNIME – 8 best practices for effective prompt engineering**: Shows role/process/task tagging patterns, with XML-ish structuring that resembles AGENT.md prompt sections. [knime](https://www.knime.com/blog/prompt-engineering)

## Survey / research papers on prompt engineering

These are good to mine for taxonomy/background sections in a repo-level PROMPTS.md:

- **A Systematic Survey of Prompt Engineering in Large Language Models: Techniques and Applications (2024)**: arXiv survey organizing prompting methods by application, with taxonomy diagrams. [arxiv](https://arxiv.org/abs/2402.07927)
- **A Survey of Prompt Engineering Methods in Large Language Models (2024)**: Focuses on methods vs tasks, and performance summaries across datasets; good reference list. [arxiv](https://arxiv.org/abs/2407.12994)
- **A Comprehensive Survey of Prompt Engineering Techniques in Large Language Models (TechRxiv, 2025)**: Longer, more recent survey with categorizations and open challenges. [techrxiv](https://www.techrxiv.org/users/898487/articles/1274333-a-comprehensive-survey-of-prompt-engineering-techniques-in-large-language-models)

## Agent + memory specific work (MEMORY.md inspiration)

- **mem-agent: Equipping LLM Agents with Memory Using RL (Hugging Face blog)**: Describes a scaffold with explicit memory tools, retrieval, update, clarification tasks; includes a full agent system prompt in the appendix you can adapt into AGENT.md/MEMORY.md. [huggingface](https://huggingface.co/blog/driaforall/mem-agent-blog)
- **A-MEM: Agentic Memory for LLM Agents (arXiv 2025)**: Proposes an “agentic memory” system with retrieval and contextual description generation; useful for designing memory schemas and retrieval prompts. [arxiv](https://arxiv.org/pdf/2502.12110.pdf)
- **Prompt Engineering Guide – LLM Agents page** (again): Has a section on “prompt robustness and reliability” for memory and planning modules in an agent. [promptingguide](https://www.promptingguide.ai/research/llm-agents)

## Vendor prompting guides (good for repo-level PROMPTS.md)

- **OpenAI – Best practices for prompt engineering with the API**: General best practices that translate cleanly into checklist sections for prompts and agents. [help.openai](https://help.openai.com/en/articles/6654000-best-practices-for-prompt-engineering-with-the-openai-api)
- **Google’s 68-page prompt engineering whitepaper (linked via Reddit thread)**: Longer-form guide focused on API use; deep on structure, formatting, and config options that can influence how you write AGENT.md. [reddit](https://www.reddit.com/r/PromptEngineering/comments/1jws1ag/google_just_dropped_a_68page_ultimate_prompt/)

If you share an example AGENTs.md / MEMORY.md skeleton you like, resources can be mapped directly into sections (e.g., “Roles & Constraints”, “Tools & Calls”, “Memory schema & retrieval prompts”, “Self-critique and safety”).