document_type: architecture
topic: overview-template
keywords: [c1, c2, c3, routing, codegen, forge, templates]
audience: developers (intermediate)
created_date: {{date_utc}}
updated_date: {{date_utc}}
version: 1.0.0
owners: Compute Admin UI
module:
dependencies: []
repo_root: {{repo_root}}
default_branch: {{default_branch}}
product_name: {{product_name}}
org_name: {{org_name}}

Title
Architecture Overview (C1/C2/C3)

C1 System Context
Describe actors (operators, SREs, developers, managers), the SPA boundary, and external systems (from apis/*).
Include a short text-only legend for any diagram and recommended alt text.

C2 Containers
Describe the SPA, Storybook sandbox, build service pipeline, and external API services.
Call out environment differences between forge dev path (/local) and deployed runtime path (/<plugin-name>).

C3 Components
Describe major UI domains (by src/pages), shared components (src/components), contexts (src/state), and API client layer (src/clients, gen/).
Explain component responsibilities and interactions concisely.

Configs and Environments
Summarize configs (config/webpack.config.js, config/jest.config.js, config/.eslintrc.js, tsconfig.json) and environment assumptions.

Observability, Errors, Resilience
Describe logging (loglevel), error boundaries or generic error components, retry or fallback UI patterns.

Stable anchors and chunking guidance
- Use H2/H3 headings above to provide stable anchors
- Aim for 300–600 tokens per narrative section
- Keep each section self-contained and avoid unnecessary cross-references

Alt text guidance
For any diagrams, include explicit alt text. Example: Alt text: “C2 containers showing dev server (/local), Storybook, external APIs, and build service producing a tar.gz artifact.”
