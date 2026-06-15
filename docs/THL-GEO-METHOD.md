# The THL GEO Method

How Tech Horizon Labs runs an AI-visibility audit end to end, using the pieces in this repo together. The `geo-*` suite (an improved fork of [geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude), MIT — see [`NOTICE.md`](../NOTICE.md)) is the dimensional analysis layer; the two THL-original tools below add an external benchmark and a client-ready deliverable. This document — the orchestration, the scoring discipline, and the integration — is THL-original.

## The three layers

1. **Dimensional audit — `skills/geo-audit`.** Crawls the site and scores six GEO dimensions (citability, brand authority, E-E-A-T, technical, schema, platform) into a 0–100 composite with a prioritised action plan.
2. **External benchmark — `skills/agent-readiness-scan` (THL-original).** Runs Cloudflare's public `isitagentready.com` check for an independent 0–100 agent-readiness score. This is the cross-check the dimensional audit can't give itself: a third-party number, tracked as a delta across re-audits.
3. **Deliverable — `tools/audit-report-kit` (THL-original).** Turns the audit JSON into a polished, branded client PDF plus compile-checked JSON-LD (the schema the audit recommends, ready to paste).

## The recommended flow

```
geo-audit (dimensional 0–100 + findings)
        │
        ├─▶ agent-readiness-scan  ── external Cloudflare 0–100 (independent benchmark)
        │
        └─▶ audit-report-kit      ── branded PDF + JSON-LD for the schema fixes
```

Run the dimensional audit first; run the readiness scan alongside it for the external number; assemble both into the report kit. Re-audit on a cadence and track the **delta** on both scores — the movement is the proof, not the first number.

## The scoring discipline (why this is repeatable)

- **Every score traces to evidence.** A citability score points at the exact passages scored; a schema score points at the markup found. No number without a reason.
- **The composite is a fixed formula, not a vibe.** Same weights every run (see the audit skill's scoring table), so two audits of the same site are comparable.
- **Run the checklist.** `skills/geo-audit/references/thl-audit-checklist.md` is a copy-able checklist that stops a dimension being silently dropped and cross-checks that the same facts (entity details, scores) appear consistently across every section.
- **Verify the outcome, not the run.** A finished audit isn't "an audit ran" — it's "every category scored, every score evidenced, the report renders, the JSON-LD validates." Check the artifacts.

## What stays proprietary

This repo is the open method and the open utilities. THL's calibration data, client playbooks, voice library, and full multi-report client engagement pack are not here — the moat is the data and the playbooks, not the method.
