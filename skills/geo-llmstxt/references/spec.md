# The llms.txt specification + file template

Everything about what a good `llms.txt` file looks like — the format rules, the extended
`llms-full.txt` variant, a ready-to-fill template, and best practices. The procedure in `SKILL.md`
points here for both analysis (validating against these rules) and generation (assembling a file).

## File Location

The file MUST be located at the root of the domain:
```
https://example.com/llms.txt
```

## Format Specification

The file uses Markdown formatting with specific conventions:

```markdown
# [Site Name]

> [One-sentence description of what the site/business does. Keep under 200 characters.]

## Docs

- [Page Title](https://example.com/page-url): Concise description of what this page covers and why it matters.
- [Another Page](https://example.com/another-page): Description of content.

## Optional

- [Less Critical Page](https://example.com/optional-page): Description.
```

## Detailed Format Rules

**1. Title (Required)**
```markdown
# Site Name
```
- Must be the first line of the file.
- Should be the official business/site name.
- Use the H1 heading format (single `#`).

**2. Description (Required)**
```markdown
> Brief description of the site/business
```
- Must appear immediately after the title.
- Use Markdown blockquote format (`>`).
- Keep under 200 characters.
- Should clearly state what the business does and who it serves.
- Avoid marketing fluff — be factual and specific.

**3. Main Sections (Required — at least one)**

Use H2 headings (`##`) to organize pages by category. Common section names:

| Section Name | Purpose | Example Content |
|---|---|---|
| `## Docs` | Primary documentation or key pages | Product pages, service descriptions, core content |
| `## Optional` | Secondary pages worth knowing about | Blog posts, supplementary resources |
| `## API` | API documentation | API reference, authentication guides |
| `## Blog` | Blog or news content | Recent/popular articles |
| `## Products` | Product catalog | Product pages, pricing |
| `## Services` | Service offerings | Service descriptions, process pages |
| `## About` | Company information | About page, team, mission |
| `## Resources` | Educational/reference content | Guides, tutorials, whitepapers |
| `## Legal` | Legal documents | Terms of service, privacy policy |
| `## Contact` | Contact information | Contact page, support channels |

**4. Page Entries (Required)**

Each entry follows the format:
```markdown
- [Page Title](URL): Description of page content
```

Rules for page entries:
- **Title:** Use the actual page title or a clear descriptive title.
- **URL:** Must be a full, absolute URL (not relative paths).
- **Description:** 10-30 words describing what the page covers. Be specific about the information available.
- **Order:** List pages in order of importance within each section.
- **Limit:** Include 10-30 page entries total. Prioritize your most authoritative and useful pages.

**5. Key Facts Section (Recommended)**

```markdown
## Key Facts
- Founded in [year] by [founder(s)]
- Headquarters: [City, Country]
- [X] customers/users in [Y] countries
- Key products: [Product A], [Product B], [Product C]
- Industry: [Industry classification]
```

This section provides quick reference data that AI systems frequently need to answer user queries about your business.

**6. Contact Section (Recommended)**

```markdown
## Contact
- Website: https://example.com
- Email: hello@example.com
- Support: support@example.com
- Phone: +1-555-123-4567
- Address: 123 Main St, City, State, ZIP, Country
```

---

## llms-full.txt (Extended Version)

In addition to `llms.txt`, sites can provide `/llms-full.txt` — an extended version with more detail.

**Differences from llms.txt:**

| Feature | llms.txt | llms-full.txt |
|---|---|---|
| **Length** | Concise (50-150 lines) | Comprehensive (150-500+ lines) |
| **Page entries** | 10-30 key pages | 30-100+ pages |
| **Descriptions** | 10-30 words per entry | 30-100 words per entry, may include key facts from each page |
| **Audience** | Quick AI comprehension | Deep AI analysis |
| **Sections** | 3-6 sections | 8-15 sections |
| **Key facts** | Business-level facts | Page-level facts and data points |

Both files can coexist. AI systems check for `llms.txt` first, then may optionally load `llms-full.txt` for deeper understanding.

---

## File Template (Generation)

Assemble a generated file from this template:

```markdown
# [Site Name]

> [One clear sentence: what the business does, who it serves, and its primary value proposition. Under 200 characters.]

## Docs

- [Most Important Page](https://example.com/page): Description covering the key content on this page.
- [Second Page](https://example.com/page-2): Description of this page's content and value.
- [Third Page](https://example.com/page-3): What users and AI systems will find here.

## Products

- [Product A](https://example.com/product-a): Core features, target users, and pricing model for Product A.
- [Product B](https://example.com/product-b): What Product B does and how it differs from Product A.

## Resources

- [Guide Title](https://example.com/guide): Comprehensive guide covering [topic] with [X] sections and practical examples.
- [Blog Post](https://example.com/blog/post): Analysis of [topic] with original data from [source].

## Key Facts

- Founded in [year] by [name(s)]
- Headquartered in [City, Country]
- [Specific metric: e.g., "Serves 10,000+ businesses in 40 countries"]
- [Key differentiator: e.g., "Only platform offering real-time X and Y integration"]
- Industry: [Classification]

## Contact

- Website: https://example.com
- Email: [primary contact email]
- Support: [support URL or email]
```

---

## Best Practices

1. **Update regularly.** If your site publishes weekly blog posts, update llms.txt monthly. If your product changes quarterly, update after each release.
2. **Lead with your strongest content.** The first entries in each section should be your most authoritative, comprehensive pages.
3. **Be specific in descriptions.** "Comprehensive 3,000-word guide to React Server Components with code examples" is far more useful than "React guide."
4. **Include your differentiators.** If your site has unique data, original research, or exclusive features, highlight these in descriptions and Key Facts.
5. **Keep it concise.** The llms.txt should be scannable in under 60 seconds. Save detail for llms-full.txt.
6. **Use absolute URLs.** Always include the full `https://` URL, never relative paths.
7. **Test after deployment.** After uploading, verify the file is accessible at `https://yourdomain.com/llms.txt` with no redirects.
8. **Coordinate with robots.txt.** Ensure pages listed in llms.txt are not blocked in robots.txt for AI crawlers.
9. **Mirror your site structure.** Section names in llms.txt should roughly correspond to your main navigation categories.
10. **Avoid sensitive pages.** Do not include internal tools, admin panels, or pages with sensitive information.
