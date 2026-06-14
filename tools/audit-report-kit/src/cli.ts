// Generate a sample audit PDF + JSON-LD. Run: npm run report
import { mkdirSync, writeFileSync } from "node:fs";
import { sampleAudit } from "./sampleAudit.js";
import { renderAuditReport } from "./report.js";
import { generateOrgJsonLd } from "./jsonld.js";

mkdirSync("out", { recursive: true });

await renderAuditReport(sampleAudit, "out/harborview-audit.pdf");

const jsonld = generateOrgJsonLd({
  name: sampleAudit.client.name,
  url: `https://${sampleAudit.client.domain}`,
  telephone: "+61 7 5000 0000",
  description: "General insurance brokerage serving SE Queensland businesses.",
  streetAddress: "1 Marine Parade",
  locality: "Gold Coast",
  region: "QLD",
  postalCode: "4217",
  areaServed: ["Gold Coast", "Brisbane", "Queensland"],
  sameAs: [
    "https://www.linkedin.com/company/harborview-brokers",
    "https://www.google.com/maps?cid=000000000000",
  ],
});
writeFileSync("out/harborview.jsonld", JSON.stringify(jsonld, null, 2));

console.log("Wrote out/harborview-audit.pdf and out/harborview.jsonld");
