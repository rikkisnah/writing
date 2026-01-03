document_type: meta
topic: migration-plan-ai-agent-to-diataxis
keywords: [migration, diataxis, mapping, prompts, architecture, how-to, reference]
audience: developers (all)
created_date: 2025-11-12
updated_date: 2025-11-12
version: 1.0.0
owners: Compute Admin UI
module:
dependencies: [docs/index.md, docs/11-metadata/validation-and-maintenance.md]
repo_root: {{repo_root}}
default_branch: master
product_name: Compute Admin UI
org_name: OCI Compute

Migration Plan: docs/ai-agent → Diátaxis Tree

Purpose
Provide a clear mapping and action plan to migrate existing materials in docs/ai-agent/ into the new Diátaxis-based documentation tree under docs/.

Scope
Sources: docs/ai-agent/** including architecture, dependencies, features/behavior-tracking, HOWTOs, plans, prompts, runbooks.

Mapping Rules (Plain Text Table)
- Source Path → Target Path → Document Type → Action

High-Level Mappings
- docs/ai-agent/architecture/overview.md → docs/04-architecture/arch-c3-components.md → architecture → Move and align headings
- docs/ai-agent/architecture/structure.md → docs/04-architecture/arch-c3-components.md → architecture → Merge relevant sections
- docs/ai-agent/architecture/state-management.md → docs/07-explanation/expl-state-management-model.md → explanation → Create new explanation page; port content
- docs/ai-agent/architecture/context-and-dependencies.md → docs/04-architecture/arch-c1-context.md → architecture → Integrate dependency references into C1/C2/C3 where relevant

Dependencies (Per-API)
- docs/ai-agent/architecture/dependencies/dependency-*.md → docs/05-reference/{api-slug}/ref-{api-slug}.md → reference → Create per-API reference pages; include links to apis/* specs and src/clients/* where applicable

Features: Behavior Tracking
- docs/ai-agent/architecture/features/behavior-tracking/behavior-tracking-architecture.md → docs/07-explanation/expl-behavior-tracking-architecture.md → explanation → Move; keep rationale and diagrams
- docs/ai-agent/architecture/features/behavior-tracking/behavior-tracking-prd.md → docs/07-explanation/expl-behavior-tracking-prd.md → explanation → Move; keep PRD facts and rationale
- docs/ai-agent/architecture/features/behavior-tracking/adrs/* → docs/06-decisions/000N-{short-slug}.md → adr → Convert to MADR format if needed; mark superseded where applicable

HOWTOs
- docs/ai-agent/HOWTOs/*.md → docs/03-how-to/howto-{goal}-{YYYY-MM-DD}-v1.md → how_to → Rename to kebab-case; add metadata; include validation and troubleshooting

Plans
- docs/ai-agent/plans/*.md → docs/07-explanation/expl-{topic}.md → explanation → Keep rationale and options; if purely project management, place under docs/100-projects/{program}/
- behavior-tracking-first-response.md → docs/100-projects/behavior-tracking/plan-first-response.md → meta → Optional relocation if ongoing program

Prompts and Workflows
- docs/ai-agent/prompts/*.md → docs/09-ai-agents/prompts/prompt-{role}-{purpose}.yaml → prompt → Convert to YAML using docs/09-ai-agents/templates/prompt-template.yaml
- docs/ai-agent/prompts/workflows/*.md → docs/09-ai-agents/workflows/{workflow-slug}.md → meta → Keep workflow narratives; add metadata

Runbooks
- docs/ai-agent/runbooks/*.md → docs/02-tutorials/tutorial-{topic}-{YYYY-MM-DD}-v1.md → tutorial → Reframe as runbook-oriented tutorials with outcomes and validation

Backlog
- docs/ai-agent/backlog/** → docs/100-projects/{area}/backlog.md → meta → Optional; keep non-doc items out of Diátaxis core categories

Step-by-Step Migration Actions
- Step 1: Inventory files in docs/ai-agent/ and classify using the mapping rules above.
- Step 2: Move or split content into target docs/ paths; rename to kebab-case; add required metadata headers.
- Step 3: For ADR-like content, author new MADR ADRs in docs/06-decisions/ with Y-statements; mark older notes as “superseded”.
- Step 4: Convert any prompt text into YAML under docs/09-ai-agents/prompts/ using the prompt template; add owners and version.
- Step 5: Update links and anchors to the new locations; run the Link Auditor prompt and fix issues.
- Step 6: Record migration completion with a short note in docs/11-metadata/link-audit-YYYY-MM-DD.md.

Validation
- Link Auditor (docs/09-ai-agents/prompts/prompt-link-auditor.yaml) produces a clean report.
- Style & Accessibility Checker (docs/09-ai-agents/prompts/prompt-style-accessibility-checker.yaml) shows no critical issues.
- Diátaxis purity: No mixing of reference facts with tutorial steps; explanations contain rationale only.

Risks and Mitigations
- Risk: Loss of history or nuance during conversion → Mitigation: For ADRs, write new MADR and reference the original document.
- Risk: Broken internal links → Mitigation: Run Link Auditor and fix all findings before merging.
- Risk: Overlong documents → Mitigation: Split by topic and respect chunk sizes for RAG.

Stable Anchors (150–400 tokens per section)
- Mapping Rules
- High-Level Mappings
- Step-by-Step Migration Actions
- Validation
- Risks and Mitigations

Alt Text Guidance
- When referencing old diagrams, provide alt text. Example: Alt text: “Behavior tracking architecture diagram showing ingest, query, and UI components.”
