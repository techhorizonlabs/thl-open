# Evals

How we keep the audit honest and repeatable: a small set of frozen sites with
**expected score ranges** and **must-flag findings**, run against each skill on the
model tier it's actually invoked on. Evals are how you tell "the run finished" apart
from "the run was correct" — the discipline the [method](../docs/THL-GEO-METHOD.md)
is built on.

> **What's open vs what's ours.** Internally we freeze a handful of *real* client
> sites as the regression set — that calibration data is part of the moat and isn't
> here. What's published is the **harness shape** and one **fictional worked fixture**
> ([`harborview.expected.md`](harborview.expected.md)) so you can see the format and
> build your own. Open the method, keep the data.

## Why evals come before prose

Anthropic's skill guidance is blunt about ordering: build the evaluations *before*
you write the skill. We follow it. An eval pins down what a correct run looks like, so
when you later split a skill into `references/` or tune a description, you can prove
you didn't regress it. Without that, "I improved the skill" is a vibe.

## The shape of a fixture

Each frozen site is one file with three parts:

1. **Expected composite range** — e.g. `33–43`. A range, not a point, because audits
   involve judgement; too-tight a band produces false regressions.
2. **Per-dimension expected ranges** — the same, per scored dimension.
3. **Must-flag findings** — the specific issues a correct run *has to* surface (a
   missing `Organization` schema, a blocked AI crawler). Missing one of these is a
   real failure, regardless of the composite.

See [`harborview.expected.md`](harborview.expected.md) for a complete worked fixture.

## Running an eval (the loop)

```
# In Claude Code, against a frozen target:
do a GEO audit of <frozen-site>

# Then check the result against the fixture:
#   - composite within the expected range?
#   - every dimension within its range?
#   - every must-flag finding present?
#   - every score backed by evidence you can point at?
```

A pass is all four. A clean exit code is **not** a pass — that's the whole reason this
directory exists.

## Tier matters

We route work across model tiers. A skill that scores correctly on a large model can
under-specify on a smaller one (vaguer instructions, dropped categories). Run each
eval on the tier the skill is actually invoked on, not just the most capable one
available.

## How THL Open compares to other GEO tooling

The open-source GEO space is real and growing — see
[`docs/HOW-WE-COMPARE.md`](../docs/HOW-WE-COMPARE.md) for an honest, non-marketing
look at where this repo fits next to the alternatives (and where they're ahead).
