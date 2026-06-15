# THL Audit Checklist + QA

A copy-able checklist for a GEO audit run. Tick each item — its purpose is to stop a
dimension being silently skipped and to catch inconsistent facts before a report reaches
a client. (THL-original addition to this fork.)

## Per-dimension — every one must be scored, with evidence

- [ ] **AI Citability** scored 0–100, with 2–3 quoted passages that justify the score
- [ ] **Brand Authority** scored, with the platform-presence map (YouTube/Reddit/Wikipedia/LinkedIn)
- [ ] **Content E-E-A-T** scored, with author/credential/citation evidence
- [ ] **Technical GEO** scored, with the robots.txt / llms.txt / rendering findings
- [ ] **Schema & Structured Data** scored, with the schema types found + missing
- [ ] **Platform Optimization** scored, per target engine
- [ ] **Composite** computed with the fixed formula (weights unchanged from the skill's table)

## External benchmark (THL)

- [ ] `agent-readiness-scan` run → Cloudflare 0–100 captured as an independent cross-check
- [ ] On a re-audit: both the composite and the readiness score recorded as a **delta** vs last cycle

## Cross-check before delivery (consistency catches real errors)

- [ ] The same entity facts (name, address, ABN/registration, phone) appear verbatim in every section
- [ ] The same citation positions appear across the citability, benchmark, and platform sections
- [ ] The same technical numbers (LCP, crawler status) appear across the technical section and any chart
- [ ] No `{{PLACEHOLDER}}` / `REPLACE_WITH_*` strings remain
- [ ] Any unverified fact (logo URL, social handle, registration number) is flagged, not fabricated
- [ ] Dates are this audit cycle (not copied from a prior one)

## Deliverable (THL)

- [ ] Audit JSON assembled → `tools/audit-report-kit` produces the branded PDF
- [ ] Recommended schema emitted as compile-checked JSON-LD (ready for the client's dev to paste)
- [ ] A re-audit date set so the delta can be measured

## Discipline

A finished audit is not "the audit ran." It is: every category scored, every score traceable to
evidence, the report renders, the JSON-LD validates. Verify the artifacts, not the exit.
