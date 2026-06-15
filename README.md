# THL Open

Open-source building blocks from [Tech Horizon Labs](https://techhorizonlabs.com) for Claude-native GTM + AI-visibility work — a GEO/AI-visibility skill suite plus the THL-original tools we pair with it.

## What's inside

### GEO / AI-visibility skill suite — `skills/geo*`
A comprehensive set of Claude Code skills for Generative Engine Optimization: full GEO audits, citability scoring, AI crawler analysis, `llms.txt` generation, schema markup, brand-mention scanning, platform-specific optimization, technical SEO, content E-E-A-T, prospect tracking, proposals, and report generation.

> **Attribution.** These `geo-*` skills are an **improved fork** of [`geo-seo-claude`](https://github.com/zubair-trabzada/geo-seo-claude) by **Zubair Trabzada** (MIT — original license at [`skills/geo/LICENSE-geo-seo-claude`](skills/geo/LICENSE-geo-seo-claude)). Tech Horizon Labs' changes: removed baked-in dates / time-sensitive facts, relativized machine-specific paths, and wired the suite to the THL-original tools below. See [`NOTICE.md`](NOTICE.md).

### `skills/agent-readiness-scan` — THL-original
Turns Cloudflare's public [`isitagentready.com`](https://isitagentready.com) check into audit-grade artifacts (fixed-schema CSV + the 0–100 score + evidence). The companion to the GEO audit.

### `tools/audit-report-kit` — THL-original
Turns an audit's JSON into a polished, branded **client PDF** (react-pdf) + compile-checked **JSON-LD** (schema-dts). Use it as the report-generation layer for the GEO suite. See [its README](tools/audit-report-kit/README.md).

## Install

```bash
cp -R skills/geo skills/geo-llmstxt skills/geo-crawlers ~/.claude/skills/   # pick what you need
cp -R skills/agent-readiness-scan ~/.claude/skills/
```

## What's THL-original vs improved-fork

| Component | Status |
|---|---|
| `skills/agent-readiness-scan` | **THL-original** |
| `tools/audit-report-kit` | **THL-original** |
| `skills/geo*` | Improved fork of geo-seo-claude (Zubair Trabzada, MIT) — credited |

We keep that distinction honest: the GEO suite stands on someone else's good open-source work, improved and integrated; the readiness scan and report kit are ours end-to-end.

## License

[MIT](LICENSE) — Tech Horizon Labs for the THL-original parts; `skills/geo*` retain the original MIT (Zubair Trabzada) per [`skills/geo/LICENSE-geo-seo-claude`](skills/geo/LICENSE-geo-seo-claude). Use it, fork it, ship it.

---

*By Tech Horizon Labs — Claude-native GTM + AI-visibility infrastructure, built on Cloudflare.*
