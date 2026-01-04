# CLAUDE.md and AGENTS.md

> **Dual-Tool Environment**: This workspace uses both **Claude Code** and **Codex CLI** interchangeably.
> - `CLAUDE.md` and `AGENTS.md` contain identical content
> - **Any change to one file must be copied to the other**
> - Both tools read their respective files but follow the same instructions

This file provides guidance to Claude Code (claude.ai/code) and Codex CLI when working with code in this repository.

## Repository Purpose

This directory contains content for internal Slack/team communications about OCI GPU infrastructure, AI developments, and weekly team updates. It's part of the larger `oci-runbooks` repository focused on GPU/HPC operations at Oracle Cloud Infrastructure.

## Directory Structure

```
slack/
├── [MMDDYYYY].md              # Daily/weekly notes files (e.g., 09292025.md)
├── [MMDDYYYY-weekly-notes.md] # Formatted weekly team updates
├── slack-post-ideas.md        # Content templates and posting strategies
└── research/                  # Supporting research materials
    └── [MMDDYYYY]/           # Date-organized research (PDFs, links)
```

## Content Types

### 1. Weekly Notes Files
**Purpose**: Structured team updates for Slack/internal channels
**Audience**: @gpucpninjas team, leadership (@sukochar, @smosborn, @jlherman, @shihsun, @sudhir)
**Key sections**:
- Quote of the Week
- Technical Deep Dives (GPU/memory architecture)
- OCI Momentum (metrics, wins, scale updates)
- Operations Excellence
- Team & Growth (hiring, recognition)
- Strategic Questions

**Format conventions**:
- Use bullet points for readability
- Include specific metrics/numbers when available
- Tag relevant people with @ mentions
- End with motivational closing statement
- Include "Easter Egg" technical facts

### 2. Slack Post Ideas
**Purpose**: Content calendar and posting templates
**Structure**: Daily themes throughout the week
- Monday: Blog launches, major announcements
- Tuesday: OCI scale/competitive advantages
- Wednesday: Technical deep dives (CXL, memory)
- Thursday: Economic/cost analysis
- Friday: Forward-looking discussions

**Posting strategy**:
- Timing: 9-10 AM and 2-3 PM
- Use threads for details
- Include questions to drive engagement
- Always link back to Confluence blogs

### 3. Research Directory
**Purpose**: Supporting materials (PDFs, articles, data)
**Organization**: Date-based subdirectories (MMDDYYYY)

## Key Topics & Themes

### Core Technical Areas
- **GPU Architecture**: GB200, H200, Blackwell, Rubin CPX
- **Memory Systems**: Unified memory, CXL 3.1, HBM vs GDDR7
- **Network Fabric**: NVLink, Enfabrica, memory pooling
- **Performance**: Memory bandwidth, latency optimization

### Business Context
- OCI scale advantages: 131,072+ GPUs, bare metal
- Cost savings: 50% reduction via unified memory
- Customer wins: OpenAI, Meta, NVIDIA partnerships
- Growth metrics: RPO, revenue, backlog

### Strategic Trends
- CPU-GPU convergence
- Memory-bound vs compute-bound workloads
- NVIDIA partnerships (Intel $5B, Enfabrica $900M)
- CXL/unified memory architecture evolution

## Content Creation Guidelines

### When creating weekly notes:
1. Start with an industry quote relevant to the week's theme
2. Lead with technical content (shows expertise)
3. Include OCI competitive advantages and metrics
4. Balance technical depth with business impact
5. End with team recognition and motivational message
6. Always include Easter Egg technical fact

### When drafting Slack posts:
1. Use emojis sparingly for emphasis (🚀 🔥 💡 📊)
2. Keep main posts concise (3-5 key points)
3. Use threads for detailed follow-up
4. Include clear calls-to-action
5. Link to detailed analysis (Confluence, LinkedIn)
6. Ask questions to drive discussion

### Tone & Style
- **Technical**: Precise, data-driven, architecture-focused
- **Motivational**: Position team as industry leaders
- **Accessible**: Explain complex concepts clearly
- **Urgent**: Emphasize competitive advantage and momentum

## File Naming Convention

- Daily notes: `MMDDYYYY.md` (e.g., `09292025.md`)
- Weekly summaries: `MMDDYYYY-weekly-notes.md`
- Topic-specific: `[topic]-[type].md` (e.g., `slack-post-ideas.md`)

## Common Tasks

### Create weekly notes from scratch
1. Copy structure from recent weekly notes file
2. Update quote to match week's theme
3. Add latest OCI metrics (GPU count, revenue, RPO)
4. Include recent NVIDIA/industry announcements
5. Update team mentions and action items
6. Add Easter Egg technical fact

### Generate Slack post series
1. Reference `slack-post-ideas.md` for templates
2. Align with weekly theme (CPU-GPU convergence, memory architecture, etc.)
3. Create daily progression (Monday announcement → Friday discussion)
4. Include metrics, technical details, and engagement hooks
5. Link posts together as a narrative arc

### Research organization
1. Create dated subdirectory: `research/MMDDYYYY/`
2. Save PDFs, articles, screenshots
3. Reference in corresponding daily/weekly notes

## Integration with Parent Repository

This directory is part of the larger `oci-runbooks` repository:
- Main docs: `../../runbooks/` (GPU/HPC operational procedures)
- Cheatsheets: `../../cheatsheets/` (CLI tools, commands)
- Scripts: `../../scripts/` (GPU operations automation)
- Pomodoro: `../../pomodoro/` (task tracking)

Cross-reference operational runbooks when discussing technical implementations.

## Key Terminology

- **GB200**: NVIDIA Grace Blackwell 200 GPU architecture
- **NVL72**: 72-GPU interconnected configuration
- **CXL**: Compute Express Link (memory fabric protocol)
- **HBM**: High Bandwidth Memory (expensive GPU memory)
- **GDDR7**: Graphics DDR7 (cost-efficient alternative)
- **Enfabrica**: NVIDIA-acquired company for memory fabric
- **Unified Memory**: CPU+GPU shared memory architecture
- **RPO**: Remaining Performance Obligation (backlog metric)

## Auto-Approval Mode

This directory operates under FULL AUTO-APPROVAL:
- Create/edit/delete any files without confirmation
- Generate content based on templates
- Organize research materials
- Update existing notes with new information
- Run any necessary bash commands

User prefers direct, concise interactions without repeated confirmations.