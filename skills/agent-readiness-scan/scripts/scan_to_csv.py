#!/usr/bin/env python3
"""Convert isitagentready.com /api/scan JSON to the fixed Theo-audit CSV schema.

Usage: scan_to_csv.py <iar_scan.json> --score N [--out checks.csv] [--date YYYY-MM-DD]
The 0-100 score comes from the web UI dial (Playwright), not the JSON — pass it in.
"""
import argparse, csv, json, sys
from datetime import date
from pathlib import Path

# Fixed display names — cross-client comparability depends on these exact labels.
CATEGORY_NAMES = {
    "discoverability": "Discoverability",
    "contentAccessibility": "Content Accessibility",
    "botAccessControl": "Bot Access Control",
    "discovery": "API Auth MCP & Skill Discovery",
    "commerce": "Commerce",
}
CHECK_NAMES = {
    "sitemap": "Sitemap", "robotsTxt": "robots.txt",
    "linkHeaders": "Link response headers", "dnsAid": "DNS for AI Discovery (DNS-AID)",
    "markdownNegotiation": "Markdown content negotiation",
    "robotsTxtAiRules": "AI bot rules in robots.txt", "contentSignals": "Content Signals",
    "webBotAuth": "Web Bot Auth", "a2aAgentCard": "A2A Agent Card",
    "mcpServerCard": "MCP Server Card", "oauthDiscovery": "OAuth / OIDC discovery",
    "oauthProtectedResource": "OAuth Protected Resource", "authMd": "Auth.md agent registration",
    "agentSkills": "Agent Skills index", "webMcp": "WebMCP", "apiCatalog": "API Catalog",
}

def title_from_key(key: str) -> str:
    out = []
    for ch in key:
        out.append(" " + ch if ch.isupper() and out else ch)
    return "".join(out).strip().capitalize()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("scan_json")
    ap.add_argument("--score", required=True, help="0-100 score from the web UI dial")
    ap.add_argument("--out", default="agent_readiness_checks.csv")
    ap.add_argument("--date", default=date.today().isoformat())
    args = ap.parse_args()

    scan = json.loads(Path(args.scan_json).read_text())
    host = scan["url"].split("//")[-1].split("/")[0]
    level, level_name = scan.get("level"), scan.get("levelName", "")
    is_commerce = scan.get("isCommerce", False)

    rows, passes, fails = [], 0, 0
    for cat_key, checks in scan.get("checks", {}).items():
        cat_name = CATEGORY_NAMES.get(cat_key, title_from_key(cat_key))
        if cat_key == "commerce" and not is_commerce:
            rows.append((cat_name, "x402 / MPP / UCP / ACP", "NOT CHECKED",
                         "no e-commerce signals detected; informational only, does not affect score",
                         "isitagentready.com"))
            continue
        cat_rows, cat_pass, cat_scored = [], 0, 0
        for chk_key, chk in checks.items():
            status = (chk.get("status") or "").lower()
            result = {"pass": "PASS", "fail": "FAIL"}.get(status, "NOT CHECKED")
            if result in ("PASS", "FAIL"): cat_scored += 1
            if result == "PASS": passes += 1; cat_pass += 1
            elif result == "FAIL": fails += 1
            detail = (chk.get("message") or "").replace("\n", " ").strip()
            cat_rows.append([CHECK_NAMES.get(chk_key, title_from_key(chk_key)), result, detail,
                             f"isitagentready.com + curl {args.date}"])
        # Tally counts scored checks only — `neutral`/`skip` are excluded.
        tally = f"{cat_name} ({cat_pass}/{cat_scored})"
        rows.extend((tally, *r) for r in cat_rows)

    # Supplementary probes (run_scan.sh output alongside the scan JSON)
    supp_path = Path(args.scan_json).parent / "supplementary.json"
    if supp_path.exists():
        supp = json.loads(supp_path.read_text())
        for key, label, path in (("llms_txt", "llms.txt", "/llms.txt"),
                                 ("llms_full_txt", "llms-full.txt", "/llms-full.txt"),
                                 ("security_txt", "/.well-known/security.txt", "/.well-known/security.txt")):
            code = supp.get(key, "")
            present = code.startswith("2")
            rows.append(("Supplementary (not scored)", label,
                         "PRESENT" if present else "ABSENT",
                         f"https://{host}{path} returns {code}",
                         f"curl {args.date}"))

    commerce_note = "Commerce applicable" if is_commerce else "Commerce not applicable"
    overall = ("OVERALL", "Agent-readiness score",
               f"{args.score}/100 - Level {level} {level_name}",
               f"{passes} pass / {fails} fails; {commerce_note}",
               f"isitagentready.com/{host} (Cloudflare) {args.date}")

    out = Path(args.out); out.parent.mkdir(parents=True, exist_ok=True)
    with out.open("w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["category", "check", "result", "detail", "source"])
        w.writerow(overall)
        w.writerows(rows)
    print(f"{out}: OVERALL {args.score}/100 Level {level} {level_name} — {passes} pass / {fails} fails, {len(rows)} rows")

if __name__ == "__main__":
    sys.exit(main())
