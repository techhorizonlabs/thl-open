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

## Notes

- Libraries: `@react-pdf/renderer` (MIT), `schema-dts` (Apache-2.0), `react` — all permissive.
- `@react-pdf/renderer` lays out with Flexbox, **not** a browser engine (no CSS Grid / `position:absolute`). For pixel-perfect, table-heavy reports that must match a website, render HTML/CSS via Puppeteer or Gotenberg instead and keep this for fast, templated packs.

MIT — Tech Horizon Labs.
