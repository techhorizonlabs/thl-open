# Changelog

## THL improvements to the forked GEO suite

The `skills/geo*` suite is an improved fork of
[geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude) by Zubair Trabzada
(MIT — see [`NOTICE.md`](NOTICE.md)). Changes Tech Horizon Labs has made on top:

### 2026-06-15
- **De-rotted** baked-in dates / time-sensitive facts from skill bodies (they go stale and
  read as wrong months later).
- **Relativized** machine-specific script paths (`~/.claude/skills/...` → `scripts/`) so the
  skills work on any machine and on project-level installs.
- **Integrated THL-original tools into the audit flow:**
  - `geo-audit` now references **`agent-readiness-scan`** (THL-original) for an independent
    Cloudflare 0–100 benchmark alongside the dimensional composite.
  - `geo-audit` now references **`tools/audit-report-kit`** (THL-original) as the
    branded-PDF + JSON-LD deliverable layer.
- **Added** the [THL GEO Method](docs/THL-GEO-METHOD.md) (orchestration of the three layers)
  and a copy-able [audit checklist](skills/geo-audit/references/thl-audit-checklist.md)
  (scoring + cross-check QA).
- **Split the over-length skills** into progressive-disclosure `references/`, keeping each
  `SKILL.md` as a tight orchestration layer and moving rubrics, output templates, and reference
  data one level down:
  - `geo-brand-mentions` 480 → 123 lines (`references/platforms.md`, `output-template.md`, `research.md`)
  - `geo-technical` 448 → 69 lines (`references/audit-categories.md`, `output-template.md`)
  - `geo-llmstxt` 432 → 111 lines (`references/spec.md`, `output-template.md`)

### 2026-06-15 (later) — adoption + credibility layer
- **Added [`examples/`](examples)** — a prompt cheat-sheet for every skill plus a worked
  end-to-end audit on a fictional broker (numbers consistent with the sample report and
  the committed `harborview.jsonld`).
- **Published the [THL Skill-Authoring Standard](docs/SKILL-AUTHORING-STANDARD.md)**
  (P1–P10 + the security rule + a pre-publish gate) and baked its checklist into
  [`CONTRIBUTING.md`](CONTRIBUTING.md) as the PR gate.
- **Packaged as a Claude Code plugin** — `.claude-plugin/marketplace.json` +
  `plugin.json`, so the whole suite installs via
  `/plugin marketplace add techhorizonlabs/thl-open`.
- **Added [`evals/`](evals)** — the eval-harness shape (frozen sites, expected ranges,
  must-flag findings, tier-aware runs) with one fictional worked fixture. The real
  client regression set stays proprietary.
- **Added [`docs/HOW-WE-COMPARE.md`](docs/HOW-WE-COMPARE.md)** — an honest landscape
  comparison (incl. where alternatives like GEO Optimizer are ahead) and the permissive
  building blocks worth adopting, with licence traps flagged.

### Queued (next pass)
- Replace the suite's internal PDF generator with `tools/audit-report-kit` end to end.
- Resolve cross-skill reference paths so the orchestrator's sub-skill links always resolve.
- Add a second and third frozen eval fixture (different verticals) to widen regression coverage.
