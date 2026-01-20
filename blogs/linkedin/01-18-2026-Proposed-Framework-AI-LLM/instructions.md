# Purpose

Write a blog post for external publication that introduces Prompt Engineering and Content Engineering concepts. The blog should be generic with a slight bias toward OCI (Oracle Cloud Infrastructure).

## Objectives
- Propose a framework based on best practices for structuring AI/LLM usage in product engineering
- Target length: ~1200 words (including code snippets)
- Write using instructions from `humanize-text.md` (Mode: Humanize)

# Output Artifacts

1. A blog post with explicit structure recommendations for AI/LLM project repositories
2. References to industry best practices and standards
3. Clear, actionable guidance for engineering teams

# Proposed Repository Structure

Consider the following file structure for AI/LLM-enabled projects:

- **AGENT.md** - Agent configuration and behavior definitions
- **MEMORY.md** - Context management and memory persistence
- **TASKS.md** - Task definitions and workflows
- **README.md** - Project overview and getting started guide
- Additional subfolders as needed for organization

**Note:** Determine appropriate naming convention (uppercase vs. lowercase) based on project standards.

# Background: Product Development Lifecycle

In typical product development, work flows through these stages:

1. **Requirements Gathering** - Product/Customer requirements captured in high-level documentation
2. **Architecture & POC** - High-level engineering draft and proof-of-concept from architects
3. **High-Level Design** - Overall system design by Senior Principal Engineers
4. **Low-Level Design** - Detailed component designs by Senior Principal and Senior Engineers
5. **Sprint Planning** - Jira items and sprint tasks for development teams
6. **Development** - Code implementation using TDD approach with iterative development
7. **Deployment & Testing** - Integration testing and production release

# Reference Materials

The following files contain research and draft content for this blog:

- `chatgpt.md` - ChatGPT blog version
- `copilot.md` - Copilot blog version
- `gemini.md` - Gemini blog version
- `grok.md` - Grok blog version
- `perplexity.md` - Perplexity version
- `grok-research.md` - Research by Grok on industry standards
- `perplexity-research.md` - Research by Perplexity on industry standards
- `docs/ai-agent-templates` - OCI Architects proposal for OCI Compute

# Instructions for AI Assistant

Please synthesize the reference materials into a cohesive, well-structured blog post that:

1. Introduces the challenge of structuring AI/LLM work in product engineering
2. Proposes a practical framework with repository structure recommendations
3. Connects the framework to the product development lifecycle
4. Provides concrete examples (code snippets where appropriate)
5. References established best practices
6. Maintains a professional yet accessible tone (following humanize-text.md guidelines)
