# Contributing to WLAN Pi

This guide covers how to contribute code to WLAN Pi projects. For setting up your development environment, see [Getting Started](GETTING_STARTED.md).

> **New to Git?** Start with our [Git Workflow Guide](GIT_WORKFLOW.md) for fundamental concepts and basic commands.

## Prerequisites

- A GitHub account
- Basic familiarity with git (see [Git Workflow Guide](GIT_WORKFLOW.md) if needed)
- Access to a WLAN Pi device for testing your changes (technically optional but highly recommended)

## Workflow overview

1. **Fork** the repository on GitHub
2. **Clone** your fork locally
3. **Create a branch** from `dev`
4. **Make your changes** with clear, focused commits
5. **Push** to your fork
6. **Open a Pull Request** to the `dev` branch

## Branch structure

WLAN Pi repositories follow one of two patterns:

**Two permanent branches** (Python-based repos like `wlanpi-core`):
- `dev`: Active development for the next release. All feature and fix work targets this branch.
- `main`: Stable release branch. Only tested releases land here via PR from `dev`.

**Single permanent branch** (repos like `wlanpi-profiler`):
- `main`: Stable release branch. Feature branches merge directly here.

**Debian suite branches** (`debian/<codename>`, e.g. `debian/bullseye`):
- Maintained by the core team only. These preserve support for older Debian releases and are not targets for regular contributor PRs.
- Build matrices on these branches are scoped to their specific suite only.

See [Repository Reference](REPOS.md) for which repos currently keep a `dev`
branch.

### Why two patterns?

WLAN Pi repos use one of two branching strategies depending on the complexity of the project.

**Single permanent branch (`main` only)**

Simpler repos use only `main`. Feature and bugfix branches are created directly from `main` and merged back when ready. Squash merging is fine here because there is only one permanent branch. There is no shared ancestry to preserve between two long-lived branches.

**Two permanent branches (`dev` and `main`)**

More active repos use both `dev` and `main`. `dev` is the integration target for all ongoing work. `main` represents the current stable release and only receives merges from `dev` at release time.

This pattern requires care with merge strategy:

- **Feature branches into `dev`**: squash merge is encouraged. Collapses WIP commits into one clean entry on `dev`.
- **`dev` into `main`**: regular merge commit required, always. Git tracks which commits exist in each branch by shared ancestry. Squashing dev into main destroys that ancestry, so on the next release cycle Git cannot tell what is already in main. This leads to phantom conflicts and eventually branches that cannot be reconciled without force-pushing.
- **`main` into `dev`** (syncing after a hotfix): same rule, regular merge commit only.

The short version: squash merges are safe when collapsing a temporary branch. They are destructive when used between two branches that will continue to diverge and re-merge over time.

## Branch naming

Use one of these patterns when creating branches:

```
feature/<description>            # Feature work
fix/<description>                # Bug fixes
chore/<description>              # Maintenance (deps, tooling, cleanup)
docs/<description>               # Documentation only
ci/<description>                 # CI/CD changes
security/<description>           # Security fixes
hotfix/<description>             # Urgent fixes against main
```

Examples:
- `feature/add-wifi-scan`
- `fix/memory-leak-profiler`
- `chore/ruff-migration`
- `hotfix/cert-validation`

Some repos also use `feat/<description>` and `test/<description>`; either is
fine. The important part is a short, descriptive suffix.

## Development workflow

### Feature development

If the `dev` branch exists, all feature branches should be created from `dev`:

```bash
git checkout dev
git pull origin dev
git checkout -b feature/descriptive-name
```

If the `dev` branch exists, pull requests should target `dev`. Features can be squash merged into `dev` to keep history clean. This is something maintainers would do:

```bash
# Example: Squash merge a feature branch into dev
git checkout dev
git merge --squash feature/my-feature
git commit -m "Add new feature: description"
git push origin dev
```

**Squash merging is OK for feature branches into `dev`** because we are collapsing temporary branches. The problem only occurs when squash merging between **permanent** branches (`dev` into `main`).

### Keeping feature branches in sync

If you're working on a long-running feature branch and `dev` has moved ahead with new commits or releases, merge `dev` into your feature branch to stay current:

```bash
# First, update your local dev to match remote
git checkout dev
git pull origin dev

# Then merge the updated dev into your feature branch
git checkout your-feature-branch
git merge dev --no-ff -m "Merge dev to stay current"
git push origin your-feature-branch
```

**Why update dev first?** This ensures your local `dev` branch has the latest changes from the remote repository before merging. If you merge an outdated local `dev`, you'll miss recent commits from other developers.

**Important:** Please avoid rebasing feature branches that have already been pushed to origin, especially if `dev` or `main` have moved ahead with releases. Rebasing can cause Git to drop commits incorrectly. Tread carefully!

### Critical merge strategy for maintainers: dev and main

**NEVER use squash merges when merging between `dev` and `main`.** Always use regular merge commits (`git merge --no-ff`).

**Why?** Squash merging between permanent branches destroys the shared commit history, making it impossible for Git to track which commits exist in both branches. This leads to:

- Inability to merge main back into dev without, sometimes, massive conflicts
- Branch divergence that cannot be reconciled
- Loss of detailed commit history on the release branch

Regular merge commits preserve the full history and keep both branches properly synchronized.

**Summary:**
- ✅ **Squash merge OK**: `feature/branch` into `dev` (keeps dev clean)
- ❌ **Regular merge REQUIRED**: `dev` into `main` (preserves shared history)
- ❌ **Regular merge REQUIRED**: `main` into `dev` (preserves shared history)

## Troubleshooting common scenarios

### Version collision during feature development

If `main` releases a new version while you're still working on a feature branch:

1. **Sync your feature branch with dev first:**
   ```bash
   # First, update your local dev to match remote
   git checkout dev
   git pull origin dev

   # Then merge the updated dev into your feature branch
   git checkout your-feature-branch
   git merge dev --no-ff -m "Merge dev to stay current"
   ```

2. **Check your branch's version** in any version files (e.g., `__version__.py` or `debian/changelog`)

3. **If main already released that version**, bump to the next version in your branch:
   ```bash
   # Edit version files to next version
   git add path/to/version/file
   git commit -m "bump version to X.Y.Z+1"
   ```

4. **Then follow normal merge workflow**: feature into dev, dev into main

**Example:** If your feature branch says "2.1.8" but main already released 2.1.8, update your branch to "2.1.9". Unsure? One of the core maintainers will handle release management.

### Branch divergence recovery

If your local branch diverges from its remote (e.g., after a problematic rebase):

1. **Check the actual difference:**
   ```bash
   git diff origin/your-branch..HEAD
   ```

2. **To reset your local branch to match the remote:**
   ```bash
   git checkout your-branch
   git reset --hard origin/your-branch
   ```

   This discards any local commits and makes your branch identical to the remote version.

## Commit guidelines

- **One logical change per commit** - Do not bundle unrelated changes. Related file changes that are part of the same logical change should be included in a single commit.

- **Clear commit messages** - Start with a verb, keep summary around 72 characters
  
  Good: `Add support for 802.11ax packet capture`
  
  Bad: `updates`

- **Conventional commits format** (recommended):
  ```
  feat: new feature
  feature: new feature
  fix: bug fix
  bugfix: bug fix
  docs: documentation changes
  refactor: code restructuring
  test: adding tests
  ```

  Using these prefixes in your PR title makes it easier for maintainers to triage and label incoming work at a glance.

- **Don't manually edit `debian/changelog`** - This is updated separately using `dch` from `devscripts`

## Pull requests

### Opening a PR

If `dev` exists, otherwise use `main`.

1. Ensure your branch is up to date with `dev`:
   ```bash
   git checkout dev
   git pull origin dev
   git checkout your-branch
   git rebase dev
   ```

2. Push your branch and open a PR against the `dev` branch (not `main`)

3. In the PR description, reference any related issues:
   - Use keywords like `closes #42`, `fixes #66`, or `resolves #99`
   - This automatically links the PR to the issue

When possible, open an issue before opening a PR. This gives maintainers context for the change and prevents duplicate work. For small fixes, a brief issue is fine; just enough to describe the problem.

### PR best practices

- Aim to keep changes focused and reviewable
- Respond to review feedback
- Ensure CI checks pass before requesting review
- Python repos include CodeQL scanning via `codeql-analysis.yml`. It runs on push, pull request, and on a weekly schedule. You do not need to configure it, but be aware that findings may be raised on your PR.
- Every repo runs the shared lint gate (`lint.yml`): `shellcheck` over tracked shell scripts and `actionlint` over `.github/workflows/`. Keep both clean.
- Create and link to related issues for history and context

### PR Size and Scope

Keep each PR to one independently reviewable outcome. Measure its size as
additions plus deletions against the target branch's merge base, including tests
and documentation. Size is a soft target: cohesion matters more than the line
count.

- Up to 500 changed lines needs no size justification.
- Above 500 changed lines, add a `Review order` section to the PR description
  that explains why the change belongs together and what to read first.
- Above 1,000 changed lines is acceptable when the change is cohesive. In the
  same section, explain why it cannot be split cleanly, and structure the
  commits so each can be reviewed on its own. Open or reference an issue before
  starting so maintainers know the change is coming.

#### When to Split

Split only along real seams: each resulting PR builds, passes tests, and makes
sense to merge on its own. Do not split to hit a number. A split that forces
reviewers to hold context across several PRs, or that lands half a feature,
costs more review effort than one larger PR.

For a large effort, aim for a small number of PRs, typically two to four, and
list them in merge order in a tracking issue. If a change seems to need more
than that, the split is probably along the wrong lines; talk to a maintainer
before opening them.

#### Mechanical Changes

Put file moves, renames, formatting, and generated output in their own commits,
separate from behavioral changes, so reviewers can skim or skip them. They need
a separate PR only when they would dominate the diff. Identify generated files
(with the generator command) and imported content (with the upstream source and
revision) in the PR description. List binary and submodule changes separately
because line counts do not describe their review cost.

Tests stay with the behavior they verify and count toward the size.

#### Size Check

The shared `pr-size` workflow (rollout status in [REPOS.md](REPOS.md#ci))
reports each PR's size in the job summary. It is advisory: it never blocks a
merge, and maintainers decide whether a change is genuinely cohesive.

| Changed lines | Without a `Review order` heading |
| --- | --- |
| Up to 500 | Passes |
| 501 through 1,000 | Passes with a warning |
| Above 1,000 | Fails, naming the missing heading as the reason |

To clear a warning or failure, add a `## Review order` heading to the PR
description and save it; the edit starts a new run. **Re-run jobs** does not
help, because a re-run uses the description from the original run. PRs from the
repository's own `dev` or `main` branch (branch synchronization) and from
Dependabot are skipped.

AI assistance is welcome. Just make sure you have reviewed and tested what you are submitting. Some repos carry an `AGENTS.md` with repo-specific guidance for AI agents; read it before letting an agent make changes.

### PR checklist

See the [PR template](https://github.com/WLAN-Pi/.github/blob/main/docs/pull_request_template.md) for what to include when opening a pull request.

### Breaking changes

If you're adding breaking changes, document them in your PR description:

```
1. Who is affected
2. What needs migrated
3. Why this breaking change
4. Severity
```

### Increasing acceptance likelihood

To increase the likelihood of your PR being accepted:

- Follow standards for style and code quality (see [Style Guide](style/README.md))
- Include documentation updates
- Write tests
- Keep your change as focused as possible
- Write [good commit messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- Reference the issue your PR closes (e.g., "closes #42")

### Merging for maintainers

When merging contributor PRs (feature or bugfix branches into `dev`), use squash merge by default. This collapses noisy WIP commits into a single clean commit on `dev`.

Do not squash when merging between `dev` and `main`. See the merge strategy section above.

## Version control best practices

- **Feature branches**: `feature/short-description` - branch from `dev`, merge back to `dev`
- **Bugfix branches**: `fix/short-description` - branch from `dev`, merge back to `dev`
- **Hotfix branches**: `hotfix/short-description` - branch from `main`, merge to both `main` and `dev`
- Always use `--no-ff` (no fast-forward) when merging to preserve merge commits
- Never rewrite history on permanent `main` or `dev` branches
- Tag all releases on `main` with semantic versioning: `vX.Y.Z`

## Code Review

All code should go through review before merging. This helps:

- Catch bugs early
- Ensure consistency with project standards
- Share knowledge across the team
- Maintain code quality

## Issues

Found a bug? Have a feature idea? Create an issue first:

1. Check if an issue already exists
2. Use clear, descriptive titles
3. Include steps to reproduce for bugs, when you have them
4. Explain the use case for features

Even if you're already working on a fix, create an issue to document it.

### Good Bug Reports

The issue forms ask for what we need. Only "What happened?" is required; the
rest is optional, but hardware (`wlanpi-model`), version
(`cat /etc/wlanpi-release`), and log output help most. If you know where in the
code the problem is, mention it.

If we ask a question and don't hear back, we may close the issue. Comment any
time and we'll reopen it.

## Security guidelines

### Running as root

Avoid running as root absolutely necessary:

- Use specific user accounts for services (e.g., `wlanpi` user)
- Drop privileges after initialization when possible
- Document why root is required if it must be used

### Systemd hardening

If your application runs as a systemd service, apply security options:

```ini
[Service]
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/log/your-app
```

Learn more:
- [Systemd Analyze](https://www.freedesktop.org/software/systemd/man/systemd-analyze.html)
- [Systemd Service Hardening](https://github.com/alegrey91/systemd-service-hardening)

## Questions?

- Dev [Slack](https://wlanpi.slack.com) (contact a team member for access)
- Open a discussion issue
- Reach out to maintainers

## See Also

- [Git Workflow Guide](GIT_WORKFLOW.md) - Git fundamentals for beginners
- [Getting Started](GETTING_STARTED.md) - Development environment setup
- [Release Process](RELEASE_PROCESS.md) - For core team release procedures
- [Style Guide](style/README.md) - Code style and packaging standards
