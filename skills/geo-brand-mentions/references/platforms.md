# Platform detail: why each matters, what to check, how to scan, how to score

Background for the platform weights in `SKILL.md`. Based on the Ahrefs study (Dec 2025,
75K brands across AI search platforms) and corroborating research from Profound and Terakeet:
**unlinked brand mentions** predict AI citation more strongly than Domain Rating or backlink
count, and **the platform the mention sits on matters enormously.** A mention on YouTube or
Reddit can outweigh a dofollow backlink from a DR 70 blog.

Each platform below carries its own rationale, a scan recipe, and a 0–100 rubric. Score every
platform, then apply the composite weights in `SKILL.md`.

---

## 1. YouTube — Correlation ~0.737 (STRONGEST)

**Why it matters most:**
- Second-largest search engine and largest video platform globally (2.5B+ monthly users).
- AI training datasets heavily incorporate YouTube transcripts, descriptions, and metadata.
- Google's Gemini and AI Overviews directly reference YouTube content; Perplexity and ChatGPT both index and cite it.
- Transcripts are especially valuable — natural-language mentions in conversational context, which is how AI models process and generate text.

**What to check:**
- **Brand channel:** active? subscriber count, video count, upload frequency.
- **Third-party mentions:** other channels reviewing / comparing / tutorialising the brand.
- **Descriptions & transcripts:** brand name in descriptions and spoken content of relevant videos (AI indexes both).
- **Search presence:** searching "[brand]" on YouTube — do results appear, are they positive?
- **Comments:** brand mentioned in comments on relevant industry videos.

**How to scan:**
1. Search: `[brand name] site:youtube.com`
2. Check `youtube.com/@[brand-name]` or `youtube.com/c/[brand-name]` for an official channel
3. Search: `"[brand name]" site:youtube.com` (exact match for description mentions)
4. Note: subscriber count, video count, latest upload date, third-party mention count

**Scoring (0–100):**

| Score | Criteria |
|---|---|
| 90-100 | Active channel with 10K+ subscribers, regular uploads, brand mentioned in 20+ third-party videos, appears in YouTube search results for industry terms |
| 70-89 | Active channel with 1K+ subscribers, brand mentioned in 10-19 third-party videos, some YouTube search presence |
| 50-69 | Channel exists with some content, brand mentioned in 5-9 third-party videos, limited YouTube search presence |
| 30-49 | Channel exists but inactive, brand mentioned in 1-4 third-party videos |
| 10-29 | No channel or empty channel, brand mentioned in 1-2 videos only |
| 0-9 | No YouTube presence whatsoever |

---

## 2. Reddit — High correlation

**Why it matters:**
- One of the most heavily indexed platforms in AI training data (confirmed by Google's $60M/year Reddit licensing deal, 2024).
- AI systems heavily weight Reddit for product recommendations, comparisons, and sentiment.
- A visible share of searchers append "reddit" to queries for authentic opinions; the exact share is unpublished, so do not quote a number for it.
- Perplexity frequently cites Reddit threads; ChatGPT and Claude reference Reddit discussions for product/service questions.

**What to check:**
- **Subreddit presence:** which relevant subreddits discuss the brand?
- **Mention volume + trend:** how many threads, increasing or decreasing?
- **Sentiment:** mostly positive / negative / neutral? common praise points and complaints.
- **Official presence:** official account? participation? AMAs?
- **Recommendation threads:** does it appear in "what do you recommend for X?" — top pick or also-ran?
- **Own subreddit:** exists? how active?

**How to scan:**
1. Search: `[brand name] site:reddit.com`
2. Search: `"[brand name]" site:reddit.com` (exact match)
3. Check `reddit.com/r/[brand-name]` for an official subreddit
4. Check `reddit.com/user/[brand-name]` for an official account
5. Note: thread count, dominant subreddits, sentiment, recommendation frequency

**Scoring (0–100):**

| Score | Criteria |
|---|---|
| 90-100 | Frequently recommended in relevant subreddits, predominantly positive sentiment, active official presence, own subreddit with 5K+ members, top recommendation for industry queries |
| 70-89 | Regularly mentioned in relevant subreddits, mostly positive sentiment, some official presence, appears in multiple recommendation threads |
| 50-69 | Mentioned in several relevant threads, mixed sentiment, brand name recognised by the community |
| 30-49 | Occasional mentions, limited to 1-2 subreddits, no official presence |
| 10-29 | Rare mentions, brand largely unknown on Reddit |
| 0-9 | No Reddit presence |

---

## 3. Wikipedia / Wikidata — High correlation

**Why it matters:**
- One of the highest-authority sources in AI training data — every major model trains on Wikipedia dumps.
- AI systems use Wikipedia for **entity recognition** — deciding whether a brand is a "real" entity worth knowing about.
- Wikidata supplies machine-readable facts that AI models use for knowledge-graph construction.
- A Wikipedia page is a strong notability signal, which correlates with AI treating the brand as authoritative.

**What to check:**
- **Company article:** own Wikipedia article? flagged for deletion or quality issues?
- **Founder article:** founder/CEO has a page? (strong authority signal)
- **Citations:** brand's site cited as a reference in any articles?
- **Wikidata item:** has a Q-number? how complete?
- **Mentions:** referenced in other articles (industry, competitor, category pages)?
- **Article quality:** stub, start-class, or higher?

**How to scan — use BOTH methods; web search alone produces false negatives:**

**Method 1 — Python API check (MOST RELIABLE, do this FIRST):**
```bash
python3 -c "
import requests, json
from urllib.parse import quote_plus
brand = '[Brand_Name]'
# Check Wikipedia API directly
api_url = f'https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch={quote_plus(brand)}&format=json'
r = requests.get(api_url, headers={'User-Agent': 'GEO-Audit/1.0'}, timeout=15)
data = r.json()
results = data.get('query', {}).get('search', [])
if results and brand.lower() in results[0].get('title', '').lower():
    print(f'WIKIPEDIA PAGE EXISTS: {results[0][\"title\"]}')
    print(f'URL: https://en.wikipedia.org/wiki/{results[0][\"title\"].replace(\" \", \"_\")}')
else:
    print('No direct Wikipedia page found')
# Check Wikidata
wd_url = f'https://www.wikidata.org/w/api.php?action=wbsearchentities&search={quote_plus(brand)}&language=en&format=json'
r2 = requests.get(wd_url, headers={'User-Agent': 'GEO-Audit/1.0'}, timeout=15)
wd = r2.json()
entities = wd.get('search', [])
if entities:
    print(f'WIKIDATA ENTRY: {entities[0].get(\"id\", \"\")} — {entities[0].get(\"description\", \"\")}')
"
```

**Method 2 — Direct URL check (backup verification):**
1. WebFetch `https://en.wikipedia.org/wiki/[Brand_Name]` — does the page load (not a redirect to search)?
2. WebFetch `https://en.wikipedia.org/wiki/[Founder_Name]` for the founder article

**Method 3 — Search (least reliable, supplemental only):**
1. Search: `[brand name] site:wikipedia.org`
2. Search: `[brand name] site:wikidata.org`

**CRITICAL:** If the API says a page exists, it exists — never override that with a search result that failed to find it. Note article existence, quality, edit history, and Wikidata completeness.

**Scoring (0–100):**

| Score | Criteria |
|---|---|
| 90-100 | Detailed article (B-class or higher), Wikidata entry with complete properties, brand cited as a reference in multiple articles, founder has a Wikipedia page |
| 70-89 | Article exists (start-class or higher), Wikidata entry exists, brand mentioned in 2+ other articles |
| 50-69 | Article exists (stub or start), basic Wikidata entry, limited mentions elsewhere |
| 30-49 | No article, but brand is mentioned in other articles or cited as a reference; Wikidata entry may exist |
| 10-29 | Mentioned in 1-2 articles as a passing reference only |
| 0-9 | No Wikipedia or Wikidata presence of any kind |

---

## 4. LinkedIn — Moderate correlation

**Why it matters:**
- Increasingly indexed by AI systems for professional and B2B context.
- Company pages and employee thought-leadership posts build brand entity signals.
- AI models reference LinkedIn for company info, team credentials, and professional authority.
- LinkedIn articles and posts are indexed by search engines and AI crawlers.

**What to check:**
- **Company page:** exists? follower count, post frequency.
- **Employee thought leadership:** leadership posting content that mentions the brand?
- **Third-party mentions:** non-employees, analysts, customers posting about the brand?
- **Long-form articles:** LinkedIn articles about or mentioning the brand?
- **Employee profiles:** company listed with detail, strong professional profiles?
- **Engagement:** typical likes / comments / shares on company posts.

**How to scan:**
1. Search: `[brand name] site:linkedin.com`
2. Check `linkedin.com/company/[brand-name]` for the company page
3. Note: follower count, post frequency, employees listed, engagement levels

**Scoring (0–100):**

| Score | Criteria |
|---|---|
| 90-100 | Active company page with 10K+ followers, leadership regularly posts thought leadership, brand frequently mentioned by industry professionals, strong employee profiles |
| 70-89 | Active company page with 5K+ followers, some employee thought leadership, occasional third-party mentions |
| 50-69 | Company page with 1K+ followers, irregular posting, limited third-party mentions |
| 30-49 | Company page exists but sparse or inactive, few followers, no third-party mentions |
| 10-29 | Basic company page with minimal information |
| 0-9 | No LinkedIn company page |

---

## 5. Other platforms — Supplementary

Lower but still meaningful correlation. Score this basket as one 0–100 dimension, weighting the
platforms most relevant to the brand's category.

**How to scan:**
1. Search: `[brand name] site:quora.com`
2. Search: `[brand name] site:stackoverflow.com` (if technical)
3. Search: `[brand name] site:github.com` (if technical)
4. Search: `[brand name] site:news.ycombinator.com` (Hacker News)
5. Search: `"[brand name]"` broadly for news mentions (filter to the last 6 months)
6. Note presence/absence and quality of mentions on each.

| Platform | Relevance | Signal strength |
|---|---|---|
| **Quora** | Answers frequently appear in AI training data and are cited by Perplexity | Moderate for B2C, lower for B2B |
| **Stack Overflow / Exchange** | Critical for developer-facing brands — is the product discussed? a tag? an official account answering? | High for technical products, irrelevant for most B2C |
| **GitHub** | Org presence, repo stars, mentions in other repos' docs/discussions | High for dev tools / open source, low otherwise |
| **Industry forums** | Niche authority AI picks up from domain-specific data (Hacker News, ProductHunt, community Slacks) | Moderate, valuable for niche authority |
| **News & press** | Entity authority + recency signals | Moderate — recency matters; last 6 months ≫ 3 years ago |
| **Podcasts** | Growing training-data source; transcripts increasingly indexed | Moderate and growing |
