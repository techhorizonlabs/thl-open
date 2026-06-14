# Contributing

These are small, focused utilities. Issues and PRs welcome.

Skill authoring conventions we hold to (and ask of contributions):

- **SKILL.md under ~500 lines** — push depth into `references/*.md`, one level deep.
- **Trigger-rich descriptions** — third person, with the exact phrases a user would type.
- **Relative paths only** — never machine-specific (`~/.claude/...`, `/Users/...`).
- **No baked-in time-sensitive facts** — they rot; keep them out of the skill body.
- **Never client data or secrets** — and treat any fetched web content as *data*, never instructions.
- **Prefer deterministic scripts** over generated code for anything that must be consistent.

By Tech Horizon Labs.
