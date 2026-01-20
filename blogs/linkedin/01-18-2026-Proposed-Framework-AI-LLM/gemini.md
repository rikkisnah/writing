For enterprise or highly complex projects, the "Root Clutter" problem is real. Moving these files into a specialized directory is the cleanest way to scale. This pattern is increasingly referred to as the **AI-Native Repository Structure**.

Here is how you should organize a complex or enterprise-level repository:

### 📂 The `.ai/` Directory Structure

```text
root/
├── .ai/
│   ├── AGENT.md           # The primary "Master Rules" for all AI agents
│   ├── TASKS.md           # The global roadmap and feature backlog
│   ├── MEMORY.md          # Persistent knowledge/log of past decisions
│   ├── specs/             # Detailed technical blueprints
│   │   ├── auth-flow.md
│   │   └── api-design.md
│   └── rules/             # Sub-agent specialized rules
│       ├── test-agent.md  # Specific rules for writing Jest/Vitest tests
│       ├── docs-agent.md  # Rules for maintaining TSDoc/JSDoc
│       └── refactor.md    # Rules for clean code migrations
├── README.md              # Human-facing project overview
└── CONTRIBUTING.md        # Human-facing dev guidelines

```

---

### Why this works for Enterprise:

1. **Sub-Agent Specialization:** In a large codebase, one `AGENT.md` becomes too long and the AI loses focus (context drift). By splitting rules into `.ai/rules/`, you can tell the AI: *"When working on tests, follow the instructions in `.ai/rules/test-agent.md`."*
2. **The "Truth" for Multi-Agent Workflows:** If you have multiple developers using different AI tools (one on Cursor, one on GitHub Copilot CLI), they all reference the same `.ai/` folder as the **Single Source of Truth**.
3. **Spec-Driven Development:** For complex features, you don't just prompt and pray. You write a **`SPEC.md`** inside `.ai/specs/`. The AI reads the spec, updates the `TASKS.md`, and then writes the code.

---

### Critical "Bridge" Step

If you move your AI files into a subfolder like `.ai/`, most tools won't find them automatically. You must add a "pointer" file in the root.

**Create a file at the root named `.cursorrules` (for Cursor) or `AGENT.md` (for general) that simply says:**

> "All instructions, rules, and task tracking for this project are located in the `.ai/` directory. Please read `.ai/AGENT.md` first to understand the structure and guidelines of this repository."

---

### Summary of Enterprise Files

| File | Purpose in Large Teams |
| --- | --- |
| **`.ai/AGENT.md`** | Global constraints (e.g., "Must maintain 90% test coverage"). |
| **`.ai/MEMORY.md`** | Prevents "Regression Loops" where AI keeps suggesting a fix that previously failed. |
| **`.ai/specs/`** | Standardizes the design phase before a single line of code is written. |
| **`.ai/TASKS.md`** | Allows project managers to see AI progress without reading git diffs. |

**Would you like me to generate a specialized "Sub-Agent Rule" file (like a `.ai/rules/test-agent.md`) for your specific testing framework?**