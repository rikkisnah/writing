document_type: meta
topic: metadata-schema
keywords: [metadata, front-matter, diataxis, ai, rag, conventions]
audience: developers (all)
created_date: 2025-11-12
updated_date: 2025-11-12
version: 1.0.0
owners: Compute Admin UI
module:
dependencies: []
repo_root: {{repo_root}}
default_branch: master
product_name: Compute Admin UI
org_name: OCI Compute

Metadata Schema and Conventions

Purpose
Define a consistent metadata schema for all Markdown documents and YAML prompts under docs/. The schema supports Diátaxis purity, AI retrieval (RAG), and repository governance.

Document Front-Matter Schema (for all Markdown docs)
- document_type: tutorial | how_to | reference | explanation | architecture | adr | meta
- topic: short-slug (kebab-case, ≤ 25 chars)
- keywords: [5–12 search terms, kebab-case preferred]
- audience: role and level (e.g., developers (intermediate))
- created_date: YYYY-MM-DD (UTC)
- updated_date: YYYY-MM-DD (UTC)
- version: semver (e.g., 1.0.0)
- owners: team or emails (Compute Admin UI)
- module: optional-module-slug (kebab-case) or empty
- dependencies: [doc-slugs or filenames this doc depends on]
- repo_root: {{repo_root}} (do not hardcode developer paths)
- default_branch: master
- product_name: Compute Admin UI
- org_name: OCI Compute

File Naming Rules (Kebab Case)
- Tutorials: tutorial-{topic}-{date}-v{n}.md
- How-To: howto-{goal}-{date}-v{n}.md
- Reference: ref-{scope}.md
- Explanation: expl-{concept}.md
- Architecture: arch-{view}-{scope}.md
- ADRs: 000N-{short-slug}.md (sequential, immutable; supersede rather than edit)
- Prompts (YAML): prompt-{agent-role}-{purpose}.yaml

Diátaxis Purity and Chunking
- Tutorials: step-by-step learning, outcome-driven; no large reference tables.
- How-To: goal-focused procedures with validation; avoid rationale digressions.
- Reference: canonical facts, parameters, scripts, and enumerations; no steps.
- Explanation: concepts, trade-offs, rationale; no step-by-step instructions.
- Ideal chunk sizes:
  - Reference: 150–400 tokens per section
  - Explanation/Tutorial narratives: 300–600 tokens per section
- Stable anchors: use descriptive H2/H3 headings; avoid duplicates and vague pronouns.

Alt Text Guidance
- When images are required, provide explicit alt text. Example: Alt text: “System context diagram showing the UI, Storybook, external APIs, and build service relationships.”

Filled Examples (for this repository)

Example 1 (Tutorial: local dev run)
document_type: tutorial
topic: local-dev-run
keywords: [dev-server, webpack, forge, local, npm-start]
audience: developers (intermediate)
created_date: 2025-11-12
updated_date: 2025-11-12
version: 1.0.0
owners: Compute Admin UI
module:
dependencies: []
repo_root: {{repo_root}}
default_branch: master
product_name: Compute Admin UI
org_name: OCI Compute

Example 2 (How-To: sync API spec and codegen)
document_type: how_to
topic: sync-api-spec-and-codegen
keywords: [openapi, codegen, gen, clients, sync-api-spec, build-api-clients]
audience: developers (intermediate)
created_date: 2025-11-12
updated_date: 2025-11-12
version: 1.0.0
owners: Compute Admin UI
module:
dependencies: []
repo_root: {{repo_root}}
default_branch: master
product_name: Compute Admin UI
org_name: OCI Compute

Example 3 (Reference: scripts and tooling)
document_type: reference
topic: scripts-and-tooling
keywords: [npm-scripts, storybook, jest, eslint, webpack, ocibuild]
audience: developers (all)
created_date: 2025-11-12
updated_date: 2025-11-12
version: 1.0.0
owners: Compute Admin UI
module:
dependencies: []
repo_root: {{repo_root}}
default_branch: master
product_name: Compute Admin UI
org_name: OCI Compute

Stable Anchors (Recommended)
- Title and Purpose
- Scope and Audience
- Prerequisites (if applicable)
- Steps or Canonical Facts (depending on type)
- Validation or Examples
- Troubleshooting or Trade-offs
- Notes on Chunking and Anchors

Compliance and Safety
- This is an OCI-internal repository. Do not include secrets, credentials, or internal URLs beyond those already present in README.
- Never hardcode a developer-specific repo_root path; use {{repo_root}}.
- Prompt YAML files must be stored only under docs/09-ai-agents/prompts/.
