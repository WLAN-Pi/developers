# Release process

This document covers the release procedures for core WLAN Pi team members. For general contribution guidelines and detailed Git workflow, see [Contributing](CONTRIBUTING.md).

> **For Git workflow details**: Branching strategy, merge strategies, and troubleshooting common scenarios are covered in [Contributing](CONTRIBUTING.md).

## Overview

Releases are managed through Git tags and GitHub workflows. The `main` branch represents the current stable release, while `dev` contains the next release's changes.

## Branch strategy (Quick Reference)

General branching strategy. May vary per repo.

| Branch | Purpose |
|--------|---------|
| `main` | Production/stable releases only |
| `dev` | Integration branch for next release |
| `debian/<codename>` | Preserved support for older Debian suites (core team only) |
| `suite/<codename>` | Same purpose as `debian/<codename>`; used by `wlanpi-webui` |
| `feature/<desc>` | Shared long-term feature work |
| `fix/<desc>` | Bug fix branches |
| `chore/<desc>`, `docs/<desc>`, `ci/<desc>` | Non-feature maintenance |
| `security/<desc>` | Security fixes |
| `hotfix/<desc>` | Urgent fixes against `main` |

> `debian/<codename>` and `suite/<codename>` branches (e.g. `debian/bullseye`)
> are maintained by the core team. They are branched from a known-good commit
> before trixie-targeted work began. Build matrices on these branches target
> only their specific suite. Contributors should not open PRs against these
> branches.

### Branch rules

- **No direct commits to `main`** - All changes come via PRs from `dev`
- **No direct commits to `dev`** - All changes come via PRs from feature branches

**See [Contributing](CONTRIBUTING.md) for detailed workflow**, including:
- Feature branch workflow and keeping branches in sync
- Critical merge strategies (squash vs regular merge)
- Version collision handling
- Branch divergence recovery

## Creating a release

### 1. Prepare the release

Ensure `dev` is stable and all intended changes are merged:

```bash
git checkout dev
git pull origin dev
```

### 2. Update version and changelog

Update `debian/changelog` with the new version:

```bash
dch -v <version> "Release version <version>"
```

Example:
```bash
dch -v 1.2.3 "Release version 1.2.3"
```

Commit this change:
```bash
git add debian/changelog
git commit -m "Bump version to 1.2.3"
```

### 3. Create and push tag

Create an annotated tag with the version:

```bash
git tag -a v1.2.3 -m "Release version 1.2.3"
git push origin v1.2.3
```

**Important:** Tend to always use annotated tags (`-a`) not lightweight tags.

### 4. Merge to main

Create a PR from `dev` to `main` and merge using **"Create a merge commit"** (not squash) to preserve the release history.

See [Contributing](CONTRIBUTING.md) for why regular merges between `dev` and `main` are required.

### 5. Deploy to Packagecloud

The `debian/changelog` change reaching the release branch triggers the
deployment workflow. Pushing the version tag does not trigger it.

1. Package is built automatically with `sbuild`
2. Uploaded to [wlanpi/dev](https://packagecloud.io/wlanpi/dev) with a
   `~gha<UTC timestamp>` build-metadata suffix on the version
3. Test the package
4. Once verified, promote from `dev` to `main` in Packagecloud

## GitHub workflows

### Build and archive

Triggered by: Changes that affect build output in PRs (most repos watch
`debian/changelog`; some ignore docs-only changes)

Purpose: Build packages for testing without deploying

Use this to verify builds work before tagging.

### Deploy to Packagecloud

Triggered by: A `debian/changelog` change pushed to a release branch. This is
`main` for most repositories; repositories that keep a `dev` branch (for
example `wlanpi-core` and `wlanpi-mcp`) also deploy from `dev`.

Purpose: Builds the package and deploys it to the Packagecloud `dev` repository

Maintained by:

- Build logic: [sbuild-debian-package](https://github.com/WLAN-Pi/sbuild-debian-package)
- Reusable workflow files: [gh-workflows](https://github.com/WLAN-Pi/gh-workflows)
  (`sbuild-pkg`, `sbuild-deploy-pkg`, `check-py-deb-pkg-versions-match`,
  `get-formatted-version-string`)
- Workflow files in each repo, which call the reusable workflows above

Promotion from dev to main: Manually done on Packagecloud (or, for repos that
provide it, via a manual `promote-to-main.yml` workflow).

### Version gate

Deploy workflows for Python repos call
`check-py-deb-pkg-versions-match`, which fails the build unless the
`major.minor.patch` in `debian/changelog` equals the value in the package's
`__version__.py`. Bump both together. See
[Style/Workflow](style/WORKFLOW.md#versioning).

### Lint workflows

Every repository runs the shared lint gate:

- `shellcheck` over tracked shell scripts and shell-shebang executables
- `actionlint` over `.github/workflows/`

The canonical implementation is
[wlanpi-common/.github/workflows/lint.yml](https://github.com/WLAN-Pi/wlanpi-common/blob/main/.github/workflows/lint.yml).
New repositories should copy it as `.github/workflows/lint.yml`.

### Workflow diagrams

**Build and Archive:**

![Flowchart for building a debian package](workflow/img/wlanpi_build-and-archive-debian-package.png)

**Deploy to Packagecloud:**

![Flowchart for deploying to packagecloud](workflow/img/wlanpi_deploy-to-packagecloud.png)

## Merging Pull Requests

### For contributors

When merging external contributions, use **"Squash and merge"** by default:

1. Review the commit messages in the PR
2. Clean up any "fix typo", "address feedback" commits
3. Ensure the final commit message is descriptive
4. Click "Squash and merge"

This keeps the git history clean and readable.

### When NOT to squash

Use "Create a merge commit" when:
- The PR contains logically separate commits that should be preserved
- It's a release PR from `dev` to `main`
- The contributor specifically requests commits be preserved (and there's good reason)

See [Contributing](CONTRIBUTING.md) for detailed merge strategy guidance.

## Troubleshooting

### Tag already exists

If you need to replace a tag (only before pushing):

```bash
git tag -d v1.2.3
git push origin :refs/tags/v1.2.3
git tag -a v1.2.3 -m "Release version 1.2.3"
git push origin v1.2.3
```

### Build failures

Check the GitHub Actions logs for:
- Missing dependencies in `debian/control`
- Syntax errors in `debian/rules`
- Missing files in `debian/install`

### Packagecloud issues

Contact Josh Schmelzle for Packagecloud issues.

## See also

- [Contributing](CONTRIBUTING.md) - General contribution guidelines and detailed Git workflow
- [Packaging Example](PACKAGING_EXAMPLE.md) - Packaging walkthrough
- [Architecture/Packaging](architecture/PACKAGING.md) - Detailed packaging standards
