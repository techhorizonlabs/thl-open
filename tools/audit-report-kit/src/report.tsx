// THL-branded audit report → PDF via @react-pdf/renderer.
// Charts use react-pdf native primitives (View bars), not embedded SVG —
// reliable across the renderer's Flexbox layout (no echarts-embed gotcha).
// THL design language: white ground, charcoal ink, blue accent, numbered
// methodology, no gradients.

import {
  Document,
  Page,
  View,
  Text,
  StyleSheet,
  renderToFile,
} from "@react-pdf/renderer";
import type { AuditReport, CategoryScore, Finding } from "./sampleAudit.js";

const THL = {
  ink: "#1a1a2e",
  blue: "#6993ff",
  muted: "#6b7280",
  line: "#e2e8f0",
  track: "#eef1f6",
  danger: "#dc2626",
  amber: "#d97706",
  white: "#ffffff",
};

const styles = StyleSheet.create({
  page: { backgroundColor: THL.white, paddingHorizontal: 48, paddingVertical: 44, fontSize: 10, color: THL.ink, fontFamily: "Helvetica" },
  brandRow: { flexDirection: "row", justifyContent: "space-between", alignItems: "baseline", borderBottomWidth: 1, borderBottomColor: THL.line, paddingBottom: 10 },
  brand: { fontSize: 13, fontFamily: "Helvetica-Bold", color: THL.ink },
  brandSub: { fontSize: 8, color: THL.muted, textTransform: "uppercase", letterSpacing: 1 },
  tag: { fontSize: 8, color: THL.muted, textTransform: "uppercase", letterSpacing: 1, borderWidth: 1, borderColor: THL.line, borderRadius: 10, paddingVertical: 2, paddingHorizontal: 8 },
  h1: { fontSize: 26, fontFamily: "Helvetica-Bold", marginTop: 28, color: THL.ink },
  sub: { fontSize: 11, color: THL.muted, marginTop: 4 },
  scoreWrap: { flexDirection: "row", alignItems: "flex-end", marginTop: 24, marginBottom: 8 },
  scoreNum: { fontSize: 58, fontFamily: "Helvetica-Bold", color: THL.blue, lineHeight: 1 },
  scoreOf: { fontSize: 16, color: THL.muted, marginLeft: 6, marginBottom: 8 },
  scoreBand: { fontSize: 11, fontFamily: "Helvetica-Bold", color: THL.danger, marginLeft: 14, marginBottom: 12, textTransform: "uppercase", letterSpacing: 1 },
  sectionNum: { fontSize: 11, fontFamily: "Helvetica-Bold", color: THL.blue, letterSpacing: 1 },
  sectionTitle: { fontSize: 14, fontFamily: "Helvetica-Bold", color: THL.ink, marginLeft: 8 },
  sectionHead: { flexDirection: "row", alignItems: "baseline", marginTop: 26, borderTopWidth: 2, borderTopColor: THL.ink, paddingTop: 8 },
  barRow: { flexDirection: "row", alignItems: "center", marginTop: 10 },
  barLabel: { width: 110, fontSize: 9, color: THL.ink },
  barTrack: { flex: 1, height: 12, backgroundColor: THL.track, borderRadius: 2 },
  barScore: { width: 26, fontSize: 9, textAlign: "right", color: THL.muted, fontFamily: "Helvetica-Bold" },
  prov: { width: 64, fontSize: 7, textAlign: "right", color: THL.muted, textTransform: "uppercase", letterSpacing: 0.5 },
  findRow: { marginTop: 12, paddingLeft: 10, borderLeftWidth: 3 },
  findTitle: { fontSize: 10.5, fontFamily: "Helvetica-Bold", color: THL.ink },
  findDetail: { fontSize: 9, color: THL.muted, marginTop: 2, lineHeight: 1.4 },
  sev: { fontSize: 7.5, fontFamily: "Helvetica-Bold", textTransform: "uppercase", letterSpacing: 1, marginBottom: 2 },
  fixRow: { flexDirection: "row", marginTop: 10, alignItems: "flex-start" },
  fixRank: { width: 22, height: 22, borderRadius: 11, backgroundColor: THL.blue, color: THL.white, fontSize: 10, fontFamily: "Helvetica-Bold", textAlign: "center", paddingTop: 5 },
  fixBody: { marginLeft: 10, flex: 1 },
  fixAction: { fontSize: 10.5, fontFamily: "Helvetica-Bold", color: THL.ink },
  fixImpact: { fontSize: 9, color: THL.muted, marginTop: 1 },
  footer: { position: "absolute", bottom: 26, left: 48, right: 48, borderTopWidth: 1, borderTopColor: THL.line, paddingTop: 8, flexDirection: "row", justifyContent: "space-between" },
  footerText: { fontSize: 7.5, color: THL.muted },
});

function barColor(score: number): string {
  if (score < 40) return THL.danger;
  if (score < 70) return THL.amber;
  return THL.blue;
}

const PROV_LABEL: Record<NonNullable<CategoryScore["provenance"]>, string> = {
  scan: "scan",
  "partial-scan": "partial",
  heuristic: "heuristic",
  unmeasured: "unmeasured",
};

function sevColor(sev: Finding["severity"]): string {
  return sev === "critical" ? THL.danger : sev === "high" ? THL.amber : THL.muted;
}

function CategoryBar({ cat }: { cat: CategoryScore }) {
  const measured = typeof cat.score === "number";
  return (
    <View style={styles.barRow}>
      <Text style={styles.barLabel}>{cat.label}</Text>
      <View style={styles.barTrack}>
        {measured && (
          <View style={{ width: `${cat.score}%`, height: 12, backgroundColor: barColor(cat.score as number), borderRadius: 2 }} />
        )}
      </View>
      <Text style={styles.barScore}>{measured ? cat.score : "—"}</Text>
      {cat.provenance && <Text style={styles.prov}>{PROV_LABEL[cat.provenance]}</Text>}
    </View>
  );
}

function ReportDoc({ audit }: { audit: AuditReport }) {
  return (
    <Document title={`${audit.client.name} — AI-Visibility Audit`} author="Tech Horizon Labs">
      <Page size="A4" style={styles.page}>
        <View style={styles.brandRow}>
          <View style={{ flexDirection: "row", alignItems: "baseline" }}>
            <Text style={styles.brand}>Theo</Text>
            <Text style={{ ...styles.brandSub, marginLeft: 6 }}>by Tech Horizon Labs</Text>
          </View>
          <Text style={styles.tag}>AI-Visibility Audit</Text>
        </View>

        <Text style={styles.h1}>{audit.client.name}</Text>
        <Text style={styles.sub}>{audit.client.domain} · {audit.client.location} · {audit.generatedAt}</Text>

        <View style={styles.scoreWrap}>
          <Text style={styles.scoreNum}>{audit.composite}</Text>
          <Text style={styles.scoreOf}>/ 100</Text>
          <Text style={styles.scoreBand}>{audit.band}</Text>
        </View>
        <Text style={{ fontSize: 10, color: THL.muted, lineHeight: 1.4 }}>
          {audit.summary ??
            "This score is the baseline for how visible the business is to AI answer engines. The ranked fix sequence below moves it, and the re-audit proves the delta."}
        </Text>

        <View style={styles.sectionHead}>
          <Text style={styles.sectionNum}>01</Text>
          <Text style={styles.sectionTitle}>Category breakdown</Text>
        </View>
        {audit.categories.map((c) => <CategoryBar key={c.key} cat={c} />)}

        <View style={styles.sectionHead}>
          <Text style={styles.sectionNum}>02</Text>
          <Text style={styles.sectionTitle}>What we found</Text>
        </View>
        {audit.findings.map((f, i) => (
          <View key={i} style={{ ...styles.findRow, borderLeftColor: sevColor(f.severity) }}>
            <Text style={{ ...styles.sev, color: sevColor(f.severity) }}>{f.severity}</Text>
            <Text style={styles.findTitle}>{f.title}</Text>
            <Text style={styles.findDetail}>{f.detail}</Text>
          </View>
        ))}

        <View style={styles.sectionHead}>
          <Text style={styles.sectionNum}>03</Text>
          <Text style={styles.sectionTitle}>Ranked fix sequence</Text>
        </View>
        {audit.fixSequence.map((s) => (
          <View key={s.rank} style={styles.fixRow}>
            <Text style={styles.fixRank}>{s.rank}</Text>
            <View style={styles.fixBody}>
              <Text style={styles.fixAction}>{s.action}</Text>
              <Text style={styles.fixImpact}>{s.impact}</Text>
            </View>
          </View>
        ))}

        <View style={styles.footer} fixed>
          <Text style={styles.footerText}>Tech Horizon Labs · Theo platform</Text>
          <Text style={styles.footerText}>Built on Claude + Cloudflare · confidential to {audit.client.name}</Text>
        </View>
      </Page>
    </Document>
  );
}

export async function renderAuditReport(audit: AuditReport, outPath: string): Promise<void> {
  await renderToFile(<ReportDoc audit={audit} />, outPath);
}
