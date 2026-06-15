# Audit Report Kit

Turn an AI-visibility / GEO audit's JSON into a polished, branded **client PDF** + compile-checked **JSON-LD**.

| File | What it is |
|---|---|
| `src/sampleAudit.ts` | The audit JSON shape, with a fictional sample (no real client data) |
| `src/report.tsx` | The PDF document — `@react-pdf/renderer`, native primitives for charts |
| `src/jsonld.ts` | schema.org `Organization` / `LocalBusiness` JSON-LD via `schema-dts` (type-checked) |
| `src/cli.ts` | Generates `out/harborview-audit.pdf` + `out/harborview.jsonld` |

## Run

```bash
npm install
npm run report    # writes out/*.pdf and out/*.jsonld
npm run build     # tsc --noEmit (also validates the JSON-LD types)
```

## Example output

The PDF this produces is the report pictured in the [repo README](../../README.md). The JSON-LD
half is committed as a worked sample — [`examples/harborview.jsonld`](examples/harborview.jsonld),
the schema the audit recommends for a (fictional) insurance broker, type-checked against
`schema-dts`:

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Harborview Insurance Brokers",
  "url": "https://harborview-brokers.com.au",
  "telephone": "+61 7 5000 0000",
  "address": { "@type": "PostalAddress", "addressLocality": "Gold Coast", "addressRegion": "QLD", "addressCountry": "AU" },
  "areaServed": ["Gold Coast", "Brisbane", "Queensland"],
  "sameAs": ["https://www.linkedin.com/company/harborview-brokers", "..."]
}
```

That's the artifact a client's developer pastes into the site `<head>` — generated, not
hand-written, so it can't drift from the audit's recommendation.

## Notes

- Libraries: `@react-pdf/renderer` (MIT), `schema-dts` (Apache-2.0), `react` — all permissive.
- `@react-pdf/renderer` lays out with Flexbox, **not** a browser engine (no CSS Grid / `position:absolute`). For pixel-perfect, table-heavy reports that must match a website, render HTML/CSS via Puppeteer or Gotenberg instead and keep this for fast, templated packs.

MIT — Tech Horizon Labs.
