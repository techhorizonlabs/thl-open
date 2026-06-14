---
name: agent-readiness-scan
description: Use when a client audit, GEO/AI-visibility snapshot, or remediation re-scan needs the Cloudflare agent-readiness score from isitagentready.com — e.g. Theo client audits, "is the site agent-ready", markdown negotiation / MCP / llms.txt / Content-Signal checks, or tracking score deltas after Tier 0/1 fixes.
metadata:
  version: 1.0.0
  origin: extracted from production GEO-audit + agent-readiness remediation sessions
---

# Agent-Readiness Scan (isitagentready.com)

Produce the official Cloudflare agent-readiness result for a domain as audit-grade artifacts: fixed-schema CSV + raw evidence + the 0-100 score.

## Critical facts (learned the hard way)

1. **Two sources, both required:**
   - `POST https://isitagentready.com/api/scan` body `{"url":"https://<domain>"}` → full JSON (level, levelName, per-check status + embedded request/response evidence, nextLevel remediation prompts + skillUrls). **No numeric score in the JSON.**
   - **The 0-100 score renders only in the web UI.** Playwright-navigate to `https://isitagentready.com/<host>` and read the score dial: an `<svg>` carrying `aria-label="Overall score: N out of 100"`. **Never `wait_for` that text** — it's an attribute, not visible text (text-waits time out). Take a page snapshot or evaluate `document.querySelector('[aria-label*="Overall score"]')`. A fresh "Last scanned" timestamp = results are rendered (the step-1 API POST itself refreshes the scan, so no Scan click is normally needed). Without the 0-100 you cannot track deltas (e.g. a site improving 21→43 after fixes).
2. **Don't freeze the checklist.** The scanner evolves (new checks appear). Emit whatever `.checks` returns, mapped through the fixed CSV schema — never hand-author check rows.
3. **Scored vs supplementary.** llms.txt, llms-full.txt, security.txt are NOT scored by Cloudflare but Theo audits track them — they go in `Supplementary (not scored)` rows from curl probes, never mixed into scored categories.
4. **Commerce is informational** unless `isCommerce` is true — one `NOT CHECKED` row, "does not affect score".

## Workflow

```bash
scripts/run_scan.sh https://<domain> <outdir>/raw-data
```
Then get the official score via Playwright (see Critical fact 1 for the exact method). Save the page snapshot to `raw-data/isitagentready_<client-slug>_snapshot.txt` (client slug, e.g. `acme` — matches your audit config slug). Then:
```bash
python3 scripts/scan_to_csv.py \
  <outdir>/raw-data/iar_scan.json --score <N> --out <outdir>/csv-base-data/agent_readiness_checks.csv
```
(`csv-base-data/` is the Theo full-pack convention; scoped snapshots have used plain `csv/` — either is fine, pass `--out` explicitly.)

## CSV schema (fixed — cross-client comparability depends on it)

`category,check,result,detail,source`
- Row 1: `OVERALL,Agent-readiness score,<N>/100 - Level <L> <Name>,<p> pass / <f> fails; Commerce <note>,isitagentready.com/<host> (Cloudflare) <YYYY-MM-DD>`
- Category names carry computed tallies, e.g. `Discoverability (1/4)` — denominators come from whatever the scanner returns that run (it grows new checks), counting scored checks only (pass/fail), never `neutral` ones.
- Results: `PASS` / `FAIL` / `NOT CHECKED` (scanner statuses other than pass/fail — e.g. `neutral`, `skip` — map to NOT CHECKED and are excluded from tallies); detail = scanner `message` verbatim (commas stripped/quoted)
- Supplementary rows last, `PRESENT`/`ABSENT` from curl.

## Report section + remediation

Headline format: `Agent readiness (Cloudflare isitagentready.com) | **N/100 — Level L "Name"** (p pass, f fails)`. For remediation, lift `nextLevel.requirements[].prompt` verbatim (they're copy-paste fix prompts with spec URLs); the common Tier 0/1 fix pattern is a markdown negotiation map, robots Content-Signal, link headers, llms-full.txt, and security.txt.

## Common mistakes

| Mistake | Fix |
|---|---|
| Reporting only Level, no 0-100 | UI aria-label is the only score source — Playwright step is not optional |
| Inventing/renaming categories ("Protocol Discovery") | Use the mapping in scan_to_csv.py; `discovery` → `API Auth MCP & Skill Discovery` |
| WebFetch on isitagentready.com/<host> | JS app — returns shell, no results. API or Playwright only |
| curl-only assessment without the official scan | curl corroborates; the scan JSON is the authority for scored checks |
| Mixing llms.txt into scored categories | Supplementary, not scored |
