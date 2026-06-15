---
name: geo-llmstxt
description: Analyzes and generates llms.txt files -- the emerging standard for helping AI systems understand website structure and content. Can validate existing llms.txt files or generate new ones from scratch by crawling the site.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - WebFetch
  - Write
---

# llms.txt Standard Analysis and Generation Skill

## Purpose

This skill handles everything related to the `llms.txt` standard — an emerging convention (proposed
by Jeremy Howard in September 2024) that lets a website give AI systems structured guidance about
its content, structure, and key information. It is analogous to `robots.txt` (which tells crawlers
what NOT to access) but instead tells AI systems what IS most useful to understand about the site.

The full format spec, the `llms-full.txt` variant, a fill-in template, and best practices live in
**[`references/spec.md`](references/spec.md)** — read it before validating or generating a file.

## Why llms.txt Matters

AI models must work out which pages matter, what a site is about, and how content is organized —
usually by crawling many pages and inferring structure. `llms.txt` solves this with an explicit,
machine- and human-readable summary.

1. **Faster AI comprehension:** understand the site's purpose and structure from one file rather than dozens of pages.
2. **Controlled narrative:** you choose which pages and facts AI systems see first, shaping how they represent your brand.
3. **Higher citation accuracy:** AI systems that consult llms.txt cite the correct, authoritative page for each topic.
4. **Reduced misrepresentation:** key facts (pricing, features, locations) are stated explicitly, reducing hallucination.
5. **Early-adopter advantage:** only a small minority of sites have an llms.txt today, so it remains a differentiator.

---

## Analysis Mode

When checking an existing llms.txt file.

### Step 1: Fetch the File
1. Use WebFetch to retrieve `[domain]/llms.txt`. Also check `[domain]/llms-full.txt`.
2. Record HTTP status: **200** → validate; **404** → recommend generation; **403** → file blocked, flag as misconfiguration; **301/302** → follow and note the redirect.

### Step 2: Validate Format
Check each structural element against the format rules in [`references/spec.md`](references/spec.md):

| Element | Check | Severity if Missing |
|---|---|---|
| H1 Title | Present, matches business name | Critical |
| Blockquote description | Present, under 200 chars, factual | High |
| At least one H2 section | Present | Critical |
| Page entries with URLs | At least 5 entries present | High |
| URLs are absolute | All URLs use full https:// paths | High |
| URLs are valid | All URLs return 200 status | Medium |
| Descriptions present | Every entry has a description after the colon | Medium |
| Key Facts section | Present with business information | Medium |
| Contact section | Present with at least email | Low |
| Reasonable length | 30-200 lines | Low |
| No broken Markdown | Proper formatting throughout | Medium |

### Step 3: Assess Content Quality
Rate three dimensions 0-100:
- **Completeness:** covers all major site sections? most important/highest-traffic pages? Key Facts present and accurate? recent content?
- **Accuracy:** descriptions reflect page content? URLs valid and correct? Key Facts verifiable and current? business description accurate?
- **Usefulness:** would an AI understand the site from this file alone? descriptions specific enough to differentiate pages? citation-worthy pages highlighted? logical organization?

```
Overall llms.txt Score = (Completeness * 0.40) + (Accuracy * 0.35) + (Usefulness * 0.25)
```

### Step 4: Compare Against Site Content
Crawl the main navigation and sitemap; identify important pages NOT listed; flag broken/redirected URLs, a business description that no longer matches the homepage, and stale entries (pages significantly updated since the llms.txt was written).

---

## Generation Mode

When creating a new llms.txt from scratch.

### Step 1: Site Discovery
Fetch the homepage and extract the site name (`<title>`, `og:site_name`, or H1), business description (meta description or hero), and main navigation + footer links. Fetch `/sitemap.xml` for all public pages. Identify the business type (SaaS, E-commerce, Local, Publisher, Agency).

### Step 2: Page Prioritization
- **Always include:** homepage, About, pricing (if any), top 3-5 product/service pages, contact, docs landing.
- **Include if high quality:** top blog posts, case studies, key guides, FAQ, careers (large companies).
- **Skip:** thin category/tag pages, pagination, login/signup, legal boilerplate (unless relevant), duplicates, minimal-content pages.

### Step 3: Write Descriptions
For each selected page, fetch it and read the H1, meta description, and first 2-3 paragraphs, then write a 10-30 word description that states what information is on the page and the specific topics/data/features covered. Use factual language; avoid "best/leading/revolutionary."
- Good: `Explains the three pricing tiers (Free, Pro, Enterprise) with feature comparison and annual/monthly costs.`
- Bad: `Our amazing pricing page!` / `Learn more about our company.`

### Step 4: Compile Key Facts
Gather: year founded, founder(s), HQ, employee count (if public), customer/user count (if public), top 3-5 products/services, industry, notable clients/partnerships (if public), key differentiators, recent milestones (last 12 months).

### Step 5: Assemble the File
Build the file from the template in [`references/spec.md`](references/spec.md).

### Step 6: Validate the Generated File
Verify all URLs return 200; entry count is 10-30; no description exceeds 50 words; total length is 50-150 lines; Markdown is clean and consistent.

---

## Output

Use the templates in [`references/output-template.md`](references/output-template.md):
- **Analysis mode:** `GEO-LLMSTXT-ANALYSIS.md` — score, format-validation table, missing pages, recommendations, and a suggested rewrite if needed.
- **Generation mode:** the complete `llms.txt`, plus a short `GEO-LLMSTXT-GENERATION.md` noting pages discovered vs. selected, prioritization rationale, borderline pages, and recommended update frequency.
