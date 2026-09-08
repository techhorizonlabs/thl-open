# Reproducible GEO Python environment

`requirements.txt` is the supported-range input. It is unchanged by this lock. `requirements-deploy.txt` is an exact, hash-checked resolution of all 10 direct dependencies and their transitive dependencies for a Python 3.13 deployment. It was resolved universally across platforms; installation and offline behavior checks were exercised on CPython 3.13.14 / macOS arm64. Other OS/architecture combinations require their own install/smoke check before use. The lock does not promise support for additional Python versions.

From this directory, use a fresh virtual environment:

```sh
python3.13 -m venv .venv
.venv/bin/python -m pip install --require-hashes --only-binary=:all: -r requirements-deploy.txt
.venv/bin/python -m pip check
.venv/bin/python -m unittest discover -s tests -p 'test_*.py' -v
```

Hash checking rejects unlisted artifacts; binary-only installation rejects source builds instead of invoking package build hooks. It does not certify that the permitted artifacts have no vulnerabilities. Do not append unpinned packages to this installation. Playwright's Python package is locked, but browser executables are separate artifacts: no browser download or browser-based website test is covered by this validation.

## Updating the lock

With `uv`, regenerate from the unchanged range input (or a separately reviewed range change):

```sh
uv pip compile requirements.txt --python-version 3.13 --universal --generate-hashes --output-file requirements-deploy.txt
```

Review the version/hash diff, current vulnerability advisories, and compatibility changes. Install into a new environment with hash enforcement and run the offline smoke suite before adopting a new lock. Record the Python version and platform tested. The committed lock is the reproducible artifact; regenerating it later may select newer versions allowed by the input ranges.

The tests exercise HTML/JSON-LD parsing with BeautifulSoup/lxml, Requests error handling, llms.txt generation/validation, and real ReportLab PDF output. All HTTP responses are mocked and real socket connections are blocked. They do not exercise browser binaries or every optional CLI/tool exposed by the broader skill suite.

The scanner's unpinned-range warnings can still describe `requirements.txt` accurately. This deployment lock supplies the pinned installation path; it does not suppress those warnings or the expected networking findings. Network behavior and the absence of comprehensive SSRF protections are documented in [SKILL.md](SKILL.md#installation-and-network-access).
