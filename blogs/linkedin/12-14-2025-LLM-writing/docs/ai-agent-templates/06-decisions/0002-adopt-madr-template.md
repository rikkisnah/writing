document_type: adr
topic: adopt-madr-template
keywords: [adr, decision, documentation, madr, template]
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
Adopt MADR as the Architecture Decision Record template

Status
Accepted

Context and Problem
Compute Admin UI requires a consistent, immutable decision log format for architecture and documentation decisions. Existing documents under docs/ai-agent and archives contain various formats. Contributors and AI agents need a predictable ADR structure with clear sections and metadata to enable review, traceability, and retrieval (RAG).

Decision Drivers
- Consistent, lightweight, readable ADRs
- Proven community pattern with clear sections
- Support for Y-statement to clarify outcome succinctly
- Ease of authoring and reviewing via Markdown in-repo

Considered Options
- Use MADR (Markdown Any Decision Records)
- Use Architecture Decision Records by Michael Nygard (ADR)
- Create a custom ADR format

Decision Outcome
Use MADR for all new ADRs, stored under docs/06-decisions/, numbered sequentially with zero-padded numbers (e.g., 0001-…md). Each ADR includes a Y-statement and Pros/Cons matrix.

Y-Statement
We will use MADR for decision records so that decisions are captured in a simple, well-known structure with explicit context, options, outcomes, and consequences, leading to better traceability and AI retrieval, at the cost of migrating or superseding any prior non-MADR notes.

Consequences
- Positive: Standardized authoring and reviewing; unambiguous sections; predictable indexing for AI.
- Positive: Easier migration and superseding; each ADR immutable once accepted (use “Superseded by …” to replace).
- Negative: One-time learning curve and migration effort from earlier ad-hoc decision notes.

Pros/Cons Matrix
- MADR (chosen)
  - Pros: Clear sections; widely used; easy Markdown; integrates well with docs-as-code.
  - Cons: Requires initial contributor familiarization.
- Nygard ADR
  - Pros: Classic and well-known; concise.
  - Cons: Less prescriptive than MADR; fewer conventions for modern teams.
- Custom Format
  - Pros: Tailored to internal needs.
  - Cons: Reinvents the wheel; higher maintenance; harder for new contributors and AI tools.

Template Guidance
- File name: 000N-short-slug.md
- Immutability: Mark ADR as Accepted or Superseded; do not edit past ADRs, create new ADRs to supersede.
- Metadata: Include repository-standard metadata block at top (see docs/11-metadata/metadata-schema.md).
- Sections: Status, Context and Problem, Decision Drivers, Considered Options, Decision Outcome (with Y-statement), Consequences, Pros/Cons Matrix, Links.

Links
- docs/06-decisions/0001-adopt-diataxis.md
- docs/11-metadata/metadata-schema.md
