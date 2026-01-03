# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

A content creation and blog management system for writing, publishing, and organizing professional content across multiple platforms: LinkedIn, OCI internal SharePoint, Slack team updates, and podcast preparation.

## Directory Structure

```
writing/blogs/
├── linkedin/           # Public thought leadership posts
├── oci_internal_blog/  # Oracle internal SharePoint articles
├── slack/              # Weekly team updates (Monday posts)
├── sica_podcast/       # Podcast prep materials and templates
├── articles/           # External publication content
├── ideas/              # Content ideas and inspiration
├── memory/             # Work tracking (CURRENT_WORK.md, CONTEXT.md, ARCHIVE.md)
└── to-read/            # Reading queue
```

Each blog type uses a consistent subdirectory pattern:
- `docs/` - Source materials (PDFs, Word docs)
- `research/` - Converted markdown from docs
- `MM-DD-YYYY/` - Date-based working folders
- `ideas.md` - Content queue and ideas

## Content Types

### Slack Weekly Posts (`slack/`)
- **Audience**: AI Compute organization channel
- **Frequency**: Weekly (Monday posts)
- **Format**: Three sections - A) Technical, B) Career Progression, C) Random Quips
- **Guidelines**: ~250-300 words, no emoticons, open with quote, authentic tone
- See `slack/README.md` for full format specification and templates

### LinkedIn (`linkedin/`)
- **Audience**: Public professional network
- **Length**: 1300-2000 words (articles) or <500 words (posts)
- **Themes**: AI compliance, technology leadership, regional tech ecosystems

### OCI Internal Blog (`oci_internal_blog/`)
- **Audience**: Oracle internal (SharePoint)
- **Topics**: GPU/AI infrastructure, cloud technology, leadership
- **Format**: Technical, educational content

### SICA Podcast (`sica_podcast/`)
- **Purpose**: Podcast preparation and guest research
- **Key files**: `sica-podcast-template.md`, `sica-podcast-process-guide.md`

## Writing Workflow

The repository uses "Curious Penguins Craft Great Golden Content" workflow:
1. **C**hatGPT - Frame topic and outline
2. **P**erplexity - Research and gather sources
3. **C**laude - Generate first draft in markdown
4. **C**hatGPT - Structure and synthesis
5. **G**emini + **G**rok - Fact verify + polish tone
6. **C**opilot - Platform prep for publishing

## Common Tasks

### Creating New Content
```bash
# Create date folder for new post
mkdir blogs/{blog_type}/MM-DD-YYYY

# Standard subfolder for research materials
mkdir blogs/{blog_type}/MM-DD-YYYY/docs
mkdir blogs/{blog_type}/MM-DD-YYYY/extracted
```

### Work Tracking
- Update `memory/CURRENT_WORK.md` when starting new content
- Archive completed work to `memory/ARCHIVE.md`
- Track workflow decisions in `memory/CONTEXT.md`

## Platform Paths

- **macOS**: `/Users/rkisnah/src/rikkisnah/writing/`
- **Ubuntu**: `/mnt/data/src/rikkisnah/writing/`

## Key Terminology

- **GB200**: NVIDIA Grace Blackwell 200 GPU architecture
- **NVL72**: 72-GPU interconnected configuration
- **CXL**: Compute Express Link (memory fabric protocol)
- **HBM**: High Bandwidth Memory
- **SICA**: Internal podcast series name
