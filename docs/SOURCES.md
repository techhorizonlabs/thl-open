# Sources

The THL GEO Method and the scoring in these skills are grounded in primary sources,
each scoped to where it actually has authority. No single source covers the whole AI
search landscape — the engines have different owners, indexes, and ranking signals —
so we say which source backs which claim, and what we *don't* claim.

This is the same standard we hold on [attribution](../NOTICE.md): a recommendation
should trace to a source you can check.

## Source matrix

| Source | Authoritative for | Type |
|---|---|---|
| [Google AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) | **Google AI Overviews + AI Mode** | First-party guidance from the engine owner |
| [Aggarwal et al., "GEO: Generative Engine Optimization" (KDD 2024)](https://arxiv.org/abs/2311.09735) | **Cross-engine GEO tactics** | Peer-reviewed (ACM SIGKDD 2024), tested on a multi-engine benchmark |
| [Schema.org](https://schema.org/) + [Google structured data docs](https://developers.google.com/search/docs/appearance/structured-data/intro-structured-data) | **Structured-data syntax + rich-result eligibility** | Standards body + engine-owner docs |
| [llms.txt proposal](https://llmstxt.org/) (Howard, 2024) | **The `llms.txt` format only** | A community proposal — *not* a ratified standard |
| Crawler operator docs — [GPTBot](https://platform.openai.com/docs/gptbot), [ClaudeBot](https://support.anthropic.com/en/articles/8896518), [PerplexityBot](https://docs.perplexity.ai/guides/bots), [Google-Extended](https://developers.google.com/search/docs/crawling-indexing/overview-google-crawlers) | **Which crawler reads what, and how to allow/deny it** | First-party from each operator |
| [Cloudflare — Is It Agent Ready](https://isitagentready.com/) | **The external agent-readiness benchmark** | The third-party 0–100 our `agent-readiness-scan` reads |

## What the GEO paper actually supports

The cross-engine rewrite tactics in `geo-citability` / `optimize-page` come from the
KDD 2024 paper, which proposes GEO and tests it on a multi-engine benchmark. The
methods it found effective are well-defined and are what we implement:

- **Cite sources** — attribute claims to credible references.
- **Add quotations** — include relevant quoted material.
- **Add statistics** — support claims with specific numbers.
- **Improve fluency / authoritative tone** — clear, confident, well-structured prose.

The paper also reports that naive **keyword stuffing did not help and tended to hurt**
generative-engine visibility — which is why none of these skills recommend it.

We implement the *tactics the paper validated*. We do **not** claim the paper validated
this repo, or that any specific percentage lift transfers to a given site — treat the
paper as the rationale for the tactics, not a performance guarantee.

## Where sources agree

- **Helpful, people-first, well-structured content wins.** All sources.
- **Crawlable, indexable pages are foundational** — if an engine can't fetch and parse
  the page, nothing else matters.
- **Manipulation backfires** — keyword stuffing, bought mentions, and scaled thin
  content are rejected by Google's spam guidance and unsupported by the research.

## Where they diverge (and our stance)

| Topic | Google says | Cross-engine research says | Our stance |
|---|---|---|---|
| `llms.txt` | Not used for Google AI surfaces | Useful signal for some non-Google crawlers | Generate it for non-Google crawlers; never claim it moves Google AI Overviews |
| Schema for AI search | Not *required* for AI search; good for rich results | Not required | Generate it for rich-result eligibility + entity clarity, not as an AI-ranking lever |
| Content chunking | Not needed for Google | Helps engines that retrieve by chunk | Optional; helps ChatGPT/Claude/Perplexity extraction, neutral-to-positive for Google |

## What we don't claim

- We don't claim Google (or any engine) endorses or has reviewed these skills.
- We don't claim to *directly query* ChatGPT / Claude / Gemini / Perplexity / Copilot.
  The dimensional audit reads public signals; the external benchmark reads Cloudflare's
  check. Live per-engine citation tracking is a different (paid, commercial) category.
- We don't treat any vendor's per-engine percentage as a model internal — engine
  ranking systems are not public.

## How to verify

Every substantive claim in a skill should trace to a source above (or to the underlying
primary source it cites). If you find one that doesn't, that's a bug —
[open an issue](https://github.com/techhorizonlabs/thl-open/issues).
