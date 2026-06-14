#!/usr/bin/env bash
# Agent-readiness scan: official API + supplementary curl evidence.
# Usage: run_scan.sh <url> <raw-data-outdir>
# 404s are expected outcomes, not errors — so no `set -e`.
set -uo pipefail

URL="${1:?usage: run_scan.sh <url> <outdir>}"
OUT="${2:?usage: run_scan.sh <url> <outdir>}"
mkdir -p "$OUT"
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) THL-audit"

echo "[1/3] Official scan via isitagentready.com API..."
curl -s -X POST "https://isitagentready.com/api/scan" \
  -H "content-type: application/json" \
  --data "{\"url\":\"${URL}\"}" -o "$OUT/iar_scan.json" --max-time 120

CANON=$(jq -r '.url // empty' "$OUT/iar_scan.json")
if [ -z "$CANON" ]; then
  echo "ERROR: scan returned no canonical url — inspect $OUT/iar_scan.json" >&2
  head -c 400 "$OUT/iar_scan.json" >&2; exit 1
fi
HOST=$(echo "$CANON" | sed -E 's#https?://##; s#/.*##')
echo "  level=$(jq -r '.levelName' "$OUT/iar_scan.json") canonical=$CANON"

echo "[2/3] Corroborating curl matrix against $CANON ..."
curl -sI -A "$UA" "$CANON" -o "$OUT/homepage_headers.txt" --max-time 30
curl -sI -A "$UA" -H "Accept: text/markdown" "$CANON" -o "$OUT/accept_markdown_headers.txt" --max-time 30
curl -s  -A "$UA" -H "Accept: text/markdown" "$CANON" --max-time 30 | head -c 4000 > "$OUT/accept_markdown_body.txt"
curl -s  -A "$UA" "${CANON%/}/robots.txt"  -o "$OUT/robots.txt"  --max-time 30
curl -s  -A "$UA" "${CANON%/}/sitemap.xml" -o "$OUT/sitemap.xml" --max-time 30

echo "[3/3] Supplementary (not scored) probes..."
probe() { curl -s -o "$OUT/$2" -w "%{http_code}" -A "$UA" "${CANON%/}$1" --max-time 30; }
LLMS=$(probe /llms.txt llms.txt)
LLMSF=$(probe /llms-full.txt llms_full.txt)
SEC=$(probe /.well-known/security.txt wellknown_security.txt)
MCP=$(probe /.well-known/mcp.json wellknown_mcp.txt)
OAUTH=$(probe /.well-known/oauth-authorization-server wellknown_oauth.txt)

jq -n --arg llms "$LLMS" --arg llmsf "$LLMSF" --arg sec "$SEC" \
      --arg mcp "$MCP" --arg oauth "$OAUTH" --arg host "$HOST" \
  '{host:$host, llms_txt:$llms, llms_full_txt:$llmsf, security_txt:$sec,
    wellknown_mcp:$mcp, wellknown_oauth:$oauth}' > "$OUT/supplementary.json"

echo "DONE. host=$HOST  llms.txt=$LLMS llms-full=$LLMSF security.txt=$SEC"
echo "Next: Playwright → https://isitagentready.com/$HOST for the 0-100 score, then scan_to_csv.py"
