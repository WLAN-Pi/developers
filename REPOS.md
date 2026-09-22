# Repository Reference

Current state of each WLAN Pi repository. This is a snapshot of reality, not
policy: use it to tell "what the docs require" apart from "what a repo does
today". Each row that differs from the target is a goal, tracked in the
**Deviations** column.

Target conventions live in [Contributing](CONTRIBUTING.md),
[Architecture/Packaging](architecture/PACKAGING.md),
[Style/Python](style/PYTHON.md), and [Style/README Standards](style/README_STANDARDS.md).

## Applications

| Repository | Default branch | Long-lived branches | Packaging | Python | Lint / format | License | README std |
|------------|----------------|---------------------|-----------|--------|---------------|---------|------------|
| `wlanpi-app` | `main` | `main` | none (Flutter mobile app) | n/a | n/a | BSD-3-Clause | no |
| `wlanpi-bluetooth` | `main` | `main`, `debian/bullseye` | `dh` native (systemd) | n/a (shell) | none | BSD-3-Clause | no |
| `wlanpi-chat-bot` | `main` | `main` | `dh_virtualenv` | 3.11, `setup.py` | none | MIT | partial (archived) |
| `wlanpi-common` | `main` | `main`, `debian/bullseye` | `dh` native | n/a (shell) | shellcheck (`lint.yml`) | BSD-3-Clause | link only |
| `wlanpi-core` | `dev` | `dev`, `main` | `dh_virtualenv` | py39, py311 (`tox`), `>=3.9` | autoflake, black, isort, flake8 | BSD-3-Clause | badge only |
| `wlanpi-desktop` | `main` | `main` | `dh` native | n/a (shell) | none | BSD-3-Clause | link only |
| `wlanpi-fpms` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |
| `wlanpi-grafana` | `main` | `main` | `dh_virtualenv` | `>=3.7` | none | BSD-3-Clause | no |
| `wlanpi-hotspot` | `main` | `main`, `debian/bullseye` | `dh` native | n/a (shell) | none | BSD-3-Clause | no |
| `wlanpi-mcp` | `main` | `main` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | no |
| `wlanpi-misc-firmware` | `main` | `main`, `debian/bullseye` | `dh` native (firmware) | n/a | none | BSD-3-Clause | no |
| `wlanpi-profiler` | `main` | `main`, `debian/bullseye` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |
| `wlanpi-shell-config` | `main` | `main` | `dh` native | n/a (shell) | none | BSD-3-Clause | no |
| `wlanpi-usb-ethernet` | `main` | `main`, `debian/bullseye` | `dh` native | n/a (shell) | none | none (copyright BSD-3-Clause) | no |
| `wlanpi-webui` | `main` | `main`, `suite/{bullseye,bookworm,trixie}` | `dh_virtualenv` | py313 | ruff, mypy | BSD-3-Clause | badge only |

## Platform and build

| Repository | Default branch | Branches | Packaging | Notes |
|------------|----------------|----------|-----------|-------|
| `wlanpi-kernel` | `6.10` (`origin/HEAD`) | per-version, e.g. `6.12-bookworm`, `7.2-trixie` | kernel `.deb` | `AGENTS.md`; dual-kernel support |
| `wlanpi-misc-packages` | `main` | `dev`, `main` | multi-package repo | third-party package rebuilds |
| `wlanpi-hostap` | `main` | `main`, `pending` | vendored upstream | patched by `wlanpi-profiler` |

## Deviations from target

Grouped by the fix that would resolve them. These are the actionable items; open
issues are tracked against each repository.

### Toolchain and Python target

- `wlanpi-core`: `tox` still lists `py39,py311`; migrate to `py313`.
- `wlanpi-core`: lint/format uses the legacy `autoflake` + `black` + `isort` +
  `flake8` chain; migrate to ruff (see the `chore/ruff-migration` branch).
- `wlanpi-grafana`: no `pyproject.toml`, no `tox.ini`; `Pre-Depends` allows
  `python3 (>= 3.7)`; raise to the current target.
- `wlanpi-chat-bot`, `wlanpi-core`: `Pre-Depends` includes `python3-distutils`,
  which no longer exists on trixie. Remove it. (`wlanpi-chat-bot` is archived,
  so only `wlanpi-core` is actionable.)

### Packaging

- `wlanpi-fpms`: `Build-Depends` uses `debhelper-compat (= 11)`; bump to 13.
- `wlanpi-bluetooth`, `wlanpi-common`, `wlanpi-hotspot`: `Standards-Version`
  `3.9.8` and `debhelper (>= 9)`; modernize.
- `wlanpi-usb-ethernet`: add a top-level `LICENSE` (currently only
  `debian/copyright`); rename `build-deb.yml` to the standard workflow name.
- `wlanpi-mcp`: `deploy-to-packagecloud.yml` triggers on a `dev` branch that
  does not exist; remove the dead trigger.

### CI

- `wlanpi-fpms`: no `codeql-analysis.yml` despite being a Python repo.
- `wlanpi-profiler`: workflow is `python-style-police.yml`; other repos use
  `python-format-police.yml` + `python-lint-police.yml`.
- Shell/action lint (`shellcheck` + `actionlint` via `lint.yml`): rolled out to
  every WLAN-Pi repo. Keep it in place and copy it into new repos.

### Documentation and licensing

- README badges: only `wlanpi-chat-bot`, `wlanpi-core`, `wlanpi-fpms`,
  `wlanpi-profiler`, and `wlanpi-webui` have any.
- README link back to this repo: only `wlanpi-common` and `wlanpi-desktop`.
- BSD-3-Clause migration: `wlanpi-chat-bot` (archived), `wlanpi-kernel`, and
  `wlanpi-misc-packages` are MIT.
- Branch naming: `wlanpi-webui` uses `suite/<codename>` where other repos use
  `debian/<codename>`.
