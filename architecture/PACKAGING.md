# Debian Packaging Guide

This document defines the Debian packaging standards for WLAN Pi applications distributed through our [packagecloud archive](https://packagecloud.io/wlanpi/).

**Note:** WLAN Pi exclusively uses Debian packaging. All applications must be packaged as `.deb` files for distribution.

## For newcomers

If you're new to WLAN Pi packaging, start with:

1. [Packaging Example](../PACKAGING_EXAMPLE.md) - Complete walkthrough of creating a package
2. Review existing packages on the [WLAN Pi GitHub](https://github.com/WLAN-Pi/)
3. Read the references at the end of this document

## Intent to package

If you want to create a new package for WLAN Pi:

1. Contact a [team member](https://github.com/orgs/WLAN-Pi/people) to discuss your idea
2. Review this guide and the Packaging Example
3. Check [FHS Policy](FHS.md) for filesystem standards

## Package structure

All WLAN Pi packages must follow this structure:

```
project-name/
├── debian/                 # Packaging files
│   ├── changelog          # Version history
│   ├── control            # Package metadata (debhelper-compat level lives here)
│   ├── copyright          # License information
│   ├── rules              # Build instructions
│   ├── source/format      # 3.0 (native) or 3.0 (quilt)
│   ├── <package>.lintian-overrides
│   └── *.{install,postinst,prerm,...}  # Additional control files
├── src/ or {app}/         # Application source code
├── tests/                 # Test files
├── requirements.txt       # Runtime Python dependencies, when the package has any
├── pyproject.toml         # Python package metadata (if applicable)
└── README.md             # Project documentation
```

Declare the debhelper compatibility level once, in `debian/control`, as
`debhelper-compat (= 13)`. Do not ship `debian/compat`. Debhelper 13.24
errors if both are present (`debhelper compat level specified both in
debian/compat and in debian/control`) and `dh clean` fails. A compat level
of 13 in `debian/compat` alone is deprecated.

Every package has `debian/copyright` (DEP-5) and `debian/source/format`.
Maintainer scripts that you write yourself include a `#DEBHELPER#` line.
`debian/rules` and maintainer scripts use LF line endings. A CRLF shebang
does not execute (`cannot execute: required file not found`, because the
kernel looks up `/bin/sh` with a trailing CR).

## Source Format and Version

First-party WLAN Pi packages keep `debian/` in the same git tree as the
application. That is a native package:

- `debian/source/format` contains `3.0 (native)`.
- The changelog version is `major.minor.patch` with no Debian revision:
  `wlanpi-yourapp (1.2.3) unstable; urgency=medium`.
- The built filename is `wlanpi-yourapp_1.2.3_<arch>.deb`. `dpkg` uses the
  changelog version as-is. It does not append `-1`.
- For a Python package, `__version__.py` is that same `major.minor.patch`,
  and the same pre-release (`a`, `b`, or `rc` and its number) when there is
  one. `pyproject.toml`'s `version` matches it. The deploy gate
  `check-py-deb-pkg-versions-match` compares those two parts. Spellings are
  normalized, so `1.1.0~beta3-1` matches `1.1.0b3`. An epoch, a Debian
  revision, a `~dev` snapshot, and `.postN` are not compared. Bump the
  changelog and `__version__.py` together.

`dpkg-buildpackage -b` does not enforce this. The CI build runs
`dpkg-source -b` (see
[sbuild-debian-package](https://github.com/WLAN-Pi/sbuild-debian-package/blob/main/build.sh)).
For `3.0 (native)`, a version that contains a revision fails there:

```text
dpkg-source: error: can't build with source format '3.0 (native)': native package version may not have a revision
```

A `1.0` source format (or no `debian/source/format`, which defaults to
`1.0`) with a `-N` version still produces a tarball, and lintian 2.122
reports an error on the source package:
`malformed-debian-changelog-version <version> (for native)`.

Do not drop `-N` from a version that is already published. `1.2.3-1` sorts
higher than `1.2.3`, so the next native upload has to be a higher upstream
version, for example `1.2.4`.

`3.0 (quilt)` is for a separate upstream tarball. `dpkg-source` requires
`../<package>_<upstream>.orig.tar.*`. A quilt version with no revision fails
with `no upstream tarball found`.

A forked upstream project versions as `<upstream>+wlanpi<N>`, for example
`2.3.0+wlanpi1`. See [Scope](../RELEASING.md#scope).

## Runtime and Test Dependencies

`dh_virtualenv` runs `pip install -r requirements.txt` when that file exists
in the source tree (dh-virtualenv 1.2.2). Anything listed there is unpacked
into `/opt/<package>` inside the `.deb`. Put runtime dependencies only in
`requirements.txt` (or generate it from `requirements.in` with pip-tools).
Put pytest and other test tools in a `pyproject.toml` extra, and install
that extra in CI and local test environments (`pip install -e ".[test]"`).
Do not pass the test extra to `dh_virtualenv`.

## Required Debian files

### debian/control

```
Source: wlanpi-yourapp
Section: contrib/python
Priority: optional
Maintainer: Your Name <your.email@example.com>
Build-Depends: debhelper-compat (= 13), python3, python3-venv, dh-virtualenv (>= 1.0)
Standards-Version: 4.7.2
Homepage: https://github.com/wlan-pi/wlanpi-yourapp

Package: wlanpi-yourapp
Architecture: any
Pre-Depends: dpkg (>= 1.16.1), python3, ${misc:Pre-Depends}
Depends: ${misc:Depends}, systemd
Description: Short description
 Long description that can span
 multiple lines (indented by one space).
```

**Key fields:**

| Field | Value |
|-------|-------|
| Section | `contrib/python` for Python apps, `embedded` for firmware and shell packages, `utils`/`net`/`x11` where a more specific section fits |
| Priority | `optional` |
| Standards-Version | `4.7.2`, the policy version shipped in Debian Trixie (`debian-policy` 4.7.2.0). The fourth component of the package version is non-normative, so the field has three components. |
| Package | Must match the source name with `wlanpi-` prefix |
| Architecture | `all` for pure Python/shell/firmware, `any` when the package ships compiled extensions or native binaries |

The `Architecture: any` example above applies to packages that bundle native
dependencies. Packages that ship only interpreted code or data use
`Architecture: all`.

Trixie is the development target. Suites that are still supported keep a
`debian/<codename>` branch, including `debian/bookworm`
([branch strategy](../RELEASE_PROCESS.md#branch-strategy-quick-reference)).
Bookworm's debhelper 13.11.4 provides `debhelper-compat (= 13)`, and its
dh-virtualenv is 1.2.2-1.3, so the build-dependencies in the control file
above are satisfiable there. `Standards-Version: 4.7.2` names the policy
version in Trixie's `debian-policy` 4.7.2.0. Bookworm ships `debian-policy`
4.6.2.0. The field records which policy the packaging follows.


### debian/changelog

```
wlanpi-yourapp (1.2.3) unstable; urgency=medium

  * Initial release
  * Add core functionality
  * Add systemd service

 -- Your Name <your.email@example.com>  Thu, 22 Oct 2026 00:00:00 +0000
```

Use `dch` to manage this file. For a native package the argument has no
Debian revision:

```bash
dch -v 1.2.3 "Initial release"
dch -r ""
```

### debian/source/format

```text
3.0 (native)
```

See [Source Format and Version](#source-format-and-version).

### debian/copyright

Use [DEP-5 format](https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/):

```
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: wlanpi-yourapp
Source: https://github.com/wlan-pi/wlanpi-yourapp

Files: *
Copyright: 2026 Your Name <your.email@example.com>
License: BSD-3-Clause

License: BSD-3-Clause
 [Full license text here]
```

BSD-3-Clause is the standard license for new WLAN Pi projects. See the
[Licensing Guide](../licensing/licensing.md).

### debian/rules

Standard dh_virtualenv setup:

```makefile
#!/usr/bin/make -f

export DH_VIRTUALENV_INSTALL_ROOT=/opt

PACKAGE=$(shell dh_listpackages)
DH_VENV_DIR=debian/$(PACKAGE)$(DH_VIRTUALENV_INSTALL_ROOT)/$(PACKAGE)

%:
	dh $@ --with python-virtualenv

override_dh_virtualenv:
	dh_virtualenv \
		--python python3 \
		--builtin-venv \
		--install-suffix wlanpi-yourapp \
		--extra-pip-arg "--no-compile"
	find $(DH_VENV_DIR) -type d -name '__pycache__' -print0 | xargs -0r rm -rf
	find $(DH_VENV_DIR) -name '*.pyc' -delete
	rm -rf $(DH_VENV_DIR)/bin/pip* \
		$(DH_VENV_DIR)/bin/wheel \
		$(DH_VENV_DIR)/.gitignore \
		$(DH_VENV_DIR)/lib/python*/site-packages/pip \
		$(DH_VENV_DIR)/lib/python*/site-packages/pip-*.dist-info \
		$(DH_VENV_DIR)/lib/python*/site-packages/setuptools \
		$(DH_VENV_DIR)/lib/python*/site-packages/setuptools-*.dist-info \
		$(DH_VENV_DIR)/lib/python*/site-packages/wheel \
		$(DH_VENV_DIR)/lib/python*/site-packages/wheel-*.dist-info
```

`--builtin-venv` is required when the build chroot has `python3-venv` and
no `virtualenv` binary. dh-virtualenv 1.2.2 on Trixie depends on
`virtualenv | python3-virtualenv | python3-venv`. Without the flag it
executes `virtualenv` and the build fails with `FileNotFoundError`.
`--no-compile` plus the cleanup stops the package shipping `__pycache__`
and pip, which lintian reports as `package-installs-python-pycache-dir`
(an error) and `wrong-path-for-interpreter` on `bin/pip*`.

Put the unit file at `debian/<package>.service` and let `dh_installsystemd`
install it. Override that helper only when one unit needs different start
behaviour. Debhelper 13.24 (Trixie) installs the unit into
`/usr/lib/systemd/system`. Debhelper 13.11.4 (Bookworm) still installs it
into `lib/systemd/system`. Bookworm lintian 2.116.3 accepts both of those
paths: `systemd-service-in-odd-location` matches `etc/systemd/system` only.
Trixie lintian reports `aliased-location` for the `lib/` path. The helper
inserts `deb-systemd-helper` enable/state calls and `deb-systemd-invoke`
start/stop at `#DEBHELPER#`.

Make executable:
```bash
chmod +x debian/rules
```

### debian/{package}.install

Define additional files to install:

```
config/yourapp.conf etc/wlanpi-yourapp/
```

A unit that is not named `debian/<package>.service` (a helper unit, a
drop-in) goes in the `.install` file with destination
`usr/lib/systemd/system/` on Trixie and on Bookworm. On Trixie,
`lib/systemd/system/` is the `aliased-location` path.

### Maintainer Scripts

Create the service user and writable directories before `#DEBHELPER#`.
The token expands to the `dh_installsystemd` block, which starts the unit
on configure. `chown` to `wlanpi` before `useradd` fails the install
(`invalid user`).

`deb-systemd-helper` implements `enable`, `disable`, `purge`, `mask`,
`unmask`, `is-enabled`, `was-enabled`, `debian-installed`, `update-state`,
and `reenable`. It has no `start` or `stop`. Called from a maintainer
script (`DPKG_MAINTSCRIPT_PACKAGE` set), `start` and `stop` exit 0 and do
nothing. Starting and stopping is `deb-systemd-invoke`, which
`dh_installsystemd` inserts. Do not call either helper by hand.

```bash
#!/bin/sh
set -e

case "$1" in
    configure)
        if ! getent group wlanpi >/dev/null; then
            groupadd --system wlanpi
        fi
        if ! id -u wlanpi >/dev/null 2>&1; then
            useradd --system --gid wlanpi --shell /usr/sbin/nologin --comment "WLAN Pi service" wlanpi
        fi
        mkdir -p /var/log/wlanpi-yourapp
        chown wlanpi:wlanpi /var/log/wlanpi-yourapp
        ;;
esac

#DEBHELPER#

exit 0
```

A `prerm` you write yourself is the same shape: `set -e`, then `#DEBHELPER#`,
then `exit 0`. Omit `postinst`/`prerm` entirely when the generated snippets
are enough.

Scripts are executable and LF. `#DEBHELPER#` missing from a script you ship
is the lintian warning `maintainer-script-lacks-debhelper-token`.

## Lintian and /opt

`dir-or-file-in-opt` is an error (lintian 2.122 on Trixie), not a warning.
`dir-or-file-in-etc-opt` is a separate error for `/etc/opt`. WLAN Pi
applications install under `/opt` on purpose. Ship
`debian/<package>.lintian-overrides` with the justification above the tag.
Omitting the path suppresses every instance of the tag, which is what a
virtualenv tree needs:

```text
# dh_virtualenv installs this add-on application and its dependencies under
# /opt/wlanpi-yourapp. /opt is reserved for add-on software; these packages
# are not candidates for the Debian archive.
wlanpi-yourapp: dir-or-file-in-opt
```

The console script's shebang points at `/opt/<package>/bin/python`. Lintian
warns `unusual-interpreter` for that path. That warning is expected for a
`dh_virtualenv` entry point.

`dh_lintian` installs the overrides file. Do not replace it with an empty
override.

## Build process

### Local build

```bash
# Install build dependencies
sudo apt-get install build-essential debhelper dh-virtualenv python3-venv

# Build the package
dpkg-buildpackage -us -uc -b

# Result: ../wlanpi-yourapp_1.2.3_<arch>.deb
```

On the arm64 CI runner the architecture is `arm64`. A local amd64 build
produces `amd64` in that position.

### CI/CD build

A new repository calls the reusable workflows in
[WLAN-Pi/gh-workflows](https://github.com/WLAN-Pi/gh-workflows). Do not copy
the `sbuild` and `package_cloud` steps into the repo. The caller files are
`build-and-archive-debian-package.yml` and `deploy-to-packagecloud.yml`, and
they `uses:` the shared workflows:

1. **Build and archive** calls `sbuild-pkg.yml`. It builds with `sbuild` and
   uploads the `.deb` as a workflow artifact. Trigger paths vary per repo:
   some watch only `debian/changelog`, others ignore docs-only changes. It
   does not run tests or lint; those are separate workflows.
2. **Deploy to Packagecloud** calls `sbuild-deploy-pkg.yml`. A
   `debian/changelog` change pushed to `main` builds and uploads to the
   Packagecloud `dev` repository.

The full caller is in the [Packaging Example](../PACKAGING_EXAMPLE.md#step-8-github-actions-workflows).
How each repo builds and releases is in
[Repository Reference](../REPOS.md).

Releases are only cut when a `debian/changelog` change reaches `main`; pushing
a git tag does not deploy. See [Release Process](../RELEASE_PROCESS.md) for details.

## Testing

Before submitting:

1. Build succeeds: `dpkg-buildpackage -us -uc -b`
2. Package installs: `sudo dpkg -i ../wlanpi-yourapp_*.deb`
3. Service runs: `sudo systemctl status wlanpi-yourapp`
4. Application works: `wlanpi-yourapp --help`

## References

- [Packaging Example](../PACKAGING_EXAMPLE.md) - Complete walkthrough with code
- [Debian New Maintainers' Guide](https://www.debian.org/doc/manuals/maint-guide/)
- [Debian Policy](https://www.debian.org/doc/debian-policy/)
- [Debian Developer's Reference](https://www.debian.org/doc/manuals/developers-reference/)
- [dh-virtualenv Documentation](https://dh-virtualenv.readthedocs.io/)
