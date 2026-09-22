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
│   └── *.{install,postinst,prerm,...}  # Additional control files
├── src/ or {app}/         # Application source code
├── tests/                 # Test files
├── requirements.txt       # Python dependencies (if applicable)
├── pyproject.toml         # Python package metadata (if applicable)
└── README.md             # Project documentation
```

Modern packages declare the debhelper compatibility level in
`debian/control` via `debhelper-compat (= 13)` and do not ship a
`debian/compat` file. A `debian/compat` file is the legacy style and is only
kept in older packages.

## Required Debian files

### debian/control

```
Source: wlanpi-yourapp
Section: contrib/python
Priority: optional
Maintainer: Your Name <your.email@example.com>
Build-Depends: debhelper-compat (= 13), python3, python3-venv, dh-virtualenv (>= 1.0)
Standards-Version: 4.7.0
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
| Standards-Version | Use the current Debian policy version (4.7.0 on Trixie) |
| Package | Must match the source name with `wlanpi-` prefix |
| Architecture | `all` for pure Python/shell/firmware, `any` when the package ships compiled extensions or native binaries |

The `Architecture: any` example above applies to packages that bundle native
dependencies. Packages that ship only interpreted code or data use
`Architecture: all`; see [Repository Reference](../REPOS.md) for the current
state of each repo.


### debian/changelog

```
wlanpi-yourapp (1.0.0) unstable; urgency=medium

  * Initial release
  * Add core functionality
  * Add systemd service

 -- Your Name <your.email@example.com>  Mon, 01 Jan 2026 00:00:00 +0000
```

Use `dch` to manage this file:
```bash
dch -v 1.0.0 "Initial release"
dch -r ""
```

### debian/compat (legacy)

New packages set `debhelper-compat (= 13)` in `debian/control` instead of
shipping a `debian/compat` file. If you touch a package that still has one,
leave the level alone unless you are deliberately modernizing the package.

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

%:
	dh $@ --with python-virtualenv

override_dh_virtualenv:
	dh_virtualenv \
		--python python3 \
		--install-suffix wlanpi-yourapp
```

Make executable:
```bash
chmod +x debian/rules
```

### debian/{package}.install

Define additional files to install:

```
config/yourapp.conf etc/wlanpi-yourapp/
systemd/yourapp.service lib/systemd/system/
```

## Build process

### Local build

```bash
# Install build dependencies
sudo apt-get install build-essential debhelper dh-virtualenv python3-venv

# Build the package
dpkg-buildpackage -us -uc -b

# Result: ../wlanpi-yourapp_1.0.0-1_arm64.deb
```

### CI/CD build

GitHub Actions automatically build packages by calling the reusable workflows
in [WLAN-Pi/gh-workflows](https://github.com/WLAN-Pi/gh-workflows):

1. **Build and archive** (`build-and-archive-debian-package.yml`) - Builds the
   package with `sbuild` and uploads it as a workflow artifact. Trigger paths
   vary per repo: some watch only `debian/changelog`, others ignore docs-only
   changes. It does not run tests or lint; those are separate workflows.
2. **Deploy to Packagecloud** (`deploy-to-packagecloud.yml`) - Triggered by a
   `debian/changelog` change pushed to a release branch (`main`, and `dev` for
   repos that keep a `dev` branch). Builds and uploads to the Packagecloud
   `dev` repository.

Releases are only cut when a `debian/changelog` change reaches the release
branch; pushing a git tag does not deploy. See
[Release Process](../RELEASE_PROCESS.md) for details.

## Testing

Before submitting:

1. Build succeeds: `dpkg-buildpackage -us -uc -b`
2. Package installs: `sudo dpkg -i ../wlanpi-yourapp_*.deb`
3. Service runs: `sudo systemctl status wlanpi-yourapp`
4. Application works: `wlanpi-yourapp --help`

## OSS attribution

If your package relies on other open source projects, document them in `OSS.md` at the repository root:

```markdown
# Open Source Attribution

## Dependencies

- library-name (License): Description
  - Source: https://github.com/user/repo

## Included Assets

- Asset name (License): Description
```

## References

- [Packaging Example](../PACKAGING_EXAMPLE.md) - Complete walkthrough with code
- [Debian New Maintainers' Guide](https://www.debian.org/doc/manuals/maint-guide/)
- [Debian Policy](https://www.debian.org/doc/debian-policy/)
- [Debian Developer's Reference](https://www.debian.org/doc/manuals/developers-reference/)
- [dh-virtualenv Documentation](https://dh-virtualenv.readthedocs.io/)
