document_type: adr
topic: adopt-diataxis
keywords: [adr, decision, documentation, diataxis, templates]
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

Title
Adopt Diátaxis for documentation-as-code

Status
Accepted

Context and Problem
The repository contains mixed documentation under docs/ai-agent and archives with inconsistent structure and audiences. Contributors and AI agents need a predictable, AI-ready documentation architecture that supports learning (tutorials), task execution (how-to), facts (reference), and rationale (explanation) while aligning with Compute Admin UI’s toolchain (Forge, webpack, Storybook, Jest, ocibuild). Without a clear framework, docs are hard to navigate, hard to validate, and difficult to automate.

Decision Drivers
- Improve discoverability and contributor onboarding
- Enable AI-assisted authoring and retrieval (RAG-friendly chunking and stable anchors)
- Separate concerns between learning, tasks, facts, and rationale
- Support immutability and traceability via ADRs
- Keep all docs inside docs/ with kebab-case names

Considered Options
- Keep current ad-hoc structure
- Adopt Diátaxis with numeric-prefixed directories and templates
- Adopt another framework (e.g., Divio-like variants, custom schema)

Decision Outcome
Adopt Diátaxis with numeric-prefixed directories and standardized metadata across all docs, plus ADRs for doc changes.

Y-Statement
We will adopt the Diátaxis documentation framework because it cleanly separates learning, tasks, facts, and rationale, which leads to clearer navigation for humans and better retrieval for AI agents, accepting that we must migrate existing docs and train contributors to use the new structure.

Consequences
- Positive: Clear IA (02-tutorials, 03-how-to, 04-architecture, 05-reference, 06-decisions, 07-explanation, 09-testing, 09-ai-agents, 11-metadata), improved onboarding, higher AI retrieval precision.
- Positive: Easier validation via purity checks and link audits.
- Negative: One-time migration effort from docs/ai-agent; contributor education required.
- Negative: Additional maintenance discipline to keep purity and metadata consistent.

Pros/Cons Matrix
- Keep ad-hoc structure
  - Pros: No migration effort now.
  - Cons: Ongoing confusion, poor AI retrieval, hard to validate.
- Diátaxis (chosen)
  - Pros: Clear separation, scalable, AI-friendly, aligns with repo needs.
  - Cons: Migration and contributor training.
- Other framework
  - Pros: Potentially similar benefits.
  - Cons: Less widely understood; fewer examples; uncertainty.

Links
- docs/index.md (hub and IA)
- docs/11-metadata/metadata-schema.md (front-matter schema)
- docs/11-metadata/validation-and-maintenance.md (checklists and cadence)
