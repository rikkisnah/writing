document_type: guide-hub
topic: getting-started
audience: [developers, ai-agents users, prompt-engineers]
owners: Compute Admin UI
version: 1.0.0
created_date: 2025-11-17
updated_date: 2025-11-17
repo_root: {{repo_root}}
product_name: Compute Admin UI
org_name: OCI Compute
dependencies: []

# Compute Admin UI — Getting Started Hub

Purpose
This hub provides the fastest paths to get productive:

- Developers: run, build, test, and lint the UI locally.
- AI Agents users: locate c4po crew prompts, seed roles/templates, and run workflows safely.

Prerequisites

- Node.js 18.18.0 (nvm use reads .nvmrc)
- npm 8+ (bundled with Node 18)
- Git
- macOS/Linux/WSL (Windows PowerShell supported via WSL recommended)
- IDE: VS Code (recommended)

Quick links

- Developer Quickstart (10–15 min): ./dev-quickstart.md
- Run/Build/Test scripts reference: ./dev-run-build-test.md
- AI Agents Quickstart (c4po crews): ./ai-agents-quickstart.md
- Tutorial: docs/02-tutorials/tutorial-getting-started-dev-run-2025-11-12-v1.md
- How-To (c4po crew workflows): docs/03-how-to/howto-use-c4po-crew-workflows-2025-11-17-v1.md
- Scripts & tasks reference: docs/05-reference/ref-build-test-scripts.md
- Environment variables reference: docs/05-reference/ref-environment-variables.md
- Status icon/badge legend: docs/12-conventions/status.md

Status snapshot (see docs/12-conventions/status.md)
| Area | Status | Owner | Notes |
|---|---:|---|---|
| Developer Onboarding | ⏳ | UI Eng Lead | Initial docs landing created; adding deep links |
| AI Agents Onboarding | ⏳ | Docs/PromptOps | Crew quickstart drafted; workflows cross-linked |

Index (this section)
| Doc | Audience | Purpose | Status |
|---|---|---|:---:|
| dev-quickstart.md | Developers | Fastest path to run app locally (clone → nvm use → npm ci → npm start) | ⏳ |
| dev-run-build-test.md | Developers | Explain npm scripts for run, build, test, lint; artifacts and coverage | ⏳ |
| ai-agents-quickstart.md | AI Agents/PromptOps | Locate c4po crew roles/templates, seed script, and workflow how-to | ⏳ |

Conventions and safety

- Diátaxis: Follow the docs hub orientation (docs/index.md) and ADR 0001 (docs/06-decisions/0001-adopt-diataxis.md).
- Status icons: Use the canonical legend and schemas (docs/12-conventions/status.md). Include a mini legend or link on the first page of any executive-facing doc.
- Repo-root variable: Never hardcode local paths. Use {{repo_root}} when authoring prompts or examples that require a repository root.
- Internal safety: Do not include secrets or new internal URLs. Reuse only repository-provided links.

Local validation (lint)

- Run markdown style and link checks locally (no CI changes required):
  - Style (markdownlint-cli2): npx -y markdownlint-cli2 "docs/01-getting-started/\*_/_.md"
  - Link check (lychee, optional): npx -y lychee@latest --no-progress --verbose docs/01-getting-started
- See docs/11-metadata/validation-and-maintenance.md for repository-wide validation guidance.

Next steps

- Developers: Start with ./dev-quickstart.md, then ./dev-run-build-test.md.
- AI Agents users: Start with ./ai-agents-quickstart.md, then follow the How-To for crew workflows.
