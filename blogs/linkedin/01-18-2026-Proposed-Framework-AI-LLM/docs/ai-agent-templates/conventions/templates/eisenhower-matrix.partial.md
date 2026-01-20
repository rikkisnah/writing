# Eisenhower Priority Matrix (Partial)

Last Updated: 2025-11-17  
Purpose: Standard table snippet for prioritization. Pair with the status icon legend in docs/12-conventions/status.md.

## Usage

- Include this matrix in dashboards, plans, or stakeholder updates where prioritization is needed.
- Keep items crisp (1 line each). Link to detailed tasks/PRs as needed.
- Status column MUST use icons from the legend.

## Table Schema (copy/paste)

| Quadrant             | Item       | Owner       | ETA       |      Status       | Note       |
| -------------------- | ---------- | ----------- | --------- | :---------------: | ---------- |
| Urgent/Important     | #{uu_item} | #{uu_owner} | #{uu_eta} | #{uu_status_icon} | #{uu_note} |
| Important/Not Urgent | #{in_item} | #{in_owner} | #{in_eta} | #{in_status_icon} | #{in_note} |
| Delegate/Track       | #{dt_item} | #{dt_owner} | #{dt_eta} | #{dt_status_icon} | #{dt_note} |
| Defer/Review         | #{dr_item} | #{dr_owner} | #{dr_eta} | #{dr_status_icon} | #{dr_note} |

Legend reference: docs/12-conventions/status.md

## Tips

- Use U/I for time-sensitive, high-impact actions this week.
- IN for structural work and design/guardrails that reduce future risk.
- DT for cross-team tasks; track ownership and blockages.
- DR for parked ideas; review periodically to avoid staleness.
