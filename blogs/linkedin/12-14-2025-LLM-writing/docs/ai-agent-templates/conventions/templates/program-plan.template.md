# #{initiative} — Program Plan (Chief of Staff View)

Owners: #{owners}  
Last Updated: #{date}  
Related: [architecture.md](../../04-architecture/overview.md), [status.md](../../12-conventions/status.md), [exec dashboard](../../100-projects/#{project_dir}/dashboard.md)

Note: Adhere to the status icon convention in docs/12-conventions/status.md for any status tables.

## 1) Scope and Outcomes

In-scope

- #{scope_item_1}
- #{scope_item_2}
- #{scope_item_3}

Success Criteria

- #{success_criterion_1}
- #{success_criterion_2}
- #{success_criterion_3}

## 2) Current State (snapshot)

Shipped

- #{shipped_1}
- #{shipped_2}

Partially Implemented / Design Complete

- #{partial_1}
- #{partial_2}

Gaps / Next

- #{gap_1}
- #{gap_2}

## 3) Workstreams, Owners, Definition of Done

A. #{ws_a_name} (Owner: #{ws_a_owner})

- Deliver: #{ws_a_deliver}
- DoD: #{ws_a_dod}

B. #{ws_b_name} (Owner: #{ws_b_owner})

- Deliver: #{ws_b_deliver}
- DoD: #{ws_b_dod}

C. #{ws_c_name} (Owner: #{ws_c_owner})

- Deliver: #{ws_c_deliver}
- DoD: #{ws_c_dod}

## 4) Timeline and Milestones (incremental delivery)

Weeks #{w1_start}–#{w1_end}

- #{m1_title}
  - Acceptance: #{m1_acceptance}

Weeks #{w2_start}–#{w2_end}

- #{m2_title}
  - Acceptance: #{m2_acceptance}

Weeks #{w3_start}–#{w3_end}

- #{m3_title}
  - Acceptance: #{m3_acceptance}

## 5) Milestone Table (summary)

| ID  | Milestone         | ETA       | Owner       | Confidence |    Status    |
| --- | ----------------- | --------- | ----------- | :--------: | :----------: |
| M1  | #{m1_title_short} | #{m1_eta} | #{m1_owner} | #{m1_conf} | #{m1_status} |
| M2  | #{m2_title_short} | #{m2_eta} | #{m2_owner} | #{m2_conf} | #{m2_status} |
| M3  | #{m3_title_short} | #{m3_eta} | #{m3_owner} | #{m3_conf} | #{m3_status} |
| M4  | #{m4_title_short} | #{m4_eta} | #{m4_owner} | #{m4_conf} | #{m4_status} |

Status icons per [status.md](../../12-conventions/status.md).

## 6) Crew Mapping (Owners → c4po roles)

| Owner Label             | Crew Role                      | Role Spec                                                                 |
| ----------------------- | ------------------------------ | ------------------------------------------------------------------------- |
| Product (Compute Admin) | c4po.chief-of-staff            | docs/09-ai-agents/prompts/crews/c4po/roles/chief-of-staff.yaml            |
| UI Eng Lead             | c4po.developer                 | docs/09-ai-agents/prompts/crews/c4po/roles/developer.yaml                 |
| UI Eng                  | c4po.developer                 | docs/09-ai-agents/prompts/crews/c4po/roles/developer.yaml                 |
| Platform Eng            | c4po.architect                 | docs/09-ai-agents/prompts/crews/c4po/roles/architect.yaml                 |
| SRE                     | c4po.chief-reliability-officer | docs/09-ai-agents/prompts/crews/c4po/roles/chief-reliability-officer.yaml |
| Repo Steward            | c4po.repo-steward              | docs/09-ai-agents/prompts/crews/c4po/roles/repo-steward.yaml              |
| Architecture/Security   | c4po.chief-security-officer    | docs/09-ai-agents/prompts/crews/c4po/roles/chief-security-officer.yaml    |
| Docs Lead (if assigned) | c4po.docs-lead                 | docs/09-ai-agents/prompts/crews/c4po/roles/docs-lead.yaml                 |
| QA Lead (if assigned)   | c4po.qa-lead                   | docs/09-ai-agents/prompts/crews/c4po/roles/qa-lead.yaml                   |

## 7) Dependencies and Interfaces

Cross-team Dependencies (must identify owners)

- #{dep_1_team}: #{dep_1_desc}
- #{dep_2_team}: #{dep_2_desc}

Repo/Internal Interfaces

- #{iface_1}
- #{iface_2}

## 8) Acceptance and Exit Criteria

- #{accept_1}
- #{accept_2}
- #{accept_3}

## 9) Communication Cadence

- Weekly stakeholder update (link to dashboard)
- Decision log updated in dashboard.md
- Risk triage: #{cadence_risk}

## 10) Handoffs and Delegation

- Technical deep-dives → c4po.architect
- Repo/CI policy changes → c4po.repo-steward
- Release timing/conflicts → c4po.release-manager
- Security escalations → c4po.chief-security-officer
