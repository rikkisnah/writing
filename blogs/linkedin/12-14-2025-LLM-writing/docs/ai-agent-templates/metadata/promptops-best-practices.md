document_type: meta
topic: promptops-best-practices
keywords: [promptops, governance, evaluation, telemetry, safety, versioning, accessibility]
audience: developers (all)
created_date: 2025-11-12
updated_date: 2025-11-12
version: 1.0.0
owners: Compute Admin UI
module:
dependencies: [docs/11-metadata/validation-and-maintenance.md, docs/09-ai-agents/templates/prompt-template.yaml]
repo_root: {{repo_root}}
default_branch: master
product_name: Compute Admin UI
org_name: OCI Compute

PromptOps Best Practices (Development Lifecycle)

Purpose
Establish lifecycle standards for designing, versioning, evaluating, approving, deploying, and maintaining AI prompts and PromptOps artifacts in this repository. Keep guidance self-contained and aligned with Diátaxis and repository tooling (Forge, webpack, Storybook, Jest, ocibuild).

Versioning and Provenance
- Use semantic versions for all prompts (version: X.Y.Z). Increment:
  - MAJOR for breaking behavior changes, MINOR for new capabilities, PATCH for quality tweaks.
- Include owners, created_date, updated_date, and model_compatibility in each YAML.
- Add provenance fields to outputs where applicable (repo URL and commit SHA in headers or logs).
- Maintain a CHANGELOG section per prompt when changes affect behavior or guardrails.

Experimentation and Evaluation
- Offline evaluations
  - Maintain gold fixtures and scenarios per domain under docs/09-ai-agents/fixtures/ (by topic).
  - Evaluate accuracy, completeness, readability; track pass/fail deltas across versions.
- Scenario coverage
  - Cover key environments: forge dev server (/local) and deployed path (/compute-admin).
  - Include module-specific cases (e.g., state contexts, trs client flows, behavior-tracking).
- A/B testing
  - Compare candidate prompts across preferred and compatible models; capture win/loss/regression data.
- Red-team testing
  - Exercise prompt-injection, jailbreaks, PII leakage, and sensitive data exfiltration paths.

Governance and Approvals
- Process
  - Changes via PRs only; co-review by domain owner and PromptOps owner required.
  - Material behavior or scope changes require an ADR (docs/06-decisions/) referencing prior ADRs if superseded.
- Immutability
  - Treat approved prompts as versioned artifacts; deprecate with an end-of-support date when needed.

Observability and Telemetry
- Log per run: prompt_id, version, model, parameters (temperature, top_p), tool calls, latency_ms, and a trace_id.
- Redact PII rigorously; store redaction status and reasons for failures.
- Persist evaluation scores and failure categories for trend analysis.

Safety and Guardrails
- Hard constraints in YAML:
  - must_not: exfiltrate secrets/credentials; modify files outside docs/; hardcode developer-specific repo_root.
  - must: descriptive link text; alt text guidance; Diátaxis purity; kebab-case and numeric prefixes.
- Refusal policy
  - Define clear refusals for out-of-scope actions or requests to access secrets or internal-only endpoints.
- Secrets isolation
  - Never embed secrets in prompts; use secure indirection or tool configuration outside this repository.

Reuse and Composition
- Use YAML anchors and references for shared role/style/guardrails where feasible.
- Maintain shared snippets under docs/09-ai-agents/templates/ and reference from prompts via anchors.

Compatibility and Drift
- Record model_compatibility with notes on degradations, token limits, or formatting issues.
- Use backward-compatible deprecations when possible; publish sunset dates and migration steps.

Delivery and Runtime Configs
- Externalize sampling parameters; allow environment overrides for dev/stage/prod.
- Use canary rollouts for new prompts; define automatic rollback on regression thresholds.

Documentation-as-Code
- Co-locate prompt YAML with docs and ADRs under docs/.
- Keep examples, diagrams (mermaid), and evaluation notes versioned in-repo.
- Ensure all docs remain self-contained, with stable anchors and chunk sizes for RAG.

Accessibility and Inclusivity
- Target clear reading level (short sentences, active voice).
- Provide alt text for all images and diagrams; describe purpose and content.
- Avoid idioms and culturally specific references; use inclusive and precise language.

Operational Checklist (per prompt change)
- Metadata updated (owners, dates, version) and guardrails present
- Evaluation results attached (offline + red-team) with deltas vs previous version
- Telemetry fields validated in runtime environment
- Governance: required approvals completed; ADR added for material changes
- Documentation updated (usage notes, examples, diagrams with alt text)

Stable Anchors (150–400 tokens per section)
- Versioning and Provenance
- Experimentation and Evaluation
- Governance and Approvals
- Observability and Telemetry
- Safety and Guardrails
- Reuse and Composition
- Compatibility and Drift
- Delivery and Runtime Configs
- Documentation-as-Code
- Accessibility and Inclusivity
- Operational Checklist
