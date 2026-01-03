# Status Icon and Badge Conventions

Last Updated: 2025-11-17  
Scope: Standard, repo‑wide conventions for visual status badges (emoji) used in dashboards, plans, risk registers, and AI prompt outputs (e.g., c4po crews). Applies to docs and generated markdown.

## 1) Purpose

- Provide a single source of truth for status icons used across this repository.
- Ensure consistency and readability for Exec, Product, Eng, SRE, and AI-generated reports.
- Improve accessibility by pairing icons with clear textual meaning and fallback guidance.

## 2) Canonical Icon Legend

Primary program statuses

- 🟢 Green — On track
- 🟡 Amber — Watch/plan
- 🔴 Red — Blocker
- ⏳ In progress
- ✅ Done

Risk/Severity badges

- ❗ Sev‑1 (High)
- ⚠️ Sev‑2 (Medium)
- ℹ️ Sev‑3+ (Info/Low)

Trend indicators

- ↗ Improving
- → Steady
- ↘ Declining

Optional states (use sparingly)

- 🚫 Not applicable / Paused
- 📌 Decision recorded
- 📨 Pending external input

Notes:

- Use exactly one primary status icon per “Status” cell.
- Add a brief textual note alongside icons if the audience may be unfamiliar with the legend.

## 3) Usage Guidelines

Tables (preferred for Exec audiences)

- Place the icon in the Status column, left of any short text.
- Keep cells concise (1–2 lines). Use reference links for details.
- Use sentence case; avoid all caps.

Headings and callouts

- Do not prefix headings with icons. Use icons in tables or inline notes.

Accessibility

- Avoid color‑only signaling; pair icons with a label in the table header (e.g., “Status”).
- On first page of any report, include a mini legend linking to this document or reproduce the legend table.

Plain‑text / Non‑emoji fallback

- If emoji rendering is not available:
  - 🟢 → [G], 🟡 → [A], 🔴 → [R], ⏳ → [IP], ✅ → [DONE]
  - ❗ → [S1], ⚠️ → [S2], ℹ️ → [S3]
  - ↗ → [UP], → → [FLAT], ↘ → [DOWN]

## 4) Standard Table Schemas (Copy/Paste)

Executive Snapshot (scorecard)
| Area | Status | Owner | Notes |
|---|---:|---|---|
| Overall Program | 🟡 | Product | Core instrumentation in progress |
| SDK Reliability | 🟢 | UI Eng Lead | Drop/transport within targets |
| Query Performance | 🟢 | Platform | Summary-first p95 < 1s (pre‑pilot) |
| Ops Readiness | 🟡 | SRE | Dashboards/alerts pending |

KPI Table
| KPI | Target | Current | Trend | Status |
|---|---:|---:|:---:|:---:|
| dropped_events (15m) | ≤ 0.5% | n/a | → | 🟡 |
| transport_errors (5m) | ≤ 1% | n/a | → | 🟡 |
| Summary p95 | < 1s | n/a | → | 🟡 |

Milestones
| ID | Milestone | ETA | Owner | Confidence | Status |
|---|---|---:|---|:---:|:---:|
| M1 | Core Instrumentation MVP | 2025-11-28 | UI Eng Lead | HIGH | ⏳ |
| M2 | Gantt panning + a11y | 2025-11-28 | UI Eng | HIGH | ⏳ |

Risks
| ID | Risk | Sev | Likelihood | Owner | ETA | Status |
|---|---|:---:|:---:|---|---:|:---:|
| R‑003 | LSE recovery load | ⚠️ | M | Platform+SRE | 2025-12-05 | 🟡 |

Eisenhower (program)
| Quadrant | Item | Owner | ETA | Status | Note |
|---|---|---|---:|:---:|---|
| Urgent/Important | Enable network for pilot | Product+UI | 2025-11-28 | ⏳ | Gated by kill switch |

Decisions
| Date | Decision | Impact | Owner |
|---|---|---|---|
| 2025-11-17 | Delegation + proxy first | Faster coverage, lower risk | Product/Arch |

## 5) Prompt Integration (c4po crews)

When generating markdown, c4po roles SHOULD import and apply this legend. Reference:

- Legend: docs/12-conventions/status.md
- Use the “Tables (preferred for Exec audiences)” guidance.
- For Chief of Staff persona outputs:
  - Executive Snapshot table first
  - KPI table second
  - Milestones next
  - Top Risks (with Sev/Likelihood and a status icon)
  - Decisions / Asks (compact tables)
  - Eisenhower matrix optional but encouraged for program plans

Recommended prompt snippet (YAML)

```yaml
conventions:
  status:
    primary:
      green: "🟢"
      amber: "🟡"
      red: "🔴"
      in_progress: "⏳"
      done: "✅"
    risk:
      sev1: "❗"
      sev2: "⚠️"
      sev3: "ℹ️"
    trend:
      up: "↗"
      flat: "→"
      down: "↘"
  link: "docs/12-conventions/status.md"
table_order:
  - snapshot
  - kpi
  - milestones
  - risks
  - decisions
  - eisenhower
```

## 6) Repo Expectations

- Consistency: All new dashboards and plans MUST use this icon set and table schemas (allow minor layout adaptations per audience).
- PR Review: Reviewers SHOULD check for use of icons and the presence of a minimal legend (or link to this doc) in any new executive-facing doc.
- Backward Compatibility: Existing docs MAY be migrated opportunistically; no mass rewrite required.

## 7) FAQ

Q: Can we introduce new icons?  
A: Prefer not to. Propose additions via a PR to this file with rationale and usage examples.

Q: Can I place icons inline in paragraphs?  
A: Allowed but discouraged. Icons should primarily appear in tables for clarity.

Q: What about Confluence or PDFs?  
A: Use the fallback labels where emoji rendering is unreliable (see §3).
