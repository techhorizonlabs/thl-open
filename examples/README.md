# Examples & prompts

Copy-paste prompts for every skill, plus one worked end-to-end audit you can read
start to finish. All sample data is fictional (a made-up broker, **Harborview
Insurance Brokers**) — no real client appears here.

> New here? Read [the THL GEO Method](../docs/THL-GEO-METHOD.md) first. It explains
> the three layers the walkthrough below moves through.

---

## Prompt cheat-sheet

Once the skills are installed (see the [root README](../README.md#quickstart)), you
drive them in plain language inside Claude Code. The skill fires on the intent, so
phrasing is flexible — these are just reliable starting points.

| You want to… | Say something like | Skill |
|---|---|---|
| Run the full audit | `do a GEO audit of harborview-brokers.com.au` | `geo-audit` |
| Get the independent benchmark | `run an agent-readiness scan on harborview-brokers.com.au` | `agent-readiness-scan` |
| Score one page's citability | `score the citability of harborview-brokers.com.au/business-insurance` | `geo-citability` |
| See which AI crawlers are allowed | `which AI crawlers can access harborview-brokers.com.au` | `geo-crawlers` |
| Generate or validate `llms.txt` | `generate an llms.txt for harborview-brokers.com.au` | `geo-llmstxt` |
| Audit / generate schema | `audit the schema markup on harborview-brokers.com.au` | `geo-schema` |
| Check content E-E-A-T | `assess the content E-E-A-T on harborview-brokers.com.au` | `geo-content` |
| Technical-SEO pass | `run a technical SEO audit of harborview-brokers.com.au` | `geo-technical` |
| Scan brand authority | `scan brand mentions and authority for Harborview Insurance Brokers` | `geo-brand-mentions` |
| Tune for one engine | `optimize harborview-brokers.com.au for Perplexity` | `geo-platform-optimizer` |
| Produce the client report | `generate a GEO report from this audit` | `geo-report` / `geo-report-pdf` |
| Track month-over-month | `compare this month's audit against last month` | `geo-compare` |

(`geo-proposal` and `geo-prospect` exist for the agency sales side — proposal
generation and a lightweight pipeline. They're part of the forked suite; the audit
core above is what most people come for.)

---

## Worked example: auditing Harborview Insurance Brokers

A realistic run, end to end. The numbers below match the sample report in the
[root README](../README.md) and the committed
[`harborview.jsonld`](../tools/audit-report-kit/examples/harborview.jsonld), so you
can see exactly where each artifact comes from.

### 1 · Dimensional audit — `geo-audit`

```
do a GEO audit of harborview-brokers.com.au
```

The audit crawls the site, scores six dimensions into a 0–100 composite, and ranks
the fixes by impact. For Harborview it lands at **38/100 (Critical)**:

| Dimension | Score | Provenance | Why |
|---|---:|---|---|
| AI Citability | 31 | `[scan]` | Pages don't answer questions in quotable, self-contained blocks |
| Crawler Access | 48 | `[scan]` | 2 of 8 major AI crawlers blocked in `robots.txt` |
| Schema Markup | 8 | `[scan]` | No `Organization` / `LocalBusiness` / `Service` JSON-LD at all |
| Content E-E-A-T | 44 | `[partial-scan]` | Service pages too thin to cite; little first-hand expertise signalled |
| Technical SEO | 57 | `[scan]` | Indexable, but slow and light on structure |

Every row carries a **provenance tag** — `[scan]` (fetched this run), `[partial-scan]`,
`[heuristic]`, or `[unmeasured]`. A category the audit couldn't actually measure shows
`—`, never an invented number. (Core Web Vitals, for instance, reads `[unmeasured]`
unless a PageSpeed key is set.)

Top ranked fixes: **(1)** deploy `Organization` + `Service` JSON-LD (unlocks the
biggest citability gain), **(2)** open `robots.txt` to GPTBot and ClaudeBot, **(3)**
deepen the service pages so models have something worth quoting.

### 2 · External benchmark — `agent-readiness-scan`

```
run an agent-readiness scan on harborview-brokers.com.au
```

This runs Cloudflare's public `isitagentready.com` check and returns an independent
0–100 score plus a fixed-schema CSV of evidence. It's the cross-check the
dimensional audit can't give itself — a third-party number you record and re-run, so
the **delta** across audits is auditable rather than self-reported. Treat a low
readiness score as corroboration of the crawler-access and schema findings above.

### 3 · Deliverable — `audit-report-kit`

The audit's findings become a branded client PDF plus the exact schema to paste:

```bash
cd tools/audit-report-kit && npm install && npm run report
# → out/harborview-audit.pdf   (the report pictured in the README)
# → out/harborview.jsonld      (matches examples/harborview.jsonld, type-checked)
```

The JSON-LD is the **fix for finding #1**, generated rather than hand-written so it
can't drift from what the audit recommended:

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Harborview Insurance Brokers",
  "url": "https://harborview-brokers.com.au",
  "areaServed": ["Gold Coast", "Brisbane", "Queensland"]
}
```

### 4 · Re-audit on a cadence

Re-run steps 1–2 monthly with `geo-compare`:

```
compare this month's Harborview audit against last month
```

The first score is the baseline. The movement is the proof — that's the whole point
of keeping the formula fixed and every score evidenced.

---

## A note on honesty in the numbers

Every score in a real run should trace to evidence you can point at, and the
composite is a fixed formula (see the [audit checklist](../skills/geo-audit/references/thl-audit-checklist.md)).
If a skill ever hands you a number it can't justify, that's a bug — open an issue.
