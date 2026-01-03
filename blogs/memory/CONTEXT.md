# Blog Context & Patterns

**Purpose**: Track decisions, learnings, and patterns across blog writing workflows

---

## Blog Types & Purposes

### 📱 LinkedIn (`linkedin/`)
- **Audience**: Public professional network
- **Tone**: Thought leadership, industry insights
- **Frequency**: Ad-hoc, strategic posts
- **Length**: 1300-2000 words or short-form (< 500 words)

### 📄 OCI Internal Blog (`oci_internal_blog/`)
- **Audience**: Oracle internal (SharePoint)
- **Tone**: Technical, informative, educational
- **Topics**: GPU/AI infrastructure, cloud technology, team updates
- **Frequency**: Monthly or as needed

### 💬 Slack Posts (`slack/`)
- **Audience**: Team/organization
- **Tone**: Casual, informative, motivational
- **Format**: Weekly updates, Monday motivation, Friday reflections
- **Frequency**: Weekly

---

## Recent Decisions (Oct 2025)

### Directory Structure Standardization
- **Decision**: All blog types follow same structure: docs/, research/, date folders
- **Rationale**: Consistency, easier navigation, clear workflow
- **Date**: 2025-10-05

### Date Folder Format
- **Format**: `MM-DD-YYYY/`
- **Example**: `10-07-2025/`
- **Rationale**: Sorts chronologically, clear at a glance

### Research Workflow
- **Process**: PDF/Word docs → docs/ → Convert to markdown → research/
- **Tools**: Claude Code Read tool for PDF extraction
- **Naming**: Keep original filenames for traceability

---

## Content Themes & Topics

### OCI Internal Blog Themes
1. AI/GPU Infrastructure (GB200, NVIDIA tech)
2. Leadership & Management
3. Cloud Technology Trends
4. Team Culture & Development

### LinkedIn Themes
1. AI Compliance & Governance
2. Technology Leadership
3. Cloud Infrastructure
4. Regional Tech Ecosystems (SADC, Mauritius)

### Slack Themes
1. Weekly Progress Updates
2. Leadership Insights
3. Team Recognition
4. Technical Quick Tips

---

## Lessons Learned

### What Works
- ✅ Research phase with multiple sources before writing
- ✅ Converting PDFs to markdown for easier reference
- ✅ Date-based organization for tracking timelines
- ✅ Separating ideas, research, and drafts

### What to Improve
- 🔄 Need better tracking of work-in-progress
- 🔄 Archive completed work to reduce clutter
- 🔄 Cross-link related content across blog types

---

## Quick Tips

### Starting a New Blog Post
1. Add idea to `ideas.md`
2. Create date folder `MM-DD-YYYY/`
3. Gather source materials in `docs/`
4. Convert to markdown in `research/`
5. Draft in date folder
6. Review and publish

### Converting Research
```bash
# Pattern for Claude Code
"Convert PDF in docs/ to markdown in research/"
```

### Managing Memory
- Update `CURRENT_WORK.md` weekly
- Archive completed projects to `ARCHIVE.md`
- Update `CONTEXT.md` when changing workflows
