# The THL GEO Method

How Tech Horizon Labs runs an AI-visibility audit end to end. This document — the framing, the orchestration, the scoring discipline — is THL-original. The `geo-*` suite it drives is an improved fork of [geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude) (MIT — see [`NOTICE.md`](../NOTICE.md)); the two THL-original tools add an external benchmark and a client-ready deliverable.

## First principle: Visibility ≠ Readiness

Two different questions, and most "AI SEO audits" conflate them:

- **AI Visibility** — *are you actually in the answer right now?* When a real customer asks ChatGPT, Claude, Perplexity or Google's AI for "the best [category] in [place]," does it name you? This is the **outcome**, and the only way to know it is to **ask the engines and read what they say**.
- **AI Readiness** — *is your site built to earn that answer?* Citable content, clean crawler access, structured data, off-page authority, an entity the engines can resolve. These are the **inputs** you control.

You can be highly ready and still invisible (a well-built site the engines don't yet know or trust), and — occasionally — visible while under-built (a business the web talks about, riding on reputation). **Readiness is what you control; visibility is what it earns you. The gap between them is the work.**

**This open repo audits Readiness. It does not measure Visibility** — it reads public signals and *infers* how citable and recommendable you are. That's genuinely useful for fixing the foundations, and it's honest about being an inference (every score is provenance-tagged; see below).

**Measuring Visibility — actually querying the engines — is a different discipline**, and THL runs it as the hosted scanner:

> ### ⚡ The live Visibility measurement: [areyoufoundbyai.com](https://areyoufoundbyai.com)
> Enter a URL; it asks ChatGPT, Claude, Perplexity and Google's AI the questions real buyers use, and reports whether you're **named**, who's named **instead**, and how often. Free, 60 seconds, no install. **For the full audit — the live "are you in the answer" measurement — that's the tool to run.** The open skills below then tell you *why*, and exactly what to fix.

Why the split? Measuring visibility well is hard in ways that don't show on the surface, and getting them wrong produces confident, wrong numbers (the opposite of this method's whole point). The principles we hold it to are public even though the engine isn't:

## How to measure Visibility honestly (the principles, if you build your own)

- **Ask the engines; don't infer.** On-page signals predict visibility; they don't prove it. The only ground truth is the answer the engine actually gives.
- **Sample, because engines are stochastic.** Ask the same question several times. One ask is a coin-flip near the margin — "named in 2 of 6 asks (sometimes)" is the honest read, a bare ✓ is not.
- **Anchor the place in the question.** "best dog walker in Cardiff" returns Cardiff, California half the time without the country. Wrong-geography answers silently poison the result.
- **Distinguish *named aloud* from *cited as a source*.** Being spoken in the answer and being a footnote link are different signals of different strength — don't collapse them into one "mention."
- **Reject near-duplicate names.** "Happy Tails Club" and "Tails N' Trails" are not "Tails Trails." A brand matcher that counts them inflates the score; precision beats recall on a report someone paid for.
- **Never fabricate a number.** Where a source has no data, say so and render `—`. A number with weak provenance still reads as hard data to a client — that's the failure mode this whole method exists to avoid.

## The Readiness method — the three layers in this repo

1. **Dimensional audit — [`skills/geo-audit`](../skills/geo-audit/SKILL.md).** Crawls the site and scores six readiness dimensions (citability, brand authority, E-E-A-T, technical, schema, platform) into a 0–100 composite with a prioritised action plan. This is a readiness score, inferred from signals — not a confirmed visibility measurement.
2. **External benchmark — [`skills/agent-readiness-scan`](../skills/agent-readiness-scan/SKILL.md) (THL-original).** Runs Cloudflare's public `isitagentready.com` check for an independent 0–100 agent-readiness score — the cross-check the dimensional audit can't give itself: a third-party number, tracked as a delta across re-audits.
3. **Deliverable — [`tools/audit-report-kit`](../tools/audit-report-kit) (THL-original).** Turns the audit JSON into a polished, branded client PDF plus compile-checked JSON-LD (the schema the audit recommends, ready to paste).

## The recommended flow

```
areyoufoundbyai.com   ── LIVE VISIBILITY: are you named by the engines? (the outcome)
        │
        ▼
geo-audit             ── READINESS 0–100 + findings: why, and what to fix (the inputs)
        │
        ├─▶ agent-readiness-scan  ── external Cloudflare 0–100 (independent benchmark)
        │
        └─▶ audit-report-kit      ── branded PDF + JSON-LD for the schema fixes
```

Run the live scan first for the outcome; run the dimensional audit for the diagnosis; add the external readiness number; assemble into the report kit. Re-measure on a cadence and track the **delta** on both visibility and readiness — the movement is the proof, not the first number.

## The scoring discipline (why this is repeatable)

- **Every score traces to evidence.** A citability score points at the exact passages scored; a schema score points at the markup found. No number without a reason.
- **Tag each score's provenance.** Mark every dimension `[scan]` (scored from data fetched this run), `[partial-scan]` (some pages sampled, the rest inferred), `[heuristic]` (model judgement, no underlying data fetched), or `[unmeasured]` (the data source needed to score it was unavailable). When a score is `[unmeasured]` — or would be pure `[heuristic]` — emit `—`, not a number. A number with weak provenance still reads as hard data to a client.
- **The composite is a fixed formula, not a vibe.** Same weights every run (see the audit skill's scoring table), so two audits of the same site are comparable.
- **Run the checklist.** [`skills/geo-audit/references/thl-audit-checklist.md`](../skills/geo-audit/references/thl-audit-checklist.md) is a copy-able checklist that stops a dimension being silently dropped and cross-checks that the same facts (entity details, scores) appear consistently across every section.
- **Verify the outcome, not the run.** A finished audit isn't "an audit ran" — it's "every category scored, every score evidenced, the report renders, the JSON-LD validates." Check the artifacts.

## What stays proprietary

This repo is the open **readiness** method and the open utilities. The **visibility** measurement engine (the live multi-engine querying, the detection and de-duplication logic, the sampling discipline), THL's calibration data, the regression eval set, client playbooks, and the voice library are not here. The moat is the measurement engine, the data and the playbooks — not the method, and not the principles above, which we're glad to have judged in the open.
