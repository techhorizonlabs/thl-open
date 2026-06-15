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

### 2026-06-15 (later still) — hardening, drawn from a competitor teardown
Studied a mature same-category plugin (Akii's SEO/AEO/GEO optimizer) and adopted the
on-brand parts (honest sourcing, provenance, a CI gate) while deliberately skipping its
telemetry/CTA growth machinery.
- **CI validator** — `scripts/validate.sh` + `.github/workflows/validate.yml`: validates
  the manifests + version lockstep, skill frontmatter, resolving local links,
  no-login/no-telemetry posture, a client-name/secret leak-check, and a skill
  trigger-phrase-overlap warning. A second CI job typechecks `audit-report-kit`.
- **[`docs/SOURCES.md`](docs/SOURCES.md)** — grounds the method in primary sources
  (Google AI Optimization Guide, the KDD 2024 GEO paper, Schema.org, the llms.txt
  proposal, crawler-operator docs, Cloudflare) with an explicit "what we don't claim."
- **Provenance tags** — `[scan]` / `[partial-scan]` / `[heuristic]` / `[unmeasured]` are
  now part of the GEO Method's scoring discipline, the `geo-audit` output template, the
  worked example, and authoring-standard P7, with the rule "emit `—`, never a number,
  when unmeasured." `audit-report-kit` gained an optional `provenance` field + null-score
  rendering (the committed sample sets none, so the sample PDF is unchanged).
- **Governance** — `SECURITY.md` (private disclosure + the no-telemetry stance),
  `.github/ISSUE_TEMPLATE/`, and a hardened plugin-install path in the README (full
  `https://` URL, two-separate-commands caveat).

### 2026-06-16 — improvements surfaced by a live dogfood audit
Ran the whole package end to end on a real site; these are the gaps that run exposed.
- **Provenance is now intrinsic to every dimension skill.** Added the
  `[scan]/[partial-scan]/[heuristic]/[unmeasured]` tag (and "emit `—`, not a number")
  to all seven sub-skills' output sections (`geo-citability`, `-content`, `-schema`,
  `-technical`, `-platform-optimizer`, `-brand-mentions`, `-crawlers`) — previously only
  the orchestrator carried it, so standalone runs lost it.
- **Subagent return contract** (geo-audit Phase 2): every subagent must return the
  orchestrator's named dimensions + a provenance tag, and **not** invent its own blended
  sub-composite or weights. `geo-ai-visibility` now returns AI Citability and Brand
  Authority as two separate scores (the composite weights them 25% vs 20%).
- **New business type: Professional / financial services (YMYL)** in `geo-audit`, with
  its schema (`FinancialService`/`ProfessionalService`/`Person`) + E-E-A-T expectations
  (displayed credentials, regulatory IDs) and an **entity-reconciliation** step (legal
  entity vs trading/brand name) — also added to the audit checklist.
- **`audit-report-kit`** — `generateOrgJsonLd` now takes a `type` (Organization /
  LocalBusiness / FinancialService / ProfessionalService) so the deliverable's schema
  matches the audit's own recommendation; the report `summary` is now a field instead of
  hardcoded boilerplate. Both default to prior behaviour, so the committed sample is
  unchanged.

### Queued (next pass)
- Replace the suite's internal PDF generator with `tools/audit-report-kit` end to end.
- Resolve cross-skill reference paths so the orchestrator's sub-skill links always resolve.
- Add a second and third frozen eval fixture (different verticals) to widen regression coverage.
