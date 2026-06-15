# Eval fixture — Harborview Insurance Brokers (fictional)

A worked fixture in the format described in [`README.md`](README.md). Harborview is a
made-up Gold Coast insurance broker; the numbers match the sample report in the
[root README](../README.md) and the worked example in [`examples/`](../examples).
Nothing here is a real site or a real client.

**Target:** `harborview-brokers.com.au`
**Profile:** established broker, good offline reputation, ~two decades trading, a site
built for classic SEO and effectively invisible to AI answer engines.

## Expected composite

| | Range | Band |
|---|---|---|
| Composite GEO score | **33–43** | Critical |

A correct run lands in the low end of the scale: the business is real and reputable,
but the models can't see it.

## Expected per-dimension ranges

| Dimension | Expected | Note |
|---|---|---|
| AI Citability | 25–37 | Content isn't structured into quotable, self-contained answers |
| Crawler Access | 42–54 | Some major AI crawlers blocked at `robots.txt` |
| Schema Markup | 4–16 | Effectively no structured data present |
| Content E-E-A-T | 38–50 | Thin service pages; little first-hand expertise signalled |
| Technical SEO | 50–63 | Indexable but slow and lightly structured |

## Must-flag findings

A correct run **must** surface all of these. Missing any one is a failure even if the
composite lands in range.

- [ ] **No `Organization` / `LocalBusiness` / `Service` JSON-LD** (Critical) — the
      single highest-leverage fix; gates entity recognition.
- [ ] **AI crawlers blocked in `robots.txt`** (High) — at least the major answer-engine
      bots (e.g. GPTBot, ClaudeBot) named explicitly, not just "some crawlers."
- [ ] **Service pages too thin to cite** (High) — flagged with the median word count or
      equivalent evidence, not as a vague impression.
- [ ] **DMARC not published** (Medium) — sender authentication / trust signal absent.

## Expected ranked fix order

The top of the action plan should read, in roughly this order:

1. Deploy `Organization` + `Service` JSON-LD (largest citability gain).
2. Open `robots.txt` to the major AI crawlers.
3. Deepen the service pages so there's something worth quoting.

## Evidence requirement

Every score above must be traceable: the citability score points at the passages it
scored, the schema score points at the markup it found (or didn't), the crawler score
points at the exact `robots.txt` lines. A number without a reason is a failed run.
