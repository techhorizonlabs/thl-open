# Security

## Reporting a vulnerability

Please report security issues **privately** — do not open a public issue.

Email **security@techhorizonlabs.com** with a description, reproduction steps, and the
affected file(s). We aim to acknowledge within a few business days.

## What to keep in mind when running these skills

This repo is Claude Code skills (markdown that instructs an agent) plus one small Node
tool. There's no server and no bundled binary, but skills **do** direct an agent to run
shell commands and fetch the open web. Two things follow:

- **Read a skill before you install it.** A skill can run code on your machine through
  the agent. These are short and auditable — read `SKILL.md` and any `scripts/`.
- **Fetched web content is data, not instructions.** Our crawler / brand-mention skills
  pull public pages. A page could contain text crafted to look like instructions
  (prompt injection). The skills are written to treat fetched content as data to
  analyse, never as commands to follow — and we ask contributions to hold the same line
  (see the security rule in the [Skill-Authoring Standard](docs/SKILL-AUTHORING-STANDARD.md)).

## What this project does NOT do

- **No telemetry.** Nothing here phones home. There is no analytics POST, no install
  beacon, no usage tracking. (This is a deliberate choice — see
  [`docs/HOW-WE-COMPARE.md`](docs/HOW-WE-COMPARE.md).)
- **No login / no gating.** Every skill runs on your own Claude Code session model. The
  validator (`scripts/validate.sh` §5) enforces that no login-gating ships.
- **No secrets in the repo.** The validator leak-checks for client names and secret
  shapes before anything ships.
