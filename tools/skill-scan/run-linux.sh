#!/usr/bin/env bash
set -euo pipefail
# SOURCE and TARGET are separate, reviewed checkouts. No target script runs.
if [[ $# != 4 ]]; then echo 'usage: run-linux.sh SOURCE TARGET VENV OUTPUT' >&2; exit 2; fi
SOURCE=$(cd "$1" && pwd)
TARGET=$(cd "$2" && pwd)
VENV=$(cd "$3" && pwd)
mkdir -p "$4/home"
OUTPUT=$(cd "$4" && pwd)
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
[[ $(uname -s) == Linux ]] || { echo 'Linux network isolation required; no fallback' >&2; exit 2; }
[[ $(git -C "$SOURCE" rev-parse HEAD) == 431cb58a5ac333bc0bb9aaa23f7c30ac628f59f8 ]]
git -C "$SOURCE" diff --quiet HEAD -- .
# Untracked scanner code could shadow trusted imports.
[[ -z $(git -C "$SOURCE" ls-files --others --exclude-standard) ]]
git -C "$TARGET" diff --quiet HEAD -- skills
[[ -z $(git -C "$TARGET" ls-files --others --exclude-standard -- skills) ]]
TARGET_COMMIT=$(git -C "$TARGET" rev-parse HEAD)
# Setup/preflight failures still leave a separately identifiable error artifact.
printf '%s\n' '{"errors":1,"phase":"network-isolation-launch","results":[]}' > "$OUTPUT/results.json"
# Hosted Linux job needs sudo only to create the namespace; analysis returns to
# runner uid/gid, clears groups/capabilities, and cannot gain privileges.
exec sudo -n unshare --net -- \
  setpriv --reuid="$(id -u)" --regid="$(id -g)" --clear-groups --bounding-set=-all --no-new-privs \
  env -i PATH="$VENV/bin:/usr/bin:/bin" HOME="$OUTPUT/home" PYTHONDONTWRITEBYTECODE=1 \
  "$VENV/bin/python" "$SCRIPT_DIR/scan.py" --source "$SOURCE" --target "$TARGET" \
    --target-commit "$TARGET_COMMIT" --output "$OUTPUT" --boundary linux-netns
