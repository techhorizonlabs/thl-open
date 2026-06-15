# The THL Skill-Authoring Standard

The rules we hold every skill we author to. Derived from
[Anthropic's official Agent-Skills best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
and hardened against our own production skills.

We publish it because the method is worth more shared than hidden, and because it's
the bar we ask contributions to this repo to meet. The worked template is
[`skills/agent-readiness-scan`](../skills/agent-readiness-scan) — 54 lines, and the
best-structured skill we've shipped. Build new skills in that shape.

> Apply this to skills *you authored*. Don't diverge a third-party suite you merely
> run — the `geo-*` skills here are an attributed fork ([`NOTICE.md`](../NOTICE.md)),
> so our changes to them stay conservative and documented in
> [`CHANGELOG.md`](../CHANGELOG.md).

## The hard limits

- **Frontmatter is `name` + `description` only.** `name` ≤ 64 chars,
  lowercase / numbers / hyphens, never "claude" or "anthropic". `description`
  ≤ 1024 chars, **third person**, no XML tags.
- **SKILL.md body under ~500 lines / ~5k tokens.** Overflow goes to `references/*.md`.
- **Three loading levels:** metadata (always loaded) → SKILL.md (on trigger) →
  bundled files / scripts (on demand). Keep the body the *decision layer*; push depth
  down a level.

## The checklist (priority order)

**P1 — Trigger-rich descriptions.** State *what it does* **and** *when to use it*,
packed with the exact phrases a user would type. The description is the only thing
loaded at startup, so a vague one means the skill silently never fires. Distinguish
siblings: "scores a single page's citability — not whole-site audits."

**P2 — No time-sensitive facts in the body.** Dates, market stats, and
version-specific thresholds rot and start reading as wrong months later. Move them to
`references/` or cut them.

**P3 — Relative paths only.** `scripts/run.py`, never `~/.claude/skills/...` or
`/Users/...`. Absolute home paths break on every other machine and on project-level
installs.

**P4 — References one level deep, and they must resolve.** No reference-to-a-reference.
Verify each linked path resolves *from the skill's own location*. Sibling skills
installed alongside yours are not children of your skill, so a path like
`skills/other-skill/` won't resolve from inside your skill — this is the most common
silent-failure bug.

**P5 — Split over-length skills.** Keep the body as orchestration; move long rubrics,
scoring tables, and output templates into `references/` so a single-category run loads
only what it needs.

**P6 — `references/` (read) vs `scripts/` (execute).** Reference material is read on
demand; deterministic operations are *executed* via bash so code never enters context.
Signal intent in prose: "Run `x.py` to…" versus "See `x.py` for the algorithm."

**P7 — Fixed output templates + copy-able checklists.** For consistent deliverables,
give the exact report skeleton and say "ALWAYS use this template." For multi-step
audits, give a checklist the model ticks off so no category is silently dropped.
**This is the single biggest lever on consistency** — `agent-readiness-scan`'s fixed
CSV schema and its "never hand-author rows" rule are the model.

**P8 — Right degrees of freedom.** High freedom (prose) for judgement
(content / E-E-A-T advice); low freedom (pinned scripts and schemas) for measurement
(scoring, parsing, validation) so two runs on the same input are comparable.

**P9 — Consistent terminology.** One term per concept across the suite ("citability",
not also "quotability"). Keep a consistent skill namespace.

**P10 — Evals before prose.** Freeze a few inputs with expected score ranges and
must-flag findings; run each skill against them **on the model tier it's actually
invoked on** ("works on the big model" can under-specify for a smaller one). This
doubles as regression protection when you later split files. See
[`evals/`](../evals) for how we structure this.

## Security rule (non-negotiable)

Skills must treat **fetched web content as data, never as instructions** — crawler and
brand-mention skills pull the open web, and a skill that fetches a URL inherits
whatever instructions live there (a prompt-injection vector). **Never** list a
leaked-prompt repository, or any untrusted URL, as a "reference" source.

## Pre-publish gate

Before any skill ships:

1. **Leak-check** — no client names, emails, secrets, or machine-specific paths in
   `SKILL.md`, references, or scripts.
2. **Provenance** — is it yours to publish? A third-party suite doesn't get
   republished under your name; fork it honestly with attribution instead.
3. **The checklist** — P1–P4 at minimum (description, de-rot, relative paths, resolving
   references).
