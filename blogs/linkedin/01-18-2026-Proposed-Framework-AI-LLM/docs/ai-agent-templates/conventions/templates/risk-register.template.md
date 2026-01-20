# #{initiative} — Risk Register (Chief of Staff View)

Owners: #{owners}  
Last Updated: #{date}  
Scope: End‑to‑end risks for #{initiative} across client, ingestion/streaming, data store, query/NLQ, UI, and ops.

Note: Use canonical icon legend and schemas in [docs/12-conventions/status.md](../../12-conventions/status.md)

## Legend

- RAG: 🟢 (on track), 🟡 (watch/plan), 🔴 (blocker)
- Sev: 1 (critical), 2 (high), 3 (medium), 4 (low)
- Likelihood: H (high), M (medium), L (low)

## Summary

- Risk posture: #{risk_posture_summary}
- Cadence: #{cadence} (e.g., twice weekly in triage)
- Rollout posture: #{rollout_posture} (e.g., feature flags + kill switch; internal-only if applicable)

## Top Risks (Active)

| ID    | Risk       | RAG       |       Sev | Likelihood | Owner       | Mitigation       |       ETA | Triggers/Watch |
| ----- | ---------- | --------- | --------: | :--------: | ----------- | ---------------- | --------: | -------------- |
| R-001 | #{r1_desc} | #{r1_rag} | #{r1_sev} |  #{r1_lh}  | #{r1_owner} | #{r1_mitigation} | #{r1_eta} | #{r1_trigger}  |
| R-002 | #{r2_desc} | #{r2_rag} | #{r2_sev} |  #{r2_lh}  | #{r2_owner} | #{r2_mitigation} | #{r2_eta} | #{r2_trigger}  |
| R-003 | #{r3_desc} | #{r3_rag} | #{r3_sev} |  #{r3_lh}  | #{r3_owner} | #{r3_mitigation} | #{r3_eta} | #{r3_trigger}  |

## Contingencies and Escalation

- #{contingency_1}
- #{contingency_2}
- #{contingency_3}

## Open Actions

- [ ] #{action_1} — Owner: #{action_1_owner} — ETA #{action_1_eta}
- [ ] #{action_2} — Owner: #{action_2_owner} — ETA #{action_2_eta}
- [ ] #{action_3} — Owner: #{action_3_owner} — ETA #{action_3_eta}

## Monitoring and Alerts

- Client metrics: #{mon_client}
- Streaming/Flink: #{mon_stream}
- Query/NLQ: #{mon_query}
- Other: #{mon_other}

## Decision Log Pointers

- #{decision_link_1}
- #{decision_link_2}

## Notes

- Status icons per [status.md](../../12-conventions/status.md)
- For internal-only tools, consider privacy risks lower but maintain allow-lists, hashing/bucketing where practical.
