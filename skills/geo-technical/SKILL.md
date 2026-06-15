---
name: geo-technical
description: Technical SEO audit with GEO-specific checks — crawlability, indexability, security, performance, SSR, and AI crawler access
version: 1.0.0
author: geo-seo-claude
tags: [geo, technical-seo, core-web-vitals, ssr, crawlability, security, performance]
allowed-tools: Read, Grep, Glob, Bash, WebFetch, Write
---

# GEO Technical SEO Audit

## Purpose

Technical SEO is the foundation of both traditional search visibility and AI search citation. A
technically broken site cannot be crawled, indexed, or cited by any platform. This skill audits
eight categories of technical health with specific attention to GEO requirements — most critically
**server-side rendering** (AI crawlers do not execute JavaScript) and **AI crawler access** (many
sites inadvertently block AI crawlers in robots.txt).

## How to Use This Skill

1. Collect the target URL (homepage + 2-3 key inner pages).
2. Fetch each page using curl/WebFetch to get raw HTML and HTTP headers.
3. Work through each of the eight categories in
   [`references/audit-categories.md`](references/audit-categories.md), scoring each against its
   rubric there. (That file also covers the IndexNow check.)
4. Total the category scores into the 100-point composite below.
5. Generate `GEO-TECHNICAL-AUDIT.md` using
   [`references/output-template.md`](references/output-template.md).

The two GEO-critical categories — **AI crawler access** (Category 1.2) and **server-side
rendering** (Category 7) — are where conventional SEO audits miss the most. A site can pass a
traditional audit and still be invisible to AI crawlers because its content is client-rendered or
GPTBot is disallowed. Always confirm these two by fetching raw HTML with `curl` (no JS execution).

---

## Overall Scoring

| Category | Max Points | Weight |
|---|---|---|
| Crawlability | 15 | Core foundation |
| Indexability | 12 | Core foundation |
| Security | 10 | Trust signal |
| URL Structure | 8 | Crawl efficiency |
| Mobile Optimization | 10 | Google requirement |
| Core Web Vitals | 15 | Ranking signal |
| Server-Side Rendering | 15 | GEO critical |
| Page Speed & Server | 15 | Performance |
| **Total** | **100** | |

Per-category point breakdowns live alongside each category's checks in
[`references/audit-categories.md`](references/audit-categories.md).

### Score Interpretation
- **90-100**: Excellent — technically sound for both traditional SEO and GEO
- **70-89**: Good — minor issues to address but fundamentally solid
- **50-69**: Needs Work — significant technical debt impacting visibility
- **30-49**: Poor — major issues blocking crawling, indexing, or AI visibility
- **0-29**: Critical — fundamental technical failures requiring immediate attention

---

## Output

> **Provenance (THL):** tag the score `[scan]` (data fetched this run), `[partial-scan]`, `[heuristic]` (judgement, no data), or `[unmeasured]` — and emit `—` instead of a number when `[unmeasured]` or pure `[heuristic]`. A number with weak provenance still reads as hard data. See [the GEO Method](../../docs/THL-GEO-METHOD.md).

Write `GEO-TECHNICAL-AUDIT.md` using
[`references/output-template.md`](references/output-template.md): technical score, per-category
breakdown with Pass/Warn/Fail status, the AI-crawler access table, then issues tiered as Critical
/ Warnings / Recommendations, each citing the specific page URL so the finding is verifiable.
