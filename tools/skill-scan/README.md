# Static public-skill scan

The weekly/manual/changed-files PR workflow scans every immediate `skills/*/SKILL.md`
directory. At least 17 skills are expected; additional skills are included rather
than ignored. Fewer than 17, per-skill exceptions, missing YARA, failed positive
control or an unavailable boundary are scan errors (exit 2). Findings alone do not
fail the completion job (exit 0), **including MEDIUM/HIGH/CRITICAL findings**: read
the counts and triage the artifact, not the green job icon. This workflow is an
observation/report, not an automatic security approval or merge gate.

## Inputs and boundaries

- Official source is pinned to `cisco-ai-defense/skill-scanner`
  `431cb58a5ac333bc0bb9aaa23f7c30ac628f59f8`. The launcher verifies that SHA and
  tracked/untracked source cleanliness. Checkouts do not persist Git credentials.
- Python 3.13.14 and hash-locked, binary-only static dependencies. The scanner is
  imported from source; its package build hooks and target package installers do
  not execute. The supplied `requirements.in`, exported `upstream-lock.txt`, and
  `requirements.txt` preserve the existing static-subset resolution against the
  pinned upstream lock. Preparation accesses GitHub/PyPI; analysis does not.
- Linux launcher uses `sudo unshare --net` only to create a separate namespace,
  then drops to the original UID/GID, clears supplementary groups/capabilities and
  enables no-new-privileges. Python verifies a namespace different from the launcher's pre-unshare namespace,
  only loopback present, and loopback down. Failure stops the scan; no CI fallback.
- The scanner receives an empty environment except a dedicated HOME, PATH and
  bytecode setting. A Python audit hook additionally rejects network connections,
  DNS resolution and process creation. This hook is defense in depth, not an OS
  sandbox against malicious native extensions. There is no claimed filesystem
  isolation, separate trust domain from the hosted runner, or adversarial-host
  protection. Dependencies/scanner code are trusted executable inputs; skills are
  inspected as text/AST and never executed. Target symlinks are rejected.
- Only `StaticAnalyzer(use_yara=True)` runs. An inert synthetic positive control
  must produce HIGH/CRITICAL findings while leaving its execution marker absent.
  No LLM keys, VirusTotal/cloud/behavioral analyzer, installed MCP or application
  account is used. The GitHub job grants only `contents: read`; artifact upload is
  the intended reporting side effect, and no code/security-events/token write
  permission, repository secret or email action is requested.

## Results

Every run uploads `results.json` and a dated `summary.md` and appends the summary to
GitHub's job summary. Both show scanner errors separately from findings; preparation
and isolation-launch errors retain a phase-marked artifact. Individual errors expose
only exception type, not potentially private exception text. Finding fields are
limited to rule IDs, severity and relative locations, with no snippets or arbitrary
metadata. Artifact retention is 90 days. The workflow never commits reports back to
the repository. The checked-in dated report is a reviewed local snapshot, not a
claim that monitoring had already run before the workflow was merged.

## Reproduce on Linux

Use fresh public checkouts of this repository and the exact scanner commit. Create
a dedicated venv with Python 3.13.14, then:

```sh
python -m venv /tmp/skill-venv
/tmp/skill-venv/bin/python -m pip --isolated install --require-hashes --only-binary=:all: \
  -r tools/skill-scan/requirements.txt
python -m unittest discover -s tools/skill-scan -p 'test_*.py'
tools/skill-scan/run-linux.sh /path/to/scanner-source "$PWD" /tmp/skill-venv /tmp/skill-results
```

Linux util-linux (`unshare`, `setpriv`) and noninteractive sudo are required. Target
and scanner code must be clean. The direct Python `--boundary python-audit-only`
option exists for an independently constrained local validation environment; it
explicitly reports **no OS boundary asserted** and is never used by CI. A successful
local run does not establish that a hosted Linux runner supports namespace creation;
the first hosted run remains required evidence before claiming the schedule works.
