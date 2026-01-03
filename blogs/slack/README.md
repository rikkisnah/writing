# Slack Posts – Weekly Knowledge Sharing

## Overview

This directory contains weekly Slack posts shared with the AI Compute organization channel. Posts follow a structured three-section format designed to balance technical knowledge, career insights, and culture.

**Audience**: AI Compute team (organization-wide)
**Frequency**: Weekly (typically Monday posts)
**Format**: 3-section markdown posts
**Purpose**: Share operational knowledge, leadership insights, and team culture

## Post Structure

Each post contains three main sections:

### A) Technical – OCI AI/GPU Infrastructure
- Current technical initiatives, learnings, and breakthroughs
- Project updates, architecture decisions, infrastructure insights
- Operational procedures or best practices
- Resources, blog posts, or documentation relevant to the org
- **Goal**: Educate the broader team on technical depth and decision-making

### B) Career Progression – Leadership & Growth
- Leadership lessons and organizational insights
- How senior leaders approach problems and decisions
- Team dynamics, communication patterns, decision-making frameworks
- Professional development observations and principles
- **Goal**: Help SDEs understand leadership and grow their influence

### C) Random Quips – Culture & Light Moments
- Interesting articles, reads, or discoveries
- Cultural observations about tech and work
- Fun or lighter commentary
- Easter eggs or unexpected finds
- **Goal**: Build team culture and add personality

## Format Guidelines

### Opening
- **Quote**: Include an inspiring quote (often spiritual/wisdom-based, but not heavy biblical references)
- **Attribution**: Optional attribution (can be generic like "wisdom" or specific author)
- Quotes should resonate with the org's values: service, growth, excellence

### Sections
- Use headers clearly labeled **A)**, **B)**, **C)**
- Include 2-4 bullet points per section (or subsections for complexity)
- Add "Why this matters" or "Key Principle" callouts
- Include links when sharing resources, blog posts, or dashboards

### Closing
- 1-2 sentence synthesis or forward-looking statement
- Optional mentions: **To:** @channel, **CC:** specific people
- Optional sign-off: "Keep building, keep learning, keep shipping." or similar

### No emoticons
 - No emoticons in the message

### Word count 
~ 250-300 words

### Non AI content

The content must not look like AI Generated
Lower Predictability/Burstiness: "Review the following text and increase the 'burstiness' and 'perplexity' by replacing some common words with less common synonyms and varying the transitions between paragraphs."

Introduce Dialogue/Quotes: "Integrate two short, authentic-sounding quotes or pieces of dialogue into the text to break up the prose and add a human element."

Review and Rewrite: "Critique the following text for sections that sound too formulaic or robotic. Rewrite those specific parts to feel more spontaneous and engaging."
### Structure Example
```
# Rik's Weekly Notes – [DATE]

> "[Quote]" — [Attribution]

---

## A) Technical – [Topic]
[Subsections with bullets and links]

---

## B) Career Progression – [Topic]
[Subsections with bullets and insights]

---

## C) Random Quips – [Topic]
[Bullets with lighter commentary]

---

[Closing synthesis]

**To:** @channel
**CC:** [Optional mentions]
```

## Templates & Resources

- **[template-slack-post.md](template-slack-post.md)**: Template with placeholder structure
- **[CLAUDE.md](../CLAUDE.md)**: Full repository context

## Directory Organization

```
slack/
├── README.md                    # This file
├── template-slack-post.md       # Post template
├── CLAUDE.md                    # Repository context
├── docs/                        # Source materials (PDFs, references)
├── research/                    # Converted research materials
└── [MM-DD-YYYY]/               # Date-based folders for each post
    ├── slack_post.md           # Final post (or draft.md for WIP)
    └── README.md               # Optional: post metadata and notes
```

## Writing Tips

### Finding Content Ideas
- **Technical**: Recent project updates, infrastructure decisions, blog posts being written
- **Career**: Conversations with mentors, observations from WBRs and leadership meetings, team dynamics
- **Random**: Articles you've read, interesting patterns noticed, lighter moments

### Keeping Posts Balanced
- **Technical** shouldn't be overly deep or jargon-heavy—explain why it matters
- **Career** should be concrete observations, not generic advice
- **Random** should be genuinely interesting or funny, not forced

### Linking Resources
- Include Slack message links for team discussions
- Link to Confluence pages, JIRA dashboards, or SharePoint documents
- Reference blog posts or external articles with full context
- Use descriptive link text, not bare URLs

### Tone
- Professional but personable
- Authentic voice—share what you actually learned or found interesting
- Service-oriented—focus on helping others grow
- Humble—acknowledge gaps or complexity

## Post Examples

### Recent Posts (10-27-2025)
- **Technical**: Summary of OCI GPU First Principles Blog series
- **Career**: How work flows through Intake → WBR → Jira, with decision-making insights
- **Random**: NVIDIA GTC DC conference attendance

### Earlier Posts (09-30-2025)
- **Technical**: AI2 Compute blog launch and first article (Zettascale in Practice)
- **Career**: Manager vs. Leader distinction, leadership as service
- **Random**: N/A (focused on content)

## Quick Start

1. **Create date folder**: `mkdir blogs/slack/MM-DD-YYYY`
2. **Use template**: Copy `template-slack-post.md` to date folder as `slack_post.md`
3. **Fill sections**: Add technical topic, career insight, and random quip
4. **Add quote**: Write or find an inspiring opening quote
5. **Review & publish**: Check tone, links, and clarity before sharing to @channel

## Integration with Blog System

This directory is part of the broader `blogs/` system:
- Related: [LinkedIn posts](../linkedin/) (public, thought leadership)
- Related: [OCI Internal Blog](../oci_internal_blog/) (internal, educational)
- Meta: [Blog Memory](../memory/) (work tracking across all blog types)

See [blogs/README.md](../) for full blog system documentation.
