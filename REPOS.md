# Repository Reference

Current state of each WLAN Pi repository. This is a snapshot of reality, not
policy: use it to tell "what the docs require" apart from "what a repo does
today". Each row that differs from the target is a goal, tracked under
[Deviations from target](#deviations-from-target).

Target conventions live in [Contributing](CONTRIBUTING.md),
[Architecture/Packaging](architecture/PACKAGING.md),
[Style/Python](style/PYTHON.md), and [Style/README Standards](style/README_STANDARDS.md).

## Applications

| Repository | Default branch | Long-lived branches | Packaging | Python | Lint / format | License | README std |
|------------|----------------|---------------------|-----------|--------|---------------|---------|------------|
| `scandump` | `main` | `main` | `dh` native (fork of `intuitibits/scandump`) | n/a (C) | none | GPL-3.0 | no |
| `wlanpi-app` | `main` | `main` | none (Flutter mobile app) | n/a | n/a | BSD-3-Clause | no |
| `wlanpi-bluetooth` | `main` | `main`, `debian/bullseye` | `dh` native (systemd) | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-chat-bot` | `main` | `main` | `dh_virtualenv` | 3.11, `setup.py` | none | MIT | partial (archived) |
| `wlanpi-common` | `main` | `main`, `debian/bullseye` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | link only |
| `wlanpi-core` | `main` | `main`, `debian/bookworm`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |
| `wlanpi-ctx` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | >=3.9 (CI on 3.9), `pyproject.toml` | black, flake8, isort, mypy (`python-style-police.yml`) | BSD-3-Clause | badge only |
| `wlanpi-desktop` | `main` | `main` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | link only |
| `wlanpi-fpms` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |
| `wlanpi-grafana` | `main` | `main` | `dh_virtualenv` | py313 | ruff | BSD-3-Clause | no |
| `wlanpi-hotspot` | `main` | `main`, `debian/bullseye` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-hwtest` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, shellcheck (`lint.yml`) | BSD-3-Clause | badges, link |
| `wlanpi-librespeed-cli` | `main` | `main`, `debian/bullseye` | `dh` native (prebuilt binary) | n/a | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-mcp` | `main` | `main` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | no |
| `wlanpi-misc-firmware` | `main` | `main`, `debian/bullseye` | `dh` native (firmware) | n/a | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-persistent-identity` | `main` | `main` | `dh` native | n/a (shell) | none | BSD-3-Clause | no |
| `wlanpi-profiler` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |
| `wlanpi-shell-config` | `main` | `main` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-usb-ethernet` | `main` | `main`, `debian/bullseye` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-webui` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |
| `wlanpi-wipry` | `main` | `main`, `debian/bullseye` | `dh` native | n/a | none | BSD-3-Clause | no |

## Platform and build

| Repository | Default branch | Branches | Packaging | Notes |
|------------|----------------|----------|-----------|-------|
| `wlanpi-kernel` | `7.3-trixie` | per-version, e.g. `6.12-bookworm`, `7.2-trixie`, `7.3-trixie` | kernel `.deb` | `AGENTS.md`; dual-kernel support |
| `wlanpi-misc-packages` | `main` | `main` | multi-package repo | third-party package rebuilds |
| `pi-gen` | `trixie64` | `trixie64` | OS image (pi-gen) | Current image repo. Fork of `RPi-Distro/pi-gen`. 25 branches on the repo. Dependabot covers `github-actions` only. No `pr-size.yml`. |
| `pi-gen-bookworm` | `bookworm` | `bookworm` | OS image (pi-gen) | no Dependabot, no `pr-size.yml`; Slack action on `@master` |

## Tooling

| Repository | Default branch | Branches | Packaging | Notes |
|------------|----------------|----------|-----------|-------|
| `gh-workflows` | `main` | `main` | reusable workflows | Files under `.github/workflows/` on `main`: `check-py-deb-pkg-versions-match.yml`, `get-formatted-version-string.yml`, `lint.yml`, `pr-size.yml`, `sbuild-deploy-pkg.yml`, `sbuild-pkg.yml`, `tag-release.yml`. BSD-3-Clause. |
| `sbuild-debian-package` | `main` | `dev`, `main`, `sbuild` | GitHub Action (`action.yml`) | Composite action that builds a Debian package with sbuild. Fork of `danielmundi/sbuild-debian-package`. MIT. |
| `.github` | `main` | `main` | none | Org community health files. `docs/pull_request_template.md`, issue templates, and `profile/README.md`. No `LICENSE` file. |

## Retired

`wlanpi-bridge`, `wlanpi-server`, and `wlanpi-wconsole` are off Packagecloud for
trixie, on both `wlanpi/dev` and `wlanpi/main`, and `trixie64` images do not
install them. That removal is recorded in
[wlanpi-common#111](https://github.com/WLAN-Pi/wlanpi-common/issues/111).
[pi-gen#108](https://github.com/WLAN-Pi/pi-gen/issues/108) records the same
removal for `wlanpi-server`, and the `pi-gen` comments that still name it.

`wlanpi-bridge`, `wlanpi-server`, and `wlanpi-wconsole` are archived.

## Deviations from target

Grouped by the fix that would resolve them. These are the actionable items; open
issues are tracked against each repository.

### Packaging

`debian/compat` is still on these active repos. The number is the level in
the file. Each of them build-depends on `debhelper (>= N)`, not on
`debhelper-compat`. Archived `wlanpi-chat-bot` also has compat 12.

| Repository | compat |
|------------|--------|
| `wlanpi-ctx` | 11 |
| `wlanpi-grafana` | 10 |
| `wlanpi-librespeed-cli` | 12 |
| `wlanpi-profiler` | 11 |
| `wlanpi-webui` | 12 |
| `wlanpi-wipry` | 10 |

`scandump` has `debian/compat` level 12 and build-depends on `debhelper (>=9)`.

`wlanpi-grafana` also overrides `dh_installinit` and `dh_systemd_start`
instead of `dh_installsystemd`.

Source format and changelog version, against
[Source Format and Version](architecture/PACKAGING.md#source-format-and-version).
Checked on each repo's default branch.

Already `3.0 (native)` with no Debian revision: `wlanpi-desktop` (1.0.6),
`wlanpi-misc-firmware` (1.0.20), `wlanpi-shell-config` (1.1.5),
`wlanpi-usb-ethernet` (1.5.4).

`debian/source/format` is `1.0` and the changelog version has a revision.
`dpkg-source` warns and still builds a native tarball; lintian 2.122 reports
`malformed-debian-changelog-version` (error) on the source package. The next
upload should move to `3.0 (native)` at a higher upstream version (`1.2.3-1`
sorts above `1.2.3`):

- `wlanpi-core` `2.4.11-1`
- `wlanpi-ctx` `1.0.2-2`
- `wlanpi-fpms` `1.4.25-1`
- `wlanpi-hwtest` `1.2.0-1`
- `wlanpi-mcp` `0.7.0-1`
- `wlanpi-profiler` `2.1.8-1`
- `wlanpi-webui` `1.21.18-1`

No `debian/source/format` (lintian warning `missing-debian-source-format`),
and the version has no revision, so it is implicitly native: `scandump`,
`wlanpi-bluetooth`, `wlanpi-common`, `wlanpi-grafana`, `wlanpi-hotspot`,
`wlanpi-wipry`.

No `debian/source/format`, and the version has a revision (same lintian error
once the source package is checked):

- `wlanpi-librespeed-cli` `1.0.14-1wlanpi1` wraps a third-party binary. The
  matching format is `3.0 (quilt)` with an orig tarball, not native.
- `wlanpi-persistent-identity` `1.1.0-1` is first-party. The next upload
  should be `3.0 (native)` at a higher upstream version.

`debian/copyright` is missing on `scandump`, `wlanpi-bluetooth`,
`wlanpi-common`, `wlanpi-grafana`, `wlanpi-hotspot`, `wlanpi-mcp`,
`wlanpi-persistent-identity`, `wlanpi-webui`, and `wlanpi-wipry`.

`wlanpi-core`'s `debian/wlanpi-core.install` still installs units into
`/lib/systemd/system`. On Trixie that is the `aliased-location` error.
Other active packages either let `dh_installsystemd` place
`debian/*.service` (debhelper 13.24 installs to `/usr/lib/systemd/system`)
or already name `usr/lib/systemd/system` in the `.install` file
(`wlanpi-mcp`, the `wlanpi-common` irtt drop-in).

`Standards-Version` is not `4.7.2` on these default branches:

| Value | Repositories |
|-------|----------------|
| `4.7.0` | `wlanpi-bluetooth`, `wlanpi-common`, `wlanpi-core`, `wlanpi-hotspot`, `wlanpi-hwtest`, `wlanpi-mcp`, `wlanpi-misc-firmware`, `wlanpi-webui` |
| `4.6.2` | `wlanpi-persistent-identity`, `wlanpi-shell-config`, `wlanpi-usb-ethernet` |
| `4.6.0` | `wlanpi-ctx`, `wlanpi-desktop`, `wlanpi-fpms`, `wlanpi-grafana`, `wlanpi-profiler` |
| `4.3.0` | `wlanpi-librespeed-cli` |
| absent | `scandump`, `wlanpi-wipry` |

### CI

- `wlanpi-ctx` and `wlanpi-profiler` use `python-style-police.yml`.
  `wlanpi-core`, `wlanpi-fpms`, `wlanpi-mcp`, and `wlanpi-webui` use
  `python-format-police.yml` and `python-lint-police.yml`.
- Shell/action lint (`shellcheck` + `actionlint` via `lint.yml`): missing in
  `wlanpi-ctx`, `wlanpi-persistent-identity`, and `wlanpi-wipry`. Their shell
  scripts may need shellcheck fixes when it is added. `scandump` also has no
  `lint.yml`.
- Workflow security is the policy in
  [Style/Workflow](style/WORKFLOW.md#workflow-security) (SHA-pin third-party
  actions, and a Dependabot `github-actions` entry). It is not yet true of
  every active repo. On the default branches checked here, third-party
  actions are SHA-pinned and `.github/dependabot.yml` exists, except
  `pi-gen-bookworm`: `Gamesight/slack-workflow-status@master` and
  `raven-actions/actionlint@v2`, no Dependabot config.
  `debian/bullseye` on `wlanpi-common` still uses
  `Gamesight/slack-workflow-status@master`, has no `permissions:` block in
  its build workflow, and has no `dependabot.yml`. Under the read-only
  token default, that Slack notification step may fail.
- Dependabot `pip` failed with `private_source_authentication_failure`
  against `https://www.piwheels.org/simple` on `wlanpi-core`, `wlanpi-fpms`,
  and `wlanpi-ctx`. The updater records that error. The proxy log in each run
  says `egress not allowlisted www.piwheels.org` and returns HTTP 403.
  Runs: [wlanpi-core](https://github.com/WLAN-Pi/wlanpi-core/actions/runs/39988244728),
  [wlanpi-fpms](https://github.com/WLAN-Pi/wlanpi-fpms/actions/runs/39772518294),
  [wlanpi-ctx](https://github.com/WLAN-Pi/wlanpi-ctx/actions/runs/39690740125).
  Each `requirements.txt` sets `--extra-index-url https://www.piwheels.org/simple`.
  The default branches now declare a `piwheels` registry of type
  `python-index` at that URL:
  [wlanpi-core#430](https://github.com/WLAN-Pi/wlanpi-core/pull/430),
  [wlanpi-fpms#211](https://github.com/WLAN-Pi/wlanpi-fpms/pull/211), and
  [wlanpi-ctx#9](https://github.com/WLAN-Pi/wlanpi-ctx/pull/9).
- PR size check (`pr-size.yml`, calling the reusable
  `WLAN-Pi/gh-workflows/.github/workflows/pr-size.yml`): present on the
  active non-fork application, kernel, and `wlanpi-misc-packages` repos, and
  on `developers`. `pi-gen-bookworm` does not have it. `pi-gen` is a fork of
  `RPi-Distro/pi-gen` and also does not have it. `scandump` is a fork of
  `intuitibits/scandump` and does not have it. Copy
  `developers/.github/workflows/pr-size.yml` into new repos unchanged.
- Build and deploy workflows. The target is the reusable `sbuild-pkg` /
  `sbuild-deploy-pkg` workflows. These default branches call them:
  `wlanpi-core`, `wlanpi-ctx`, `wlanpi-hwtest`, `wlanpi-mcp`,
  `wlanpi-profiler`. These still inline `wlan-pi/sbuild-debian-package` and
  the `package_cloud` push: `scandump`, `wlanpi-bluetooth`,
  `wlanpi-common`, `wlanpi-desktop`, `wlanpi-fpms`, `wlanpi-grafana`,
  `wlanpi-hotspot`, `wlanpi-librespeed-cli`, `wlanpi-misc-firmware` (the
  action is pinned to a SHA), `wlanpi-shell-config`,
  `wlanpi-webui`, `wlanpi-wipry`, and the deploy workflow
  of `wlanpi-persistent-identity` and `wlanpi-usb-ethernet`.
  `wlanpi-persistent-identity` and `wlanpi-usb-ethernet` build with an inline
  `dpkg-buildpackage` step rather than `sbuild-pkg`. Image and kernel repos
  (`pi-gen-bookworm`, `pi-gen`, `wlanpi-kernel`, `wlanpi-misc-packages`) are
  not application `.deb` builds and do not use those two workflows.
- `wlanpi-app`: `lint.yml`'s Slack notification job fails. The repo is private
  and the org is on the free plan, so it cannot read the org
  `SLACK_WEBHOOK_URL` secret; it needs a repo-level one. shellcheck and
  actionlint pass.
- Packagecloud promotion. Shared `sbuild-deploy-pkg` pushes to `wlanpi/dev`
  (`wlanpi/dev/debian/<distro>`, or `wlanpi/dev/raspbian/<distro>` for
  `armhf`). Moving a package to `wlanpi/main` is a manual step the maintainer
  does after testing. Only `wlanpi-desktop` has
  [`promote-to-main.yml`](https://github.com/WLAN-Pi/wlanpi-desktop/blob/main/.github/workflows/promote-to-main.yml),
  and that workflow runs only on `workflow_dispatch`. It builds the package
  and pushes the `.deb` to `wlanpi/main`. See
  [Release Process](RELEASE_PROCESS.md#4-deploy-to-packagecloud).

### Release Tags

[Contributing](CONTRIBUTING.md) says to tag releases on `main` as `vX.Y.Z`.
[Release Process](RELEASE_PROCESS.md#5-tag-the-release) says the same, and
says to skip the manual tag when deploy calls `tag-release`. The shared
workflow is
[`tag-release.yml`](https://github.com/WLAN-Pi/gh-workflows/blob/main/.github/workflows/tag-release.yml).

`wlanpi-bluetooth`, `wlanpi-core`, `wlanpi-librespeed-cli`, and `wlanpi-mcp`
call it from `deploy-to-packagecloud.yml` on the default branch.
`wlanpi-core` tag `v2.4.11` matches changelog `2.4.11-1`. `wlanpi-mcp` tag
`v0.7.0` matches `0.7.0-1`. `wlanpi-librespeed-cli` tag `v1.0.14` is changelog
`1.0.14-1wlanpi1` with the Debian revision removed. `wlanpi-bluetooth` calls
the job and has no tags.
[wlanpi-bluetooth#25](https://github.com/WLAN-Pi/wlanpi-bluetooth/pull/25) and
[wlanpi-librespeed-cli#13](https://github.com/WLAN-Pi/wlanpi-librespeed-cli/pull/13)
added the job on those two repos. The other repos in the table do not call it.

`wlanpi-hwtest`, `wlanpi-profiler`, and `wlanpi-shell-config` have tags, and
the newest tag is behind the changelog. Archived `wlanpi-chat-bot` and the
retired repos are omitted.
`wlanpi-kernel`, `pi-gen`, and `pi-gen-bookworm` use other tag names.
`wlanpi-misc-packages` has no root `debian/changelog` and no tags.

| Repository | Changelog | Newest tag | Calls `tag-release` |
|------------|-----------|------------|---------------------|
| `scandump` | `2.2.1` | none | no |
| `wlanpi-bluetooth` | `1.0.14` | none | yes |
| `wlanpi-common` | `1.1.65` | none | no |
| `wlanpi-core` | `2.4.11-1` | `v2.4.11` | yes |
| `wlanpi-ctx` | `1.0.2-2` | none | no |
| `wlanpi-desktop` | `1.0.6` | none | no |
| `wlanpi-fpms` | `1.4.25-1` | none | no |
| `wlanpi-grafana` | `1.1.5` | none | no |
| `wlanpi-hotspot` | `1.0.22` | none | no |
| `wlanpi-hwtest` | `1.2.0-1` | `v1.0.12` | no |
| `wlanpi-librespeed-cli` | `1.0.14-1wlanpi1` | `v1.0.14` | yes |
| `wlanpi-mcp` | `0.7.0-1` | `v0.7.0` | yes |
| `wlanpi-misc-firmware` | `1.0.20` | none | no |
| `wlanpi-persistent-identity` | `1.1.0-1` | none | no |
| `wlanpi-profiler` | `2.1.8-1` | `v1.0.18` | no |
| `wlanpi-shell-config` | `1.1.5` | `v1.1.2` | no |
| `wlanpi-usb-ethernet` | `1.5.4` | none | no |
| `wlanpi-webui` | `1.21.18-1` | none | no |
| `wlanpi-wipry` | `1.0.3` | none | no |

### Documentation and licensing

- README badges: only `wlanpi-chat-bot`, `wlanpi-core`, `wlanpi-ctx`,
  `wlanpi-fpms`, `wlanpi-hwtest`, `wlanpi-profiler`, and `wlanpi-webui` have
  any.
- README link back to this repo: only `wlanpi-common`, `wlanpi-desktop`, and
  `wlanpi-hwtest`.
- `docs/` layout ([Documentation Types](style/README_STANDARDS.md#documentation-types)):
  no repo uses the four type folders yet. `wlanpi-app`, `wlanpi-core`,
  `wlanpi-mcp`, `wlanpi-misc-firmware`, `wlanpi-profiler`, `pi-gen`, and
  `pi-gen-bookworm` have flat or ad-hoc `docs/` folders.
- BSD-3-Clause migration: `wlanpi-chat-bot` (archived),
  `wlanpi-kernel`, and `wlanpi-misc-packages` are MIT. `scandump` is
  GPL-3.0, the upstream license of `intuitibits/scandump`.
