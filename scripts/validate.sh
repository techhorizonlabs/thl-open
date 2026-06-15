#!/usr/bin/env bash
# Pre-submission validator for THL Open.
# Enforces the THL Skill-Authoring Standard (docs/SKILL-AUTHORING-STANDARD.md)
# and the plugin manifest contract. Run before every commit; CI runs it on PRs.
#
#   bash scripts/validate.sh
#
# Exit 0 = all checks pass. Exit 1 = at least one failure (warnings don't fail).

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ok()   { printf "  \033[32m✓\033[0m %s\n" "$1"; }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAILED=$((FAILED+1)); }
warn() { printf "  \033[33m⚠\033[0m %s\n" "$1"; }
sect() { printf "\n\033[1m▶ %s\033[0m\n" "$1"; }

FAILED=0

sect "0. Preflight — required tooling"
PREFLIGHT_FAIL=0
for cmd in python3 grep sed; do
  command -v "$cmd" >/dev/null 2>&1 || { fail "missing required command: $cmd"; PREFLIGHT_FAIL=1; }
done
[[ $PREFLIGHT_FAIL -eq 0 ]] && ok "required tools on PATH (python3, grep, sed)"

sect "1. plugin.json + marketplace.json schemas"
python3 - <<'PY' && ok "manifests valid" || fail "manifest schema invalid"
import json, sys
try:
    p = json.load(open(".claude-plugin/plugin.json"))
    for k in ("name", "version", "description", "author"):
        assert k in p, f"plugin.json missing key: {k}"
    assert len(p["description"]) >= 60, "plugin.json description too short (<60 chars)"
    m = json.load(open(".claude-plugin/marketplace.json"))
    for k in ("name", "owner", "plugins"):
        assert k in m, f"marketplace.json missing key: {k}"
    assert isinstance(m["plugins"], list) and m["plugins"], "marketplace.json plugins[] empty"
    for plug in m["plugins"]:
        for k in ("name", "source", "version", "description"):
            assert k in plug, f"marketplace.json plugin entry missing key: {k}"
except Exception as e:
    print("   ", e, file=sys.stderr); sys.exit(1)
PY

sect "2. Manifest versions in lockstep"
PV=$(python3 -c "import json;print(json.load(open('.claude-plugin/plugin.json'))['version'])" 2>/dev/null)
MV=$(python3 -c "import json;print(json.load(open('.claude-plugin/marketplace.json'))['plugins'][0]['version'])" 2>/dev/null)
if [[ -n "$PV" && "$PV" == "$MV" ]]; then ok "plugin.json + marketplace.json both at $PV"
else fail "version drift: plugin.json=$PV vs marketplace.json=$MV"; fi

sect "3. Every skill has name + description frontmatter (P1)"
SKILL_FAIL=0
for f in skills/*/SKILL.md; do
  head -20 "$f" | grep -q '^name:'        || { fail "$f missing 'name:'"; SKILL_FAIL=1; }
  head -20 "$f" | grep -q '^description:' || { fail "$f missing 'description:'"; SKILL_FAIL=1; }
done
[[ $SKILL_FAIL -eq 0 ]] && ok "all $(ls -d skills/*/ | wc -l | tr -d ' ') skills have name + description"

sect "4. hooks.json schema (if present)"
if [[ -f hooks/hooks.json ]]; then
  python3 - <<'PY' && ok "hooks.json valid" || fail "hooks.json invalid"
import json,sys
h=json.load(open("hooks/hooks.json")); assert "hooks" in h
for _,defs in h["hooks"].items():
    for d in defs:
        for inner in d.get("hooks",[]):
            assert inner.get("type")=="command" and "command" in inner
PY
else
  ok "no hooks/ — nothing to check (THL Open ships no phone-home hook by design)"
fi

sect "5. No-login / no-telemetry posture (free, standalone)"
NL=0
[[ -f .mcp.json ]] && { fail ".mcp.json present — skills must not be gated behind a login MCP"; NL=1; }
[[ -d mcp-server ]] && { fail "mcp-server/ present — don't ship a gating server"; NL=1; }
HITS="$(grep -RIl --include='*.md' -E 'login required|sign in to use|requires_mcp: *true' skills docs 2>/dev/null || true)"
[[ -n "$HITS" ]] && { fail "login-gating language found:"; echo "$HITS" | sed 's/^/        /'; NL=1; }
[[ $NL -eq 0 ]] && ok "no login gating — every skill runs on the user's own session"

sect "6. Relative markdown links resolve (P4)"
python3 - <<'PY' && ok "all local markdown links resolve" || fail "broken local link(s) — see above"
import re, os, glob, sys
broken = []
files = glob.glob("**/*.md", recursive=True)
files = [f for f in files if "/references/" in f or f.count("/")<=1 or f.startswith(("skills/","docs/","examples/","evals/"))]
link = re.compile(r'\[[^\]]+\]\(([^)]+)\)')
for f in files:
    base = os.path.dirname(f)
    for m in link.finditer(open(f, encoding="utf-8", errors="replace").read()):
        t = m.group(1).split()[0]
        if t.startswith(("http://","https://","#","mailto:")): continue
        t = t.split("#")[0]
        if not t: continue
        # Only validate things that actually look like local file paths — skip bare
        # placeholders inside templates (e.g. "[Title](URL)", "[Name](path)").
        looks_like_path = t.startswith(("./","../")) or "/" in t or \
            re.search(r'\.(md|json|jsonld|ts|tsx|png|sh|txt|ya?ml)$', t)
        if not looks_like_path: continue
        if not os.path.exists(os.path.normpath(os.path.join(base, t))):
            broken.append(f"{f} -> {t}")
if broken:
    print("   " + "\n   ".join(broken[:40]), file=sys.stderr); sys.exit(1)
PY

sect "7. Leak-check (no client names / secrets — pre-publish gate)"
LEAK=0
# Client denylist — single tokens, matched as whole words (-w is portable BSD/GNU).
DENY='stonewell|heffernan|septech|kirbyko|dougall|laurene'
LH="$(grep -RIwniE --include='*.md' --include='*.ts' --include='*.tsx' --include='*.json' "$DENY" skills tools docs examples evals README.md CHANGELOG.md CONTRIBUTING.md 2>/dev/null || true)"
[[ -n "$LH" ]] && { fail "possible client-name leak:"; echo "$LH" | sed 's/^/        /'; LEAK=1; }
# Obvious secret shapes.
SH="$(grep -RInE --include='*.*' -e 'AKIA[0-9A-Z]{16}' -e '-----BEGIN [A-Z ]*PRIVATE KEY-----' -e 'sk-[A-Za-z0-9]{20,}' skills tools docs 2>/dev/null || true)"
[[ -n "$SH" ]] && { fail "possible secret:"; echo "$SH" | sed 's/^/        /'; LEAK=1; }
# Home paths — warn only (install instructions legitimately reference ~/.claude/skills).
PH="$(grep -RIlE --include='*.md' '/Users/[a-z]|/home/[a-z]' skills tools docs examples evals 2>/dev/null || true)"
[[ -n "$PH" ]] && warn "absolute home path(s) — confirm these are anti-pattern examples, not real paths: $(echo "$PH" | tr '\n' ' ')"
[[ $LEAK -eq 0 ]] && ok "no client names or secrets detected"

sect "8. Skill trigger-phrase overlap (P1 sibling distinction — warning only)"
python3 - <<'PY'
import glob, re
def triggers(text):
    sents = re.split(r'(?<=[.!?])\s+', text)
    keep = [s for s in sents if not any(m in s.lower() for m in
            ("do not invoke","don't invoke","not for","never invoke","only when","not whole-site"))]
    return set(p.strip().lower() for p in re.findall(r'"([^"]{3,60})"', " ".join(keep)))
skills={}
for f in sorted(glob.glob("skills/*/SKILL.md")):
    head=open(f,encoding="utf-8",errors="replace").read(3000)
    m=re.search(r'^description:\s*(.+?)(?=^\w+:|\n---)', head, re.M|re.S)
    if m: skills[f.split('/')[1]]=triggers(m.group(1))
names=list(skills); warned=0
for i,a in enumerate(names):
    for b in names[i+1:]:
        ov=skills[a]&skills[b]
        if len(ov)>=5:
            print(f"  \033[33m⚠\033[0m {a} ↔ {b} share {len(ov)} trigger phrases: {sorted(ov)[:3]}…"); warned+=1
if warned==0: print("  \033[32m✓\033[0m no high-overlap skill pairs (threshold 5+ shared triggers)")
PY

sect "9. claude plugin validate (optional)"
if command -v claude >/dev/null 2>&1; then
  claude plugin validate "$ROOT" >/tmp/thl-validate.log 2>&1 && ok "claude plugin validate passed" \
    || warn "claude plugin validate reported issues (see /tmp/thl-validate.log) — non-blocking"
else
  echo "  (claude CLI not on PATH — skipping)"
fi

echo
if [[ $FAILED -gt 0 ]]; then
  printf "\033[31m%d check(s) failed\033[0m\n" "$FAILED"; exit 1
fi
printf "\033[32mAll pre-submission checks passed.\033[0m\n"
