# Agent Guidance

This repository states the standard for WLAN Pi work: how and why a thing is
done, and what the result should be. It is not an inventory of what each
repository currently is. When a repository differs, that is drift to fix in
that repository, or a deliberate change to the standard here. It is not a
documentation error.

The linked documents are the source of truth for their topics. This file does
not replace human review.

Org standards win on a cross-cutting rule: platform, packaging, versioning,
CI, and issues. A repository's own `AGENTS.md` may add build, release, or test
rules that apply only in that repository. `pi-gen`, `wlanpi-kernel`, and
`wlanpi-core` are examples. If a local rule conflicts with a cross-cutting
standard, raise the conflict. Do not silently follow either side.

## Authority

The [developers](https://github.com/WLAN-Pi/developers) repository is the
source of truth for how WLAN Pi software is built.

A README or an older branch shows what that repo did. It does not override
this repository. Archived repos and legacy repos never override the current
guidance here.

## Platform

Debian 13 Trixie is the development target. Plan and test on Python 3.13, the
system `python3` in Trixie. Declare `requires-python = ">=3.13"`. Do not pin
`==3.13`. Do not target Python 3.14 or 3.15. Do not select a production
interpreter with pyenv, conda, or uv. Production apps ship as `.deb` packages
and may use `dh_virtualenv` under `/opt/wlanpi-{app}`.

Suite defaults are Python 3.9 on Bullseye, Python 3.11 on Bookworm, and Python
3.13 on Trixie. All new work targets 3.13. `debian/bookworm` and
`debian/bullseye` exist only for a hotfix to an old release. That hotfix uses
the suite branch and that suite's Python. New work never targets those
branches. See
[Python version guidelines](https://github.com/WLAN-Pi/developers/blob/main/style/PYTHON.md#python-version-guidelines).

When the target suite or Python version changes, update this section and
`style/PYTHON.md` in the same change.

## How to work

- Be concise. Skip filler.
- Do not use an em dash. Do not use `--` as punctuation. `--` belongs only in a CLI flag or a URL.
- When the task is ambiguous, ask. Do not guess.
- Build only what was asked. Do not add files, abstractions, dependencies, or features that were not requested.
- Do not design for rare or future cases nobody asked about.
- Use the least code that solves the problem. After it works, do a second pass that simplifies and deletes unused code.
- Before you hand work off, review your own output. Read the change as a critic against the request, the platform rule above, and the linked docs. Fix what that review finds, then hand it off.
- Prefer boring, well-understood tools. If you reach for something novel, say why.
- Match the style of the file you are editing.
- Keep each pull request small enough to review. The size policy is in [PR Size and Scope](https://github.com/WLAN-Pi/developers/blob/main/CONTRIBUTING.md#pr-size-and-scope).

## Reviewing

This section applies to agent reviewers, QA passes, and the self-review in How to work.

- Judge customer impact before you raise an implementation gap. Describe a realistic task, the normal steps a user takes, and what the user materially loses.
- Report a finding only when it would materially prevent or mislead a customer doing ordinary work. Omit a low-impact finding. Do not include it at a lower priority.
- Rate each reported finding from 1 to 10 for likelihood and from 1 to 10 for severity. When likelihood times severity is below 5, open an issue and leave the code unchanged. A repository may set its own threshold in its `AGENTS.md`.

## Python

Follow [style/PYTHON.md](https://github.com/WLAN-Pi/developers/blob/main/style/PYTHON.md).

For a new package, use `pyproject.toml`, not `setup.py`. Declare `requires-python = ">=3.13"` and plan and test on 3.13. The app should run as `python -m app`. Parse arguments with `argparse`. Test with `pytest`. Use `tox` for test, lint, and format.

## Packaging

WLAN Pi ships Debian `.deb` packages. Follow [Packaging](https://github.com/WLAN-Pi/developers/blob/main/architecture/PACKAGING.md) and [FHS](https://github.com/WLAN-Pi/developers/blob/main/architecture/FHS.md).

Package names use the `wlanpi-` prefix. Set `debhelper-compat (= 13)`. Python apps use `dh_virtualenv` where that is how the app is installed. App files go under `/opt/wlanpi-{app}`, config under `/etc/wlanpi-{app}`, logs under `/var/log/wlanpi-{app}`, and variable data under `/var/lib/wlanpi-{app}`. Install systemd units where [FHS](https://github.com/WLAN-Pi/developers/blob/main/architecture/FHS.md#shared-system-paths) says to put them.

Set `debian/source/format` to `3.0 (native)` for a first-party package. A version has no Debian revision. `__version__.py` and `debian/changelog` carry the same version. See [Source Format and Version](https://github.com/WLAN-Pi/developers/blob/main/architecture/PACKAGING.md#source-format-and-version).

A forked upstream project versions as `<upstream>+wlanpi<N>`, for example `2.3.0+wlanpi1`. The suffix marks our rebuild of that upstream version, so we do not take the number upstream will publish next. See [Scope](https://github.com/WLAN-Pi/developers/blob/main/RELEASING.md#scope).

## CI

Packaging CI on `main` follows [Target Debian suite](https://github.com/WLAN-Pi/developers/blob/main/architecture/PACKAGING.md#target-debian-suite), plus compiler builds and tests.

## Documentation

Follow [README Standards](https://github.com/WLAN-Pi/developers/blob/main/style/README_STANDARDS.md).

Use Markdown, not reStructuredText. Open with a short What / Why section. Use Title Case headings and a language hint on every fenced code block. Keep the tone neutral. Link back to the developers repository.

## Git and releases

Follow [Contributing](https://github.com/WLAN-Pi/developers/blob/main/CONTRIBUTING.md), [Git Workflow](https://github.com/WLAN-Pi/developers/blob/main/GIT_WORKFLOW.md), [Land a Fix and Cut a Release](https://github.com/WLAN-Pi/developers/blob/main/RELEASING.md), [Release Process](https://github.com/WLAN-Pi/developers/blob/main/RELEASE_PROCESS.md), and [debchange](https://github.com/WLAN-Pi/developers/blob/main/style/DCH.md).

`main` is the long-lived development branch. Open pull requests against it. Do not commit directly to `main`. When `main` moves, merge `main` into your branch. Do not rebase or force-push a shared branch.

What is live today is [What Is Live](https://github.com/WLAN-Pi/developers/blob/main/RELEASING.md#what-is-live):

- A fix or feature pull request does not change the version, `__version__.py`, or `debian/changelog`.
- A release pull request sets the version and writes the changelog with `dch`.
- A `debian/changelog` push to `main` uploads to [wlanpi/dev](https://packagecloud.io/wlanpi/dev).
- Promotion to [wlanpi/main](https://packagecloud.io/wlanpi/main) is done by hand. Check both repos before you call a version released.
- An upload to `wlanpi/main` when the release pull request merges, and an automatic tag, are planned. They are not live. Do not describe them as current behavior.

pi-gen and the kernel follow their own release rules. See [Scope](https://github.com/WLAN-Pi/developers/blob/main/RELEASING.md#scope).

## Images

These are standards for image contents, not a reading of a current build.

- WLAN Pi Go is BE200-only. Ship only BE200 firmware: every `iwlwifi-gl-c0-fm-c0-*` ucode file, plus `pnvm`. Other device firmware does not match that radio.
- The Go image must not ship `wpa_supplicant` and must not run it. That supplicant is not part of the Go.
- A person using the Go must be able to set the regulatory domain.
- `wlanpi-desktop` is optional. Install it with apt when it is wanted. Do not preinstall it in the full image.

## Issues

An issue states the problem, the evidence, the impact, outcome-based done-when criteria, and the constraints. Put any approach in a Notes section. Notes are not binding. An agent briefed from an issue weighs alternatives. It does not treat Notes as the required design.

## Licensing

Prefer BSD-3-Clause for a new project. Follow the [Licensing Guide](https://github.com/WLAN-Pi/developers/blob/main/licensing/licensing.md).

## Recognizing Cruft

Do not copy the patterns below. They appear in old repos and old docs. They are not the current target. This list names patterns, not repositories.

- A system-wide `sudo python3 -m pip install`.
- A hardcoded `python3.9` or `python3.11` path on work that targets Trixie.
- Bookworm, Bullseye, or Buster described as the target for new work.
- `setup.py` for a new package.
- A Debian revision such as `-1` on a new first-party version.
- A version or changelog bump inside a fix pull request.
- A pattern taken from an archived or legacy repo.
