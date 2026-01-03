document_type: meta
topic: validation-and-maintenance
keywords: [validation, checklist, maintenance, diataxis, ai-friendliness, link-audit, promptops]
audience: developers (all)
created_date: 2025-11-12
updated_date: 2025-11-12
version: 1.0.0
owners: Compute Admin UI
module:
dependencies: [docs/11-metadata/metadata-schema.md]
repo_root: {{repo_root}}
default_branch: master
product_name: Compute Admin UI
org_name: OCI Compute

Validation Checklists and Maintenance Plan

Diátaxis Purity Checklist
- The tutorial does not include reference tables or architecture rationales.
- The how-to is goal-focused with validation criteria, not rationale.
- The reference is fact-only; no step-by-step instructions or prose rationale.
- The explanation discusses concepts, trade-offs, and risks; no step lists.
- Architecture pages focus on structure and relationships; no task recipes.

AI-Friendliness Checklist
- Each document is self-contained and uses explicit nouns instead of vague pronouns.
- Headings are descriptive; anchors are stable, unique, and reflect content.
- Chunk sizes respected: 150–400 tokens for reference; 300–600 tokens for narrative (tutorial/explanation/architecture).
- Descriptive link text is used; minimal cross-references; repeat essential context locally.
- Mermaid diagrams label any special characters in double quotes; include alt text guidance.

Metadata and Links Checklist
- All required front-matter fields present and consistent with docs/11-metadata/metadata-schema.md.
- File and directory names use kebab case; ADRs use zero-padded numbers.
- Internal relative links resolve; anchors exist and match headings exactly.
- External links use descriptive link text and avoid sensitive internal details.

Repo-Specific Technical Checklist
- npm start runs the webpack dev server; the forge dev URL is reachable: https://devops.oci.oraclecorp.com/local?localPort=8080
- Storybook runs or builds with NODE_OPTIONS=--openssl-legacy-provider.
- Tests succeed: npm test, npm run test:fast, npm run test:debug; verify d3 mapping in config/jest.config.js.
- Lint passes or auto-fixes: npm run lint (use npm run test:lint for check-only).
- Production build succeeds: npm run build; src/version.ts stamped by npm run stamp-version.
- API flows succeed: npm run sync-api-spec and npm run build-api-clients without errors; gen/ populated; src/clients compiled.
- Build service parity: ocibuild.conf steps reflect local commands; webpack --env artifactFile configured.

Migration and IA Checklist (docs/ai-agent → Diátaxis)
- Classify existing docs/ai-agent materials into Tutorials, How-To, Reference, Explanation, Architecture, Prompts.
- Migrate or split files to the new docs/ tree using kebab-case names and numeric prefixes.
- Mark superseded ADR-like notes with new ADRs in docs/06-decisions/.
- Ensure prompts live under docs/09-ai-agents/prompts/ only.

Maintenance Plan
- Owners: Compute Admin UI
- Cadence:
  - Per release cut (mandatory)
  - Monthly hygiene pass (optional but recommended)
- Triggers:
  - New route/page added under src/pages/
  - Significant change to tsconfig.json, config/webpack.config.js, config/jest.config.js, or config/.eslintrc.js
  - API spec updates in apis/ or generator changes affecting gen/ and src/clients/
  - New ADR merged, or existing ADR superseded
  - Build service (ocibuild.conf) changes impacting steps, Node version, or artifact naming
- Workflow:
  - Use PR-based updates to docs/ with mandatory review by a domain owner and a PromptOps owner.
  - Run Link Auditor and Style & Accessibility Checker prompts from docs/09-ai-agents/prompts/.
  - Update metadata created_date/updated_date and version when making material changes.
  - For ADR updates, never edit accepted ADRs; create a new ADR marked “Supersedes 000N-{slug}”.

Link Audit Procedure
- Use the Link Auditor prompt (docs/09-ai-agents/prompts/prompt-link-auditor.yaml) to crawl internal relative links and anchors.
- Fix missing anchors by aligning headings or updating link targets.
- Record findings in docs/11-metadata/link-audit-YYYY-MM-DD.md.

Style and Accessibility Procedure
- Use the Style & Accessibility Checker prompt (docs/09-ai-agents/prompts/prompt-style-accessibility-checker.yaml).
- Confirm inclusive language, readable sentence structures, and complete alt text for any images or diagrams.
- Record findings in docs/11-metadata/style-accessibility-YYYY-MM-DD.md.

Chunking and Anchors Guidance
- Favor short sections with clear H2/H3 headings, avoiding nested, ambiguous titles.
- Keep each section self-contained for reliable RAG chunking and human scanning.
- Avoid over-linking; restate key constraints locally to reduce navigation cost.

Compliance and Safety
- This repository is OCI-internal. Do not include secrets, credentials, or internal URLs beyond those already present in README or configuration comments.
- Never hardcode a developer-specific repo_root path; use {{repo_root}} placeholders in docs and prompts.
- AI prompts must remain under docs/09-ai-agents/prompts/ with YAML metadata including owners, version, and dates.

Review Checklist (per PR)
- Diátaxis purity confirmed for modified files.
- Metadata headers present and valid.
- Links and anchors verified; Link Auditor report attached or referenced.
- Language clarity and accessibility checked; Style Checker report provided.
- Scripts, configs, and flows consistent with package.json, tsconfig.json, config/*, and ocibuild.conf.
