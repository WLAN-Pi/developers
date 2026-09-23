# Guidance for coding agents

This repository is documentation only. There is no application code here.

## Ground rules

- Do not invent behavior. Verify every technical claim against the actual
  repository before writing it. If you cannot verify it, say so or omit it.
- Distinguish the target from the current state. Mark aspirational rules as
  goals and point at [REPOS.md](REPOS.md) for what each repo does today.
- Keep docs as the single source of truth. Do not duplicate the same guidance
  across files; link instead.
- Prefer editing an existing file over adding a new one.

## Writing

- All docs are Markdown with the `.md` extension, lowercase.
- Follow [style/README_STANDARDS.md](style/README_STANDARDS.md): Title Case
  headings, fenced code blocks with a language hint, neutral tone.
- Use relative links for files in this repo and full URLs for everything else.
  When you rename a file, update every link to it (grep for the old name).
- Keep the tables in [README.md](README.md), [workflow/README.md](workflow/README.md),
  and [style/README.md](style/README.md) in sync with the files on disk.

## CI and lint

- `shellcheck` covers tracked shell scripts (`install.sh`).
- `actionlint` covers `.github/workflows/`.
- Run both before committing; see [style/WORKFLOW.md](style/WORKFLOW.md).

## Git

- PRs target `main`.
- Keep each PR to one independently reviewable outcome. Up to 500 changed lines
  needs no size justification; 501-1,000 needs a cohesion explanation and
  review order; above 1,000 needs a split or maintainer-approved exception.
  Measure additions plus deletions against the target branch's merge base.
  Follow the full policy in [CONTRIBUTING.md](CONTRIBUTING.md#pr-size-and-scope).
- Do not mix moves, formatting, or generated output with behavioral changes.
- Use conventional commit subjects (`docs:`, `ci:`, `fix:`, `chore:`).

## Keeping REPOS.md current

`REPOS.md` is a snapshot of the other repositories. When you change a documented
convention or a repo changes its branch, packaging, tooling, or license, update
the matching row and, if the change resolves a deviation, move or remove that
entry under "Deviations from target".
