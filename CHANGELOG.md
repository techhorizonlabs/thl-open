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

### Queued (next pass)
- Split the over-length skills (`geo-brand-mentions`, `geo-technical`, `geo-llmstxt`) into
  `references/` per the [authoring standard](https://techhorizonlabs.com) so each SKILL.md
  body stays under ~500 lines.
- Replace the suite's internal PDF generator with `tools/audit-report-kit` end to end.
- Resolve cross-skill reference paths so the orchestrator's sub-skill links always resolve.
