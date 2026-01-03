document_type: meta
topic: docs-hub
keywords: [diataxis, documentation, prompts, adr, compute-admin-ui, forge, webpack, storybook]
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

Compute Admin UI Documentation Hub

Purpose
This hub organizes documentation for Compute Admin UI using the Diátaxis framework and PromptOps assets so both humans and AI agents can understand, navigate, and safely contribute to the project end-to-end.

Scope

- Tech stack: TypeScript, React 16.14, @oracle/forge, webpack, Storybook 6, Jest 27, ESLint (@typescript-eslint)
- Dev entry and scripts: npm start, npm run build, npm run storybook, npm run build-storybook, npm test, npm run test:fast, npm run test:debug, npm run lint, npm run sync-api-spec, npm run build-api-clients, npm run sync-blueprints, npm run stamp-version
- Build service: ocibuild.conf, bldenv; build runs with Node 16.20.0 and publishes tarball artifacts
- API clients: apis/_.yaml → build-api-clients → gen/ + src/clients/_ (trs, storekeeper, behavior-tracking)
- Routing and architecture: route-oriented pages in src/pages, components in src/components, contexts in src/state

How to navigate (Diátaxis)

- Tutorials (docs/02-tutorials): Learning-oriented guides with stepwise outcomes
- How-To (docs/03-how-to): Goal-focused task recipes with validation criteria
- Architecture (docs/04-architecture): C1/C2/C3 views and integration notes
- Reference (docs/05-reference): Canonical facts and enumerations (scripts, env vars)
- Decisions (docs/06-decisions): Immutable ADRs (MADR); supersede, do not edit
- Explanation (docs/07-explanation): Concepts, trade-offs, rationale
- Testing (docs/09-testing): Test strategy and patterns (placeholder)
- AI Agents (docs/09-ai-agents): PromptOps prompts, templates, workflows
- Metadata (docs/11-metadata): Metadata schema, link audits, style checks
- Projects (docs/100-projects): Domain- or feature-specific docs (optional expansion)

Proposed documentation tree (target IA)
docs/
index.md
readme.md (optional landing with contributor guidance)
01-getting-started/
02-tutorials/
tutorial-getting-started-dev-run-2025-11-12-v1.md
03-how-to/
howto-sync-api-spec-and-codegen-2025-11-12-v1.md
04-architecture/
arch-c1-context.md
arch-c2-containers.md
arch-c3-components.md (placeholder)
arch-c4po-integration.md (placeholder)
05-reference/
ref-build-test-scripts.md
ref-environment-variables.md (placeholder)
06-decisions/
0001-adopt-diataxis.md
0002-adopt-madr-template.md
07-explanation/
expl-api-codegen-and-routing-model.md
09-testing/
strategy.md (placeholder)
09-ai-agents/
prompts/
prompt-repo-deep-inspector.yaml
prompt-howto-writer.yaml (placeholder)
prompt-explanation-author.yaml (placeholder)
prompt-adr-drafter.yaml (placeholder)
prompt-link-auditor.yaml (placeholder)
prompt-style-accessibility-checker.yaml (placeholder)
prompt-c4po-architect.yaml (placeholder)
prompt-c4po-developer.yaml (placeholder)
prompt-c4po-operator.yaml (placeholder)
prompt-c4po-bug-triager.yaml (placeholder)
templates/
prompt-template.yaml (placeholder)
workflows/ (optional)
11-metadata/
metadata-schema.md
validation-and-maintenance.md
vocabulary.md
.keywords.json
100-projects/ (optional)

Migration plan for existing docs/ai-agent

- Architecture overviews → docs/04-architecture (e.g., overview.md → arch-c3-components.md)
- dependencies/\* → docs/05-reference/trs-api/ or relevant per-API reference pages
- features/behavior-tracking/\* → split: Explanation (concepts, PRD) and How-To (setup, usage), plus ADRs to docs/06-decisions
- HOWTOs/\* → docs/03-how-to with kebab-case filenames
- plans/\* → docs/07-explanation (concept and rationale) or docs/100-projects if ongoing program docs
- runbooks/\* → docs/02-tutorials if learning-oriented, or docs/03-how-to if operational recipe
- prompts/_ and workflows/_ → docs/09-ai-agents/prompts and docs/09-ai-agents/workflows

Stable anchors and chunking for AI

- Use descriptive H2/H3 headings as anchors; avoid duplicate text
- Reference chunk sizes:
  - Reference pages: 150–400 tokens per section
  - Explanation/Tutorial narratives: 300–600 tokens per section
- Keep each section self-contained and minimize cross-references
- Use explicit nouns instead of vague pronouns

Forge dev vs deployed path

- Local forge dev server runs at /local (homepage: https://devops.oci.oraclecorp.com/local?localPort=8080)
- Deployed runtime path is /<plugin-name> (compute-admin); ensure routing and asset paths are relative-safe

Compliance and safety guardrails

- OCI-internal: Do not include secrets, credentials, or internal URLs beyond those already present in README
- Never hardcode a developer-specific repo_root path; use {{repo_root}} variable
- All AI prompt files stay under docs/09-ai-agents/prompts/

Mermaid overview (C2 containers)

```mermaid
graph TD
  A["Compute Operators/SREs"] --> B["Frontend SPA (Forge + React)"]
  B --> C["External APIs (from apis/*)"]
  B --> D["Storybook Sandbox"]
  B --> E["Build Service Pipeline"]
  E --> F["Artifact: tar.gz (webpack)"]
```

Next steps

- Start with the Getting Started Hub: docs/01-getting-started/README.md (dev and AI agents quickstarts)
- Developer quick path: docs/01-getting-started/dev-quickstart.md, then docs/01-getting-started/dev-run-build-test.md
- AI Agents quick path: docs/01-getting-started/ai-agents-quickstart.md, then docs/03-how-to/howto-use-c4po-crew-workflows-2025-11-17-v1.md
- Start with the tutorial in docs/02-tutorials
- Use the scripts reference at docs/05-reference
- Review architecture C1/C2 to understand environment differences
- For changes to the docs system, add ADRs in docs/06-decisions

Alt text guidance

- When adding images, describe the purpose and content clearly (example: Alt text: “System context diagram showing the UI, Storybook, external APIs, and build service relationships.”)

Validation

- See docs/11-metadata/validation-and-maintenance.md for Diátaxis purity checks, AI-friendliness, link integrity, and repo-specific technical checks
