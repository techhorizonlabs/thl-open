# THL Open

Open-source building blocks from [Tech Horizon Labs](https://techhorizonlabs.com) — the parts of our Claude-native GTM + AI-visibility stack that are genuinely ours and genuinely reusable.

The full methodology — how we run a complete client audit, score it, and turn it into an engagement — is our paid work and isn't here. The moat is the data, the evals, and the playbooks, not the prompts.

## What's inside

### `skills/agent-readiness-scan` — a Claude Code skill
Turns Cloudflare's public [`isitagentready.com`](https://isitagentready.com) check into **audit-grade artifacts**: a fixed-schema CSV, the 0–100 score, and the raw evidence behind it.

```bash
cp -R skills/agent-readiness-scan ~/.claude/skills/
```
See [`SKILL.md`](skills/agent-readiness-scan/SKILL.md).

### `tools/audit-report-kit` — a TypeScript report generator
Turns an AI-visibility / GEO audit's JSON into a polished, branded **client PDF** (react-pdf) plus compile-checked **JSON-LD** (schema-dts). See [its README](tools/audit-report-kit/README.md).

## Why so small?

We open-source only what's **ours**. Some skills we run internally are third-party suites we don't relicense, and the rest is proprietary methodology. This repo grows as we build more original, shareable utilities.

## License

[MIT](LICENSE) — Tech Horizon Labs. Use it, fork it, ship it.

---

*By Tech Horizon Labs — Claude-native GTM + AI-visibility infrastructure, built on Cloudflare.*
