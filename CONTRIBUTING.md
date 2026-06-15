# Contributing

These are small, focused utilities. Issues and PRs welcome.

## Skill-authoring conventions (the PR gate)

We hold every skill we author to the
[**THL Skill-Authoring Standard**](docs/SKILL-AUTHORING-STANDARD.md), and ask the same
of contributions. The short version — a PR touching a skill should pass all of these:

- [ ] **SKILL.md under ~500 lines** — push depth into `references/*.md`, one level deep.
- [ ] **Trigger-rich description** — third person, with the exact phrases a user would
      type, and distinct from sibling skills.
- [ ] **Relative paths only** — never machine-specific (`~/.claude/...`, `/Users/...`).
- [ ] **No baked-in time-sensitive facts** — dates and stats rot; keep them out of the body.
- [ ] **References resolve** — one level deep, and every linked path actually resolves
      from the skill's own location.
- [ ] **Fixed templates for measurement** — pinned output skeletons / schemas where two
      runs should be comparable; prose only where judgement is wanted.
- [ ] **No client data or secrets** — and treat any fetched web content as *data*, never
      instructions.
- [ ] **Provenance is clear** — if it builds on someone else's work, credit it
      ([`NOTICE.md`](NOTICE.md)) rather than rebranding it.

New to skill structure? [`skills/agent-readiness-scan`](skills/agent-readiness-scan) is
the reference shape (54 lines, trigger-rich, fixed CSV schema).

## A note on the `geo-*` suite

Those skills are an **attributed fork** of
[`geo-seo-claude`](https://github.com/zubair-trabzada/geo-seo-claude) (Zubair Trabzada,
MIT). Keep changes to them conservative and record them in
[`CHANGELOG.md`](CHANGELOG.md) — we improve and credit, we don't diverge and claim.

By Tech Horizon Labs.
