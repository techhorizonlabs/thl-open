# Output templates — analysis and generation modes

## Analysis Mode → `GEO-LLMSTXT-ANALYSIS.md`

```markdown
# llms.txt Analysis: [Domain]

**Analysis Date:** [Date]
**llms.txt Status:** [Found at URL / Not Found / Error]
**llms-full.txt Status:** [Found / Not Found]

---

## Overall llms.txt Score: [X]/100

| Dimension | Score |
|---|---|
| Completeness | [X]/100 |
| Accuracy | [X]/100 |
| Usefulness | [X]/100 |

---

## Format Validation

| Element | Status | Notes |
|---|---|---|
| H1 Title | [Pass/Fail] | [Notes] |
| Description blockquote | [Pass/Fail] | [Notes] |
| H2 Sections | [Pass/Fail] | [X sections found] |
| Page entries | [Pass/Fail] | [X entries found] |
| URL validity | [Pass/Fail] | [X broken URLs] |
| Entry descriptions | [Pass/Fail] | [X missing descriptions] |
| Key Facts | [Pass/Fail] | [Notes] |
| Contact section | [Pass/Fail] | [Notes] |

---

## Missing Pages

These important pages were found on the site but not in llms.txt:

1. [Page Title](URL) — [Why it should be included]
2. [Page Title](URL) — [Why it should be included]

## Improvement Recommendations

1. [Specific recommendation]
2. [Specific recommendation]
3. [Specific recommendation]

## Suggested Updated llms.txt

[Complete rewritten llms.txt file if significant improvements are needed]
```

## Generation Mode

Output the complete `llms.txt` file content, ready to be saved to the site's root directory. Also
output a brief `GEO-LLMSTXT-GENERATION.md` report explaining:
- How many pages were discovered and how many were selected
- The prioritization rationale
- Any pages that were borderline (might add later)
- Recommended update frequency (e.g., monthly for active blogs, quarterly for stable sites)
