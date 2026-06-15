// Fictional sample audit — anonymized broker. No real client data.
// This is the shape Theo's audit pipeline would emit and the report renders.

// `provenance` is optional and, when set, renders as a small muted tag beside the bar.
// [scan] = scored from data fetched this run · [partial-scan] = some pages sampled ·
// [heuristic] = model judgement, no data fetched · [unmeasured] = data source unavailable.
// When a category is [unmeasured] or pure [heuristic], set `score: null` and the bar
// renders "—" instead of an invented number (see THL GEO Method, scoring discipline).
export type Provenance = "scan" | "partial-scan" | "heuristic" | "unmeasured";
export type CategoryScore = {
  key: string;
  label: string;
  score: number | null;
  provenance?: Provenance;
};
export type Finding = {
  severity: "critical" | "high" | "medium";
  title: string;
  detail: string;
};
export type FixStep = { rank: number; action: string; impact: string };

export type AuditReport = {
  client: { name: string; domain: string; location: string };
  composite: number; // 0–100
  band: string;
  generatedAt: string; // ISO date
  categories: CategoryScore[];
  findings: Finding[];
  fixSequence: FixStep[];
};

export const sampleAudit: AuditReport = {
  client: {
    name: "Harborview Insurance Brokers",
    domain: "harborview-brokers.com.au",
    location: "Gold Coast, QLD",
  },
  composite: 38,
  band: "Critical",
  generatedAt: "2026-06-14",
  categories: [
    { key: "citability", label: "AI Citability", score: 31 },
    { key: "crawlers", label: "Crawler Access", score: 48 },
    { key: "schema", label: "Schema Markup", score: 8 },
    { key: "content", label: "Content E-E-A-T", score: 44 },
    { key: "technical", label: "Technical SEO", score: 57 },
  ],
  findings: [
    {
      severity: "critical",
      title: "No Organization or Service JSON-LD",
      detail:
        "AI engines cannot resolve the firm as an entity. This is the single highest-leverage fix and gates citability.",
    },
    {
      severity: "high",
      title: "2 of 8 AI crawlers blocked by robots.txt",
      detail: "GPTBot and ClaudeBot are disallowed, removing the firm from two major answer engines.",
    },
    {
      severity: "high",
      title: "Service pages too thin to cite",
      detail: "Median service-page body is 180 words; AI answers favour pages with depth and specifics.",
    },
    {
      severity: "medium",
      title: "DMARC not published",
      detail: "SPF and DKIM pass; DMARC is absent, weakening sender trust and deliverability.",
    },
  ],
  fixSequence: [
    { rank: 1, action: "Deploy Organization + Service JSON-LD", impact: "Unlocks entity resolution; largest citability gain" },
    { rank: 2, action: "Open robots.txt to GPTBot + ClaudeBot", impact: "Restores presence in two answer engines" },
    { rank: 3, action: "Expand the six core service pages", impact: "Makes pages citable; lifts content E-E-A-T" },
    { rank: 4, action: "Publish a DMARC policy (p=quarantine)", impact: "Improves sender trust + deliverability" },
  ],
};
