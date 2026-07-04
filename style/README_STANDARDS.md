# README Standards

This document defines the org-wide standards for `README.md` files across all WLAN-Pi repositories. Apply these rules when creating a new README or updating an existing one.

## Structure

Every README must open with a short **"What / Why"** section — one to three sentences describing what the component does, what problem it solves, and what consumes or depends on it. Put this before any build instructions or technical detail.

Sections should appear in this order where applicable:

1. Badges (if any)
2. Repo name heading + "What / Why" description
3. Features
4. Installation
5. Usage
6. Components *(if the repo contains multiple distinct parts)*
7. Quick Local Test
8. Development & Contributing
9. Changelog / Releases
10. Open Source Software
11. Authors
12. License

Deep debugging notes, workarounds, and edge-case instructions belong in a separate `TROUBLESHOOTING.md`, not the main README.

## Headings

Use **Title Case** for all headings — capitalize the first letter of each major word.

```markdown
## Open Source Software   ✓
## Quick Local Test       ✓

## OSS                    ✗  (abbreviation as heading)
## quick local test       ✗  (sentence case)
```

Avoid all-caps section names (`## OSS`, `## API`) except for established acronyms where the spelled-out form would be awkward.

## Code Fences

Always use triple backticks with a **language hint**. Never use 4-space indentation or bare fences for code blocks.

```markdown
​```bash          ✓
​```python        ✓
​```text          ✓  (for non-executable output)

​```              ✗  (no language hint)
    sudo apt ...  ✗  (4-space indent)
```

Commands that a user should copy and run go in `bash` fences. Output-only blocks use `text`.

## Badges

Use a **minimal, consistent badge set**. The standard set for a WLAN-Pi repo is:

| Badge | When to include |
|-------|----------------|
| License (BSD-3-Clause) | All repos |
| Build / CI status | Repos with a CI workflow |
| Packagecloud | Repos that publish `.deb` packages |

Do not add badges for coverage, contributor counts, or social stats unless there is a clear, agreed reason. Keep the badge row on a single line immediately above the `# Repo Name` heading.

Example badge row:

```markdown
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](LICENSE)
[![CI](https://github.com/WLAN-Pi/REPO_NAME/actions/workflows/ci.yml/badge.svg)](https://github.com/WLAN-Pi/REPO_NAME/actions/workflows/ci.yml)
[![packagecloud](https://img.shields.io/badge/deb-packagecloud.io-844fec.svg)](https://packagecloud.io/wlanpi)
```

## File Formats

All documentation must be Markdown (`.md`). Do not use reStructuredText (`.rst`) for any new files. If you encounter an existing `.rst` file, convert it to `.md` when touching that file for any other reason.

## Contributing Link

Every README must link back to the `developers` repo for contributor workflow:

```markdown
## Development & Contributing

See [WLAN-Pi/developers](https://github.com/WLAN-Pi/developers) for branch strategy,
commit conventions, and setup guides. Repo-specific commands:

​```bash
tox -e lint     # check style
tox -e format   # auto-format
tox             # run tests
​```
```

Only include the `tox` commands (or equivalent) that are specific to this repo. Do not duplicate the general workflow from `developers/`.

## Changelog / Releases

Do not link to `debian/changelog` from the README — that file is for packagers, not end users. Link to the GitHub Releases page instead:

```markdown
## Changelog / Releases

See the [GitHub Releases](../../releases) page.
```

## Tone

Keep prose neutral and professional. Avoid:

- Exclamation points in prose
- Casual phrases as section headers ("The Gory Details", "Looking to get your hands dirty?")
- Colloquial descriptions of dependencies ("way cool open source software")

A dry, factual tone is appropriate. Brief friendly touches are fine in contributor-facing sections (e.g., a welcoming sentence in `GETTING_STARTED.md`) but should be consistent across repos.
