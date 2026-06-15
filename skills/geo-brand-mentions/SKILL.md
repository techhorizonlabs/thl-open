---
name: geo-brand-mentions
description: Brand mention and authority scanner for AI visibility. Analyzes brand presence across platforms that AI models rely on for entity recognition and citation decisions. Produces a Brand Authority Score (0-100) with platform-specific recommendations.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - WebFetch
  - Write
---

# Brand Mention Scanner Skill

## Core Insight

Brand mentions correlate roughly 3x more strongly with AI visibility than traditional backlinks.
An Ahrefs study (Dec 2025, 75,000 brands across AI search platforms) found that **unlinked brand
mentions** — references to a brand name with no hyperlink — predict whether AI systems cite and
recommend a brand better than Domain Rating or backlink count.

The critical finding: **the platform the mention sits on matters enormously.** A mention on
YouTube or Reddit carries far more weight for AI citation than one on a low-authority blog,
because AI training data and retrieval systems disproportionately index high-engagement platforms.

This inverts a core SEO assumption. In SEO, a backlink from a high-DR site is the gold standard.
In GEO, an unlinked mention on Reddit or in a YouTube description may be worth more than a dofollow
backlink from a DR 70 blog.

## Platforms that matter

AI systems weight a handful of platforms far above backlinks. Each platform's rationale, scan
recipe, and 0–100 scoring rubric live in **[`references/platforms.md`](references/platforms.md)** —
read it before scoring. Ranked by correlation with AI citation:

1. **YouTube** (~0.737, strongest) — channel + third-party video/description/transcript mentions
2. **Reddit** — subreddit discussion, recommendation threads, sentiment
3. **Wikipedia / Wikidata** — the entity-recognition foundation
4. **LinkedIn** — professional / B2B authority signals
5. **Other** — Quora, Stack Overflow, GitHub, forums, news, podcasts (scored as one basket)

---

## Composite Brand Authority Score

Score each platform 0–100 (rubrics in `references/platforms.md`), then weight:

| Platform | Weight | Rationale |
|---|---|---|
| YouTube Presence | 25% | Strongest correlation with AI citation (~0.737) |
| Reddit Presence | 25% | Second strongest; critical for product recommendations |
| Wikipedia / Wikidata | 20% | Entity-recognition foundation; AI training-data cornerstone |
| LinkedIn Authority | 15% | Professional authority signals; B2B relevance |
| Other Platforms | 15% | Supplementary signals (Quora, GitHub, news, forums, podcasts) |

```
Brand_Authority_Score = (YouTube * 0.25) + (Reddit * 0.25) + (Wikipedia * 0.20) + (LinkedIn * 0.15) + (Other * 0.15)
```

| Score | Rating | Interpretation |
|---|---|---|
| 85-100 | Dominant | Well-recognized entity across AI platforms. Highly likely to be cited and recommended. |
| 70-84 | Strong | Solid cross-platform presence. AI systems likely recognize and cite it for relevant queries. |
| 50-69 | Moderate | Present on some platforms but with gaps. AI citation is inconsistent. |
| 30-49 | Weak | Limited presence. AI systems may not recognize it as a distinct entity. |
| 0-29 | Minimal | Negligible presence. AI systems are unlikely to cite or recommend it. |

---

## Analysis Procedure

### Step 1 — Identify the brand

Gather from the user or the website: exact **brand name** (and official variants),
**founder/CEO name(s)**, **domain**, **industry**, top 3 **products/services**, and key
**competitors** (for comparison context).

### Step 2 — Scan each platform

Work through every platform using the scan recipes in
[`references/platforms.md`](references/platforms.md), and score each 0–100 against its rubric there.

> **Wikipedia is the one trap:** web search alone produces false negatives. Run the Python API
> check in `references/platforms.md` **first** — if the API says a page exists, it exists; never
> override that with a failed search result.

### Step 3 — Assess sentiment

For Reddit and other discussion platforms, judge sentiment from the most recent and most prominent mentions:

| Sentiment | Indicators |
|---|---|
| **Positive** | Recommendations ("I love [brand]", "we switched to [brand]", "highly recommend"), upvoted mentions, favourable comparisons |
| **Neutral** | Factual mentions ("we use [brand] for…", "[brand] offers…"), questions, balanced comparisons |
| **Negative** | Complaints ("avoid [brand]", "terrible support"), downvoted recommendations, unfavourable comparisons |
| **Mixed** | Both — note the ratio and the primary themes |

### Step 4 — Competitive comparison (optional)

If competitors are known, quick-scan their platform presence for context. It calibrates the score:
"moderate" Reddit presence in an industry where competitors have none is relatively strong.

### Step 5 — Calculate and recommend

1. Score each platform 0–100 using the rubrics.
2. Apply the weights for the composite Brand Authority Score.
3. Identify the strongest and weakest platforms.
4. Turn the weakest platforms into specific actions using the presence-building tips in
   [`references/research.md`](references/research.md).

---

## Output

> **Provenance (THL):** tag the score `[scan]` (data fetched this run), `[partial-scan]`, `[heuristic]` (judgement, no data), or `[unmeasured]` — and emit `—` instead of a number when `[unmeasured]` or pure `[heuristic]`. A number with weak provenance still reads as hard data. See [the GEO Method](../../docs/THL-GEO-METHOD.md).

Write `GEO-BRAND-MENTIONS.md` using the template in
[`references/output-template.md`](references/output-template.md) — score header, platform
breakdown table, per-platform detail, tiered recommendations, competitive context, and a
one-line key takeaway. Fill every placeholder or mark it `N/A`.

## Reference data

Correlation strengths (the "why YouTube/Reddit beat backlinks" evidence) and the per-platform
presence-building playbook are in [`references/research.md`](references/research.md).
