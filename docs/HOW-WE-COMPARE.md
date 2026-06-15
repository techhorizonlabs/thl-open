# How THL Open compares

An honest look at where this repo sits in the open-source GEO / AI-visibility
landscape. We'd rather you pick the right tool than oversell ours — and being
straight about the alternatives is the same standard we hold on
[attribution](../NOTICE.md).

## The short version

THL Open is a **Claude Code skill suite plus a consulting method**. You give an agent
the capability to *run* an AI-visibility audit, then hand a client a branded report.
It is not a standalone scoring CLI, and it doesn't try to be one. If you want a
CI-runnable Python scorer, or live "is my brand cited" tracking, the tools below do
that better — and they pair well with this.

## The main open alternative

**[`Auriti-Labs/geo-optimizer-skill`](https://github.com/Auriti-Labs/geo-optimizer-skill)
("GEO Optimizer" / GeoReady)** — MIT, actively maintained, the most directly
comparable open project. It's a Python tool (`uvx … geo audit --url …`) with a CLI,
a Python library, an MCP server, and an Astro integration; 8 scoring categories, a
large test suite, academic grounding, and a `geo citations` command that queries real
answer engines to check whether you're actually cited. There's a freemium SaaS on top.

**Where GEO Optimizer is ahead, plainly:**

- **Live citation checking.** Its `geo citations` queries ChatGPT / Perplexity /
  others to see if your brand is mentioned and your domain cited. This repo's
  `geo-brand-mentions` analyses presence and authority signals; it does not query
  answer engines live. If that feature is what you need, use theirs.
- **CI / programmatic surface.** PyPI install, MCP server, Astro plugin, heavy test
  coverage — built to drop into a build pipeline.
- **Maturity signals.** More stars, more tests, more release cadence.

## Where THL Open is different (not "better" — different job)

- **Native Claude Code skills, not a binary.** These run *inside* the agent's
  reasoning loop and compose with whatever else the agent is doing. The unit of
  delivery is "your agent can now do this," not "run this command."
- **A method, not just a score.** The [THL GEO Method](THL-GEO-METHOD.md) orchestrates
  three layers — dimensional audit, an *independent* external benchmark, and a
  client deliverable — with a fixed-formula scoring discipline. The repeatability is
  the product.
- **An independent external benchmark.** [`agent-readiness-scan`](../skills/agent-readiness-scan)
  pulls Cloudflare's public `isitagentready.com` score as a third-party cross-check —
  a number the audit can't give itself. Most tools self-score; we add an outside one
  and track the delta.
- **A client-ready deliverable.** [`audit-report-kit`](../tools/audit-report-kit)
  produces a branded PDF plus compile-checked JSON-LD aimed at a consulting handoff,
  not a developer's terminal.
- **Verify-the-artifact discipline + evals.** We treat "a run happened" as not yet a
  result (see [`evals/`](../evals)).

## Complements worth adopting (permissive licences)

These aren't competitors — they're good building blocks for a GEO pipeline:

- **[`AnswerDotAI/llms-txt`](https://github.com/AnswerDotAI/llms-txt)** (Apache-2.0) —
  the reference `llms.txt` spec + parser. Align your validator to its grammar.
- **[`google/schema-dts`](https://github.com/google/schema-dts)** (Apache-2.0) — the
  type-checked Schema.org JSON-LD we already use in `audit-report-kit`.
- **[Crawl4AI](https://github.com/unclecode/crawl4ai)** (Apache-2.0),
  **[Unlighthouse](https://github.com/harlan-zw/unlighthouse)** (MIT),
  **[Lighthouse](https://github.com/GoogleChrome/lighthouse)** (Apache-2.0) — crawling
  and site-wide performance/a11y passes that feed the technical dimension.

## Licence cautions

If you assemble your own pipeline, keep it permissive. A few popular pieces are
**not** safe to bundle into an MIT project: **Firecrawl's engine** (AGPL-3.0) and
**QuickChart** (AGPL) are the common traps; prefer the Apache/MIT alternatives above.
Anthropic's example skills are Apache-2.0, but its document skills
(`docx`/`pdf`/`pptx`/`xlsx`) are source-available — reference, don't redistribute.

---

*Spotted something inaccurate about another project? Open an issue. We'd rather fix it
than leave it wrong.*
