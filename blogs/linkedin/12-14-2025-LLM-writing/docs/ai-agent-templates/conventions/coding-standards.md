# Coding Standards and Conventions

Purpose

- Establish consistent coding, testing, and documentation practices across the mono-repo.
- Align contributors and AI agents on style, quality gates, and module-level norms.

Primary references (source of truth)

- Checkstyle: `checkstyle.xml`, `checkstyle.8.42.xml`
- PMD: `pmd-rules.xml`
- Suppressions: `build_config/checkstyle-suppressions.xml`
- SCA/security: `sca-config.json`
- Module-level configs (e.g., `lombok.config`) where present

Language and tooling

- Java version/toolchain: follow repo defaults (shell.nix if used). Do not upgrade per-module without approval.
- Build: Maven multi-module project; prefer module-scoped builds for iteration.
- Static analysis: keep Checkstyle/PMD clean or narrowly justified with documented rationale.

Style guidelines

- Immutability: prefer immutable models and `final` fields where practical.
- Null-safety: validate inputs; use `Optional` judiciously for absence, not as a replacement for all null checks.
- Lombok: follow module precedent. Common: `@Getter`, `@Setter`, `@Builder`, `@Value`. Avoid overuse if it harms clarity.
- Builders: prefer builders for complex constructors; keep defaults explicit.
- Logging: use module-standard logging (no `System.out`). Messages actionable and context-rich; avoid sensitive data.
- Exceptions: prefer checked/unchecked exceptions consistent with module norms. Preserve cause chains and context.
- Naming and packages: align with module/package structure. Keep package-private where feasible to limit surface area.
- Method sizing: small and cohesive. Extract helpers when complexity grows.
- Comments and Javadoc: document public APIs, non-obvious decisions, and pre/post-conditions.

API and compatibility

- Backward compatibility: default stance is non-breaking. For public APIs, follow the API Change Checklist.
- Deprecation: mark with `@Deprecated` and document migration. Avoid instant removal; coordinate across modules.
- Validation: validate inputs at module boundaries; fail fast with clear error messages.

Testing conventions

- Unit tests colocated under `src/test/java`, naming like `ClassNameTest`.
- Focus on behavior, not implementation details. Cover nominal and edge/error paths.
- Determinism: no arbitrary sleeps; mock time, I/O, and external services.
- Use preferred framework per module (TestNG or JUnit as configured). Reuse existing test utilities/fixtures.
- See:
  - docs/ai-agent/context-packs/test-authoring.md
  - docs/ai-agent/prompts/snippets/test-coverage-criteria.md

Dependencies and modules

- Dependency hygiene: avoid unnecessary transitive exposure; prefer the minimal scope (e.g., `compile`, `runtime`, `test`).
- Versioning alignment: keep core dependencies aligned across modules unless justified.
- Avoid circular dependencies between modules. Extract shared code into appropriate shared modules when needed.

Suppressions policy

- Prefer fixing the root cause. If suppression is required:
  - Keep scope minimal (fine-grained, local).
  - Document the reason and link to issue/ticket when applicable.
  - Update `build_config/checkstyle-suppressions.xml` or local config responsibly.

Documentation

- Update module READMEs, runbooks, and API docs/specs when behavior or contracts change.
- Record notable design decisions in architecture docs or ADRs (if maintained).

Verification commands

- Build: `mvn -q -DskipTests package`
- Tests: `mvn -q test`
- Lint bundle:
  - `build_scripts/compute-lint`
  - `build_scripts/check_dependencies`
  - `build_scripts/check_xml_reports`

Change control

- Small, reviewable commits. Conventional PR titles (e.g., `feat(module): ...`, `fix(module): ...`).
- Use checklists:
  - docs/ai-agent/checklists/prs.md
  - docs/ai-agent/checklists/api-change.md (for API changes)
