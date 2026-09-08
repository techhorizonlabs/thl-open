# Static skill scan — 9 September 2026 AEST

**17 skills scanned; 22 MEDIUM findings, 17 INFO findings, zero HIGH/CRITICAL
findings, zero scan errors.** This is a completed static scan, not a clean verdict
or security certification. [Sanitized results](static-skill-scan-2026-09-09.json).

Target: `techhorizonlabs/thl-open` commit
`563d77af09ba38a1dfd62b92486fc223bf2a6395`. Scanner: [Cisco AI Defense skill-scanner](https://github.com/cisco-ai-defense/skill-scanner)
commit `431cb58a5ac333bc0bb9aaa23f7c30ac628f59f8`, bundled static signatures and YARA
only. Dependencies used exact versions and wheel hashes.

The MEDIUM findings comprise 10 outbound-network primitives, 2 network/tool
declaration warnings and 10 dependency version-range warnings in the GEO skill.
Website-fetching primitives are expected capabilities, but remain relevant to
runtime isolation. The version-range warnings require a reviewed deployment lock.
The 17 INFO findings concern per-skill license metadata, not absence of a repository
license. No findings were suppressed to make this report look clean.

Analysis ran locally with network and process creation denied by macOS sandbox
policy, plus a Python audit guard. The JSON conservatively labels the portable
wrapper invocation as Python-audit-only because the external macOS policy is not
verified by that wrapper. An inert positive control produced HIGH/CRITICAL findings;
its target-execution marker remained absent. Target skill scripts were never run.

The accompanying weekly GitHub workflow instead requires a verified Linux network
namespace, drops back to the runner UID without capabilities and clears the scanner
environment. It fails if that OS boundary cannot be established. Its hosted Linux
run is pending the first reviewed branch run; this dated report does not claim CI
has already executed successfully.

Coverage excludes LLM, behavioral, cloud-service, cross-skill, installed-MCP and
web-application testing. Dependency downloads happen during preparation, before
network-isolated analysis. Neither the local process nor the hosted runner is an
adversarial-host or complete filesystem sandbox. Results retain rule IDs and
relative locations, omit snippets and free-form metadata, and distinguish scan
errors from findings. See [runner documentation](../../tools/skill-scan/README.md).
