# Debian Packaging Guide

This document defines the Debian packaging standards for WLAN Pi applications distributed through our [packagecloud archive](https://packagecloud.io/wlanpi/).

**Note:** WLAN Pi exclusively uses Debian packaging. All applications must be packaged as `.deb` files for distribution.

## For newcomers

If you're new to WLAN Pi packaging, start with:

1. [Packaging Example](../PACKAGING_EXAMPLE.md) - Complete walkthrough of creating a package
2. Review existing packages on the [WLAN Pi GitHub](https://github.com/wlan-pi/)
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
│   ├── compat             # Debhelper compatibility level
│   ├── control            # Package metadata
│   ├── copyright          # License information
│   ├── rules              # Build instructions
│   └── *.{install,postinst,prerm,...}  # Additional control files
├── src/ or {app}/         # Application source code
├── tests/                 # Test files
├── requirements.txt       # Python dependencies (if applicable)
├── setup.py              # Python package setup (if applicable)
└── README.md             # Project documentation
```

## Required Debian files

### debian/control

```
Source: wlanpi-yourapp
Section: contrib/python
Priority: optional
Maintainer: Your Name <your.email@example.com>
Build-Depends: debhelper-compat (= 13), python3, python3-venv, dh-virtualenv (>= 1.0)
Standards-Version: 4.6.0
Homepage: https://github.com/wlan-pi/wlanpi-yourapp

Package: wlanpi-yourapp
Architecture: all
Pre-Depends: dpkg (>= 1.16.1), python3, ${misc:Pre-Depends}
Depends: ${misc:Depends}, systemd
Description: Short description
 Long description that can span
 multiple lines (indented by one space).
```

**Key fields:**

| Field | Value |
|-------|-------|
| Section | `contrib/python` for Python apps, `embedded` for firmware |
| Priority | `optional` |
| Standards-Version | Use latest (currently 4.6.0) |
| Package | Must match the source name with `wlanpi-` prefix |

### debian/changelog

```
wlanpi-yourapp (1.0.0) unstable; urgency=medium

  * Initial release
  * Add core functionality
  * Add systemd service

 -- Your Name <your.email@example.com>  Mon, 01 Jan 2024 00:00:00 +0000
```

Use `dch` to manage this file:
```bash
dch -v 1.0.0 "Initial release"
dch -r ""
```

### debian/compat

```
13
```

Compatibility level 13 is recommended and available in Debian stable (bullseye) and as a backport in oldstable (buster).

**Note:** Don't modify packages solely to update compat level.

### debian/copyright

Use [DEP-5 format](https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/):

```
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: wlanpi-yourapp
Source: https://github.com/wlan-pi/wlanpi-yourapp

Files: *
Copyright: 2024 Your Name <your.email@example.com>
License: MIT

License: MIT
 [Full license text here]
```

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

# Result: ../wlanpi-yourapp_1.0.0_all.deb
```

### CI/CD build

GitHub Actions automatically build packages:

1. **PR builds** - Triggered by `debian/changelog` changes, creates artifact
2. **Release builds** - Triggered by version tags, deploys to packagecloud

See [Release Process](../RELEASE_PROCESS.md) for details.

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
