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
| `wlanpi-app` | `main` | `main` | none (Flutter mobile app) | n/a | n/a | BSD-3-Clause | no |
| `wlanpi-bluetooth` | `main` | `main`, `debian/bullseye` | `dh` native (systemd) | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-chat-bot` | `main` | `main` | `dh_virtualenv` | 3.11, `setup.py` | none | MIT | partial (archived) |
| `wlanpi-common` | `main` | `main`, `debian/bullseye` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | link only |
| `wlanpi-core` | `dev` | `dev`, `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |
| `wlanpi-desktop` | `main` | `main` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | link only |
| `wlanpi-fpms` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |
| `wlanpi-grafana` | `main` | `main` | `dh_virtualenv` | py313 | ruff | BSD-3-Clause | no |
| `wlanpi-hotspot` | `main` | `main`, `debian/bullseye` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-mcp` | `main` | `main` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | no |
| `wlanpi-misc-firmware` | `main` | `main`, `debian/bullseye` | `dh` native (firmware) | n/a | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-profiler` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |
| `wlanpi-shell-config` | `main` | `main` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-usb-ethernet` | `main` | `main`, `debian/bullseye` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | no |
| `wlanpi-webui` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |

## Platform and build

| Repository | Default branch | Branches | Packaging | Notes |
|------------|----------------|----------|-----------|-------|
| `wlanpi-kernel` | `7.2-trixie` | per-version, e.g. `6.12-bookworm`, `7.2-trixie` | kernel `.deb` | `AGENTS.md`; dual-kernel support |
| `wlanpi-misc-packages` | `main` | `main` | multi-package repo | third-party package rebuilds |

## Deviations from target

Grouped by the fix that would resolve them. These are the actionable items; open
issues are tracked against each repository.

### Packaging

- `wlanpi-grafana` (10), `wlanpi-profiler` (11), `wlanpi-webui` (12): still
  ship a legacy `debian/compat` file with `debhelper (>= 11)`; move to
  `debhelper-compat (= 13)`. `wlanpi-grafana` also needs its `dh_installinit`
  and `dh_systemd_start` overrides replaced with `dh_installsystemd`.
- `wlanpi-mcp`: `deploy-to-packagecloud.yml` triggers on a `dev` branch that
  does not exist; remove the dead trigger.

### CI

- `wlanpi-profiler`: workflow is `python-style-police.yml`; other repos use
  `python-format-police.yml` + `python-lint-police.yml`.
- Shell/action lint (`shellcheck` + `actionlint` via `lint.yml`): rolled out to
  every WLAN-Pi repo. Keep it in place and copy it into new repos.
- PR size check (`pr-size.yml`, calling the reusable
  `WLAN-Pi/gh-workflows/.github/workflows/pr-size.yml`): only in `developers`
  so far. Copy `developers/.github/workflows/pr-size.yml` into each repo.

### Documentation and licensing

- README badges: only `wlanpi-chat-bot`, `wlanpi-core`, `wlanpi-fpms`,
  `wlanpi-profiler`, and `wlanpi-webui` have any.
- README link back to this repo: only `wlanpi-common` and `wlanpi-desktop`.
- BSD-3-Clause migration: `wlanpi-chat-bot` (archived), `wlanpi-kernel`, and
  `wlanpi-misc-packages` are MIT.
