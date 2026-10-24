# Agent Guidance

Org-wide guidance for an agent working in any WLAN Pi repository. The linked
documents are the source of truth. This file is a first cut maintainers can
extend. It is not an exhaustive standard, and it does not replace human review.

A per-repo stub, when one exists, should link here and add no rules of its own.

## Authority

The [developers](https://github.com/WLAN-Pi/developers) repository is the
source of truth for how WLAN Pi software is built.

A README or an older branch shows what that repo did. It does not override
this repository. Archived repos, legacy repos, and older Debian suite branches
never override the current guidance here.

## Platform

Current development targets Debian 13 Trixie and Python 3.13. That is the
system `python3` package in Trixie. The version is 3.13, not "3.13+". Do not
target Python 3.14 or 3.15. Do not select a production interpreter with
pyenv, conda, or uv. Production apps ship as `.deb` packages and may use
`dh_virtualenv` under `/opt/wlanpi-{app}`.

Python 3.11 on Bookworm and Python 3.9 on Bullseye are valid only when the
work is on that suite branch, or is a fix to an existing package. See
[Python version guidelines](https://github.com/WLAN-Pi/developers/blob/main/style/PYTHON.md#python-version-guidelines).

When the target suite or Python version changes, update this section and
`style/PYTHON.md` in the same change.

## How to work

- Be concise. Skip filler.
- Do not use an em dash. Do not use `--` as punctuation. `--` belongs only in a CLI flag or a URL.
- When the task is ambiguous, ask. Do not guess.
- Build only what was asked. Do not add files, abstractions, dependencies, or features that were not requested.
- Use the least code that solves the problem. After it works, do a second pass that simplifies and deletes unused code.
- Before you hand work off, review your own output. Read the change as a critic against the request, the platform rule above, and the linked docs. Fix what that review finds, then hand it off.
- Prefer boring, well-understood tools. If you reach for something novel, say why.
- Match the style of the file you are editing.
- Keep each pull request small enough to review. The size policy is in [PR Size and Scope](https://github.com/WLAN-Pi/developers/blob/main/CONTRIBUTING.md#pr-size-and-scope).

## Python

Follow [style/PYTHON.md](https://github.com/WLAN-Pi/developers/blob/main/style/PYTHON.md).

For a new package, use `pyproject.toml`, not `setup.py`. The app should run as `python -m app`. Parse arguments with `argparse`. Test with `pytest`. Use `tox` for test, lint, and format.

## Packaging

WLAN Pi ships Debian `.deb` packages. Follow [Packaging](https://github.com/WLAN-Pi/developers/blob/main/architecture/PACKAGING.md) and [FHS](https://github.com/WLAN-Pi/developers/blob/main/architecture/FHS.md).

Package names use the `wlanpi-` prefix. Set `debhelper-compat (= 13)`. Python apps use `dh_virtualenv` where that is how the app is installed. App files go under `/opt/wlanpi-{app}`, config under `/etc/wlanpi-{app}`, logs under `/var/log/wlanpi-{app}`, and variable data under `/var/lib/wlanpi-{app}`. Install systemd units where [FHS](https://github.com/WLAN-Pi/developers/blob/main/architecture/FHS.md#shared-system-paths) says to put them.

## Documentation

Follow [README Standards](https://github.com/WLAN-Pi/developers/blob/main/style/README_STANDARDS.md).

Use Markdown, not reStructuredText. Open with a short What / Why section. Use Title Case headings and a language hint on every fenced code block. Keep the tone neutral. Link back to the developers repository.

## Git and releases

Follow [Contributing](https://github.com/WLAN-Pi/developers/blob/main/CONTRIBUTING.md), [Git Workflow](https://github.com/WLAN-Pi/developers/blob/main/GIT_WORKFLOW.md), [Release Process](https://github.com/WLAN-Pi/developers/blob/main/RELEASE_PROCESS.md), and [debchange](https://github.com/WLAN-Pi/developers/blob/main/style/DCH.md).

`main` is the long-lived development branch. Open pull requests against it. Do not commit directly to `main`. Manage `debian/changelog` with `dch`.

## Licensing

Prefer BSD-3-Clause for a new project. Follow the [Licensing Guide](https://github.com/WLAN-Pi/developers/blob/main/licensing/licensing.md).

## Recognizing Cruft

Do not copy the patterns below. They appear in old repos and old docs. They are not the current target. This list names patterns, not repositories.

- A system-wide `sudo python3 -m pip install`.
- A hardcoded `python3.9` or `python3.11` path on work that targets Trixie.
- Bookworm, Bullseye, or Buster described as the current development target.
- `setup.py` for a new package.
- A pattern taken from an archived, abandoned, or legacy repo.

When a local file and this guidance disagree, follow this file.
