# #{initiative} — Executive Delivery Dashboard

Last Updated: #{date}  
Initiative: #{initiative}  
Related Docs: [plan.md](../../100-projects/#{project_dir}/plan.md), [risk-register.md](../../100-projects/#{project_dir}/risk-register.md), [reality-check.md](../../100-projects/#{project_dir}/reality-check.md), [README.md](../../100-projects/#{project_dir}/README.md)

Note: Use the canonical icon legend and table schemas in docs/12-conventions/status.md

## Icon Legend

Refer to: [docs/12-conventions/status.md](../../12-conventions/status.md)

---

## Snapshot Scorecard

| Area                 | Status | Owner             | Notes            |
| -------------------- | -----: | ----------------- | ---------------- |
| Overall Program      |     🟡 | #{owner_overall}  | #{notes_overall} |
| SDK Reliability      |     🟢 | #{owner_sdk}      | #{notes_sdk}     |
| Query Performance    |     🟢 | #{owner_query}    | #{notes_query}   |
| Privacy & Compliance |     🟢 | #{owner_security} | #{notes_privacy} |
| Ops Readiness        |     🟡 | #{owner_sre}      | #{notes_ops}     |
| Rollout              |     ⏳ | #{owner_product}  | #{notes_rollout} |

---

## KPI Table (Exec)

| KPI                                | Target |                  Current |         Trend          |         Status          |
| ---------------------------------- | -----: | -----------------------: | :--------------------: | :---------------------: |
| dropped_events (15m)               | ≤ 0.5% |   #{kpi_dropped_current} |  #{kpi_dropped_trend}  |  #{kpi_dropped_status}  |
| transport_errors (5m)              |   ≤ 1% | #{kpi_transport_current} | #{kpi_transport_trend} | #{kpi_transport_status} |
| flush_latency_ms p95               |   ≤ 5s |     #{kpi_flush_current} |   #{kpi_flush_trend}   |   #{kpi_flush_status}   |
| Summary p95 (dashboard queries)    |   < 1s |       #{kpi_summary_p95} |  #{kpi_summary_trend}  |  #{kpi_summary_status}  |
| Summary miss ratio                 |  ≤ 10% |        #{kpi_miss_ratio} |   #{kpi_miss_trend}    |   #{kpi_miss_status}    |
| scannedPartitions (bounded)        |    Yes |           #{kpi_scanned} |  #{kpi_scanned_trend}  |  #{kpi_scanned_status}  |
| NLQ confidence median (if enabled) |  ≥ 0.7 |          #{kpi_nlq_conf} |    #{kpi_nlq_trend}    |    #{kpi_nlq_status}    |

Notes: Use “n/a” pre‑pilot; link live monitors at ops milestone.

---

## Milestones (Next Up)

| ID  | Milestone   |       ETA | Owner       | Confidence |    Status    |
| --- | ----------- | --------: | ----------- | :--------: | :----------: |
| M1  | #{m1_title} | #{m1_eta} | #{m1_owner} | #{m1_conf} | #{m1_status} |
| M2  | #{m2_title} | #{m2_eta} | #{m2_owner} | #{m2_conf} | #{m2_status} |
| M3  | #{m3_title} | #{m3_eta} | #{m3_owner} | #{m3_conf} | #{m3_status} |
| M4  | #{m4_title} | #{m4_eta} | #{m4_owner} | #{m4_conf} | #{m4_status} |

See full roadmap in [plan.md](../../100-projects/#{project_dir}/plan.md).

---

## Top Risks

| ID    | Risk     |     Sev      | Likelihood  | Owner          |          ETA |     Status      |
| ----- | -------- | :----------: | :---------: | -------------- | -----------: | :-------------: |
| R‑001 | #{risk1} | #{risk1_sev} | #{risk1_lh} | #{risk1_owner} | #{risk1_eta} | #{risk1_status} |
| R‑002 | #{risk2} | #{risk2_sev} | #{risk2_lh} | #{risk2_owner} | #{risk2_eta} | #{risk2_status} |
| R‑003 | #{risk3} | #{risk3_sev} | #{risk3_lh} | #{risk3_owner} | #{risk3_eta} | #{risk3_status} |

Full details: [risk-register.md](../../100-projects/#{project_dir}/risk-register.md).

---

## Decisions (Recent)

| Date       | Decision   | Impact       | Owner       |
| ---------- | ---------- | ------------ | ----------- |
| #{d1_date} | #{d1_text} | #{d1_impact} | #{d1_owner} |
| #{d2_date} | #{d2_text} | #{d2_impact} | #{d2_owner} |

---

## Owner ↔ Crew Mapping

| Owner Label             | Crew Role                      | Role Spec                                                                 |
| ----------------------- | ------------------------------ | ------------------------------------------------------------------------- |
| Product (Compute Admin) | c4po.chief-of-staff            | docs/09-ai-agents/prompts/crews/c4po/roles/chief-of-staff.yaml            |
| UI Eng Lead             | c4po.developer                 | docs/09-ai-agents/prompts/crews/c4po/roles/developer.yaml                 |
| UI Eng                  | c4po.developer                 | docs/09-ai-agents/prompts/crews/c4po/roles/developer.yaml                 |
| Platform Eng            | c4po.architect                 | docs/09-ai-agents/prompts/crews/c4po/roles/architect.yaml                 |
| SRE                     | c4po.chief-reliability-officer | docs/09-ai-agents/prompts/crews/c4po/roles/chief-reliability-officer.yaml |
| Repo Steward            | c4po.repo-steward              | docs/09-ai-agents/prompts/crews/c4po/roles/repo-steward.yaml              |
| Architecture/Security   | c4po.chief-security-officer    | docs/09-ai-agents/prompts/crews/c4po/roles/chief-security-officer.yaml    |

---

## Eisenhower Priority Matrix

| Quadrant             | Item          | Owner          |          ETA |     Status      | Note          |
| -------------------- | ------------- | -------------- | -----------: | :-------------: | ------------- |
| Urgent/Important     | #{ei_uu_item} | #{ei_uu_owner} | #{ei_uu_eta} | #{ei_uu_status} | #{ei_uu_note} |
| Important/Not Urgent | #{ei_in_item} | #{ei_in_owner} | #{ei_in_eta} | #{ei_in_status} | #{ei_in_note} |
| Delegate/Track       | #{ei_dt_item} | #{ei_dt_owner} | #{ei_dt_eta} | #{ei_dt_status} | #{ei_dt_note} |
| Defer/Review         | #{ei_dr_item} | #{ei_dr_owner} | #{ei_dr_eta} | #{ei_dr_status} | #{ei_dr_note} |

---

## Recommendations (Exec Actions)

| Recommendation | Why         | Owner         | Next Step    |
| -------------- | ----------- | ------------- | ------------ |
| #{rec1}        | #{rec1_why} | #{rec1_owner} | #{rec1_next} |
| #{rec2}        | #{rec2_why} | #{rec2_owner} | #{rec2_next} |

---

## Asks / Escalations

| Ask     |    Needed By | Owner         |     Status     |
| ------- | -----------: | ------------- | :------------: |
| #{ask1} | #{ask1_date} | #{ask1_owner} | #{ask1_status} |
| #{ask2} | #{ask2_date} | #{ask2_owner} | #{ask2_status} |

---

## Validation & Links

- Front page: table‑first layout with icons per [status.md](../../12-conventions/status.md)
- Deep dives: plan, risks, audit links above
- Evidence: #{evidence_links}
- Live monitors: #{monitor_links} (if applicable)
