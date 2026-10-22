# Packaging Example: Creating a WLAN Pi Package

This guide walks through creating a complete WLAN Pi package from scratch. By the end, you'll understand:

- How WLAN Pi applications are structured
- How to create Debian packaging files
- How to use GitHub Actions for CI/CD
- The complete workflow from code to deployment

## What we're building

We'll create `wlanpi-hello` - a simple "Hello World" application that demonstrates all the key concepts:

- Python application using dh_virtualenv
- Systemd service
- Configuration files
- Logging
- CI/CD workflow

## Project structure

```
wlanpi-hello/
├── debian/                    # Debian packaging files
│   ├── changelog              # Version history
│   ├── control                # Package metadata
│   ├── copyright              # License info
│   ├── postinst               # Post-install script
│   ├── prerm                  # Pre-remove script
│   ├── rules                  # Build instructions
│   ├── source/
│   │   └── format             # 3.0 (native)
│   ├── wlanpi-hello.install   # File installation rules
│   ├── wlanpi-hello.lintian-overrides
│   └── wlanpi-hello.service   # Installed by dh_installsystemd
├── src/                       # Application source
│   └── hello/
│       ├── __init__.py
│       ├── __version__.py
│       └── main.py
├── config/                    # Configuration files
│   └── hello.conf
├── tests/                     # Test files
│   └── test_hello.py
├── pyproject.toml             # Python package metadata
├── README.md                  # Project documentation
└── .github/
    └── workflows/             # CI/CD workflows
        ├── build.yml
        └── deploy.yml
```

## Step 1: Application code

Create the Python application in `src/hello/main.py`:

```python
"""WLAN Pi hello world - A simple example."""

import argparse
import logging
import sys
from pathlib import Path

logger = logging.getLogger("wlanpi-hello")


def setup_logging():
    """Setup logging configuration."""
    log_dir = Path("/var/log/wlanpi-hello")
    log_dir.mkdir(exist_ok=True)

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        handlers=[
            logging.FileHandler(log_dir / "hello.log"),
            logging.StreamHandler(sys.stdout),
        ],
    )


def main():
    setup_logging()
    parser = argparse.ArgumentParser(description="WLAN Pi hello world")
    parser.add_argument(
        "--config",
        default="/etc/wlanpi-hello/hello.conf",
        help="Path to configuration file",
    )
    parser.add_argument(
        "--message", default="Hello from WLAN Pi!", help="Message to display"
    )
    args = parser.parse_args()

    # Load config if exists
    if Path(args.config).exists():
        logger.info(f"Loading config from {args.config}")

    logger.info(f"Message: {args.message}")
    print(args.message)

    return 0


if __name__ == "__main__":
    sys.exit(main())
```

Create `src/hello/__version__.py`. The deploy version gate reads this file.
Its `major.minor.patch` is the changelog version:

```python
"""Package version. Keep major.minor.patch identical to debian/changelog."""
__version__ = "1.0.0"
```

Create `src/hello/__init__.py`:

```python
"""WLAN Pi Hello package"""
from hello.__version__ import __version__

__all__ = ["__version__"]
```

## Step 2: Python package setup

New projects use `pyproject.toml` for package metadata. Create `pyproject.toml`:

```toml
[build-system]
requires = ["setuptools>=45", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "wlanpi-hello"
version = "1.0.0"
description = "WLAN Pi Hello example application"
readme = "README.md"
license = {text = "BSD-3-Clause"}
requires-python = ">=3.13"
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: System Administrators",
    "License :: OSI Approved :: BSD License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.13",
]
dependencies = []

[project.optional-dependencies]
test = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
]

[project.scripts]
wlanpi-hello = "hello.main:main"

[tool.setuptools.packages.find]
where = ["src"]

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = "-v --tb=short"
```

Create `requirements.txt` for runtime dependencies only. `dh_virtualenv`
runs `pip install -r requirements.txt` whenever the file exists, so a test
tool listed here is unpacked into the `.deb`. This example has no runtime
dependencies. Pytest stays in the `test` extra above.

```text
# Runtime Python dependencies for dh_virtualenv.
# Keep test tools out of this file; they belong in the pyproject test extra.
```

## Step 3: Configuration

Create `config/hello.conf`:

```ini
# WLAN Pi Hello Configuration
# Location: /etc/wlanpi-hello/hello.conf

[DEFAULT]
# Default message to display
message = Hello from WLAN Pi!

[LOGGING]
# Log level: DEBUG, INFO, WARNING, ERROR
level = INFO
```

## Step 4: Systemd service

Create `debian/wlanpi-hello.service`. On Trixie, debhelper 13.24's
`dh_installsystemd` installs a unit of that name into
`/usr/lib/systemd/system` and wires enable/start/stop into `#DEBHELPER#`.
Leave it out of the `.install` file. Bookworm's debhelper 13.11.4 still
writes `lib/systemd/system`; see
[debian/rules](architecture/PACKAGING.md#debianrules).

```ini
[Unit]
Description=WLAN Pi Hello Service
After=network.target

[Service]
Type=simple
User=wlanpi
Group=wlanpi
ExecStart=/opt/wlanpi-hello/bin/wlanpi-hello --config /etc/wlanpi-hello/hello.conf
Restart=always
RestartSec=5

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/log/wlanpi-hello

[Install]
WantedBy=multi-user.target
```

## Step 5: Debian packaging

### debian/control

```
Source: wlanpi-hello
Section: contrib/python
Priority: optional
Maintainer: Your Name <you@example.com>
Build-Depends: debhelper-compat (= 13), python3, python3-venv, dh-virtualenv (>= 1.0)
Standards-Version: 4.7.2
Homepage: https://github.com/wlan-pi/wlanpi-hello

Package: wlanpi-hello
Architecture: any
Pre-Depends: dpkg (>= 1.16.1), python3, ${misc:Pre-Depends}
Depends: ${misc:Depends}, systemd
Description: WLAN Pi Hello World example application
 A simple example application demonstrating WLAN Pi packaging standards.
 Includes Python application, systemd service, and configuration files.
```

### debian/changelog

You should use `dch` from `devscripts` to generate this.

```
wlanpi-hello (1.0.0) unstable; urgency=medium

  * Initial release
  * Add basic hello functionality
  * Add systemd service
  * Add configuration file support

 -- Your Name <you@example.com>  Mon, 01 Jan 2024 00:00:00 +0000
```

Do not add `debian/compat`. The compat level is the `debhelper-compat (= 13)`
build dependency above. Shipping both makes `dh` fail:

```text
dh: error: debhelper compat level specified both in debian/compat and in debian/control
```

### debian/source/format

```text
3.0 (native)
```

This package is native: `debian/` lives in the same git tree as the
application, and the changelog version `1.0.0` has no Debian revision.
The built file is `wlanpi-hello_1.0.0_<arch>.deb`. Details and the quilt
exception are in
[Source Format and Version](architecture/PACKAGING.md#source-format-and-version).

### debian/copyright

```
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: wlanpi-hello
Source: https://github.com/wlan-pi/wlanpi-hello

Files: *
Copyright: 2026 Your Name <you@example.com>
License: BSD-3-Clause

License: BSD-3-Clause
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 .
 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
 .
 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
 .
 3. Neither the name of the copyright holder nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.
 .
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
```

### debian/rules

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
		--install-suffix wlanpi-hello \
		--extra-pip-arg "--no-compile"
	# Bytecode and pip are not needed at runtime and lintian rejects them.
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

`--builtin-venv` uses the stdlib `venv` module. On Trixie, `dh-virtualenv`
depends on `virtualenv | python3-virtualenv | python3-venv`. This example
build-depends on `python3-venv`. Without `--builtin-venv`, `dh_virtualenv`
executes `virtualenv` and fails with `FileNotFoundError` when that binary
is not installed. There is no `override_dh_installsystemd`: the default
helper picks up `debian/wlanpi-hello.service`.

Make it executable:

```bash
chmod +x debian/rules
```

### debian/wlanpi-hello.install

```
config/hello.conf etc/wlanpi-hello/
```

### debian/wlanpi-hello.lintian-overrides

`dir-or-file-in-opt` is an error. The override and the reason are in
[Lintian and /opt](architecture/PACKAGING.md#lintian-and-opt).

```text
# dh_virtualenv installs this add-on application and its dependencies under
# /opt/wlanpi-hello. /opt is reserved for add-on software; these packages
# are not candidates for the Debian archive.
wlanpi-hello: dir-or-file-in-opt
```

### debian/postinst

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
        mkdir -p /var/log/wlanpi-hello
        chown wlanpi:wlanpi /var/log/wlanpi-hello
        ;;
esac

#DEBHELPER#

exit 0
```

Create the user before `chown`. The other order fails the install with
`chown: invalid user: 'wlanpi:wlanpi'`. `#DEBHELPER#` comes after that,
because it expands to the `dh_installsystemd` block that starts the
service. `deb-systemd-helper` has no `start` or `stop` subcommand. From a
maintainer script those arguments exit 0 and do not start or stop anything.
`deb-systemd-invoke start` and `stop` are what the helper inserts.

Make it executable:

```bash
chmod +x debian/postinst
```

### debian/prerm

```bash
#!/bin/sh
set -e

#DEBHELPER#

exit 0
```

`#DEBHELPER#` is required in every maintainer script you ship. It is where
`dh_installsystemd` inserts `deb-systemd-invoke stop` for `prerm`. Use LF
line endings. A CRLF shebang fails with `cannot execute: required file not found`.

Make it executable:

```bash
chmod +x debian/prerm
```

## Step 6: Testing

Create `tests/test_hello.py`:

```python
"""Tests for wlanpi-hello application."""

import sys
from unittest.mock import patch

from hello.main import main


class TestHello:
    """Test cases for the hello application."""

    def test_main_default(self):
        """Test main function with default message."""
        with patch.object(sys, "argv", ["wlanpi-hello"]):
            with patch("builtins.print") as mock_print:
                with patch("hello.main.setup_logging"):
                    result = main()
                    assert result == 0
                    mock_print.assert_called_once_with("Hello from WLAN Pi!")

    def test_main_custom_message(self):
        """Test main function with custom message."""
        with patch.object(sys, "argv", ["wlanpi-hello", "--message", "Test"]):
            with patch("builtins.print") as mock_print:
                with patch("hello.main.setup_logging"):
                    result = main()
                    assert result == 0
                    mock_print.assert_called_once_with("Test")

    def test_main_returns_integer(self):
        """Test that main returns an integer exit code."""
        with patch.object(sys, "argv", ["wlanpi-hello"]):
            with patch("builtins.print"):
                with patch("hello.main.setup_logging"):
                    result = main()
                    assert isinstance(result, int)
```

Create virtual environment and source it:

```bash
python3 -m venv venv
source venv/bin/activate
```

Run tests with pytest:

```bash
# Install the package and its test extra. requirements.txt is the runtime
# set shipped in the .deb.
pip install -e ".[test]"

# Run tests
pytest

# Run with coverage report
pytest --cov=hello --cov-report=term-missing

# Run with verbose output
pytest -v
```

## Step 7: Build the package

Test the build locally:

```bash
# Install build dependencies
sudo apt-get install build-essential debhelper dh-virtualenv python3-venv

# Build the package
dpkg-buildpackage -us -uc -b

# Check the result
ls ../*.deb
```

You should see `wlanpi-hello_1.0.0_<arch>.deb` in the parent directory.
The version is the changelog version `1.0.0`, with no `-1`. On a WLAN Pi
or the arm64 CI runner, `<arch>` is `arm64`. An amd64 build machine
produces `wlanpi-hello_1.0.0_amd64.deb`.

## Step 8: GitHub actions workflows

Create `.github/workflows/build.yml`:

```yaml
name: Build and Archive Debian Package

on:
  # Allow manual runs from the Actions tab
  workflow_dispatch:
  pull_request:
    paths-ignore: # ignore files that don't change build output
      - '**.md'
      - .github/dependabot.yml
      - .gitignore
      - LICENSE

jobs:
  format:
    name: Get formatted version for filename
    uses: WLAN-Pi/gh-workflows/.github/workflows/get-formatted-version-string.yml@main
  sbuild:
    name: sbuild pkg
    needs:
      - format
    uses: WLAN-Pi/gh-workflows/.github/workflows/sbuild-pkg.yml@main
    with:
      pkg: wlanpi-hello
      version: ${{ needs.format.outputs.version }}
```

The build workflow only builds the package and uploads it as an artifact; it
does not run tests or lint. Repos wire those up as separate workflows (for
example `test-python-package.yml`, `python-lint-police.yml`, and
`python-format-police.yml`). Trigger paths differ between repos: some watch
only `debian/changelog`, others ignore docs-only changes.

Call these reusable workflows. Do not copy the `sbuild` or `package_cloud`
steps into the repository. The `~gha` timestamp some older notes mention is
part of the Actions artifact name inside `sbuild-pkg.yml`, not part of the
`.deb` version. See [Release Process](RELEASE_PROCESS.md#4-deploy-to-packagecloud).

Create `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy to Packagecloud

on:
  # Allow manual runs from the Actions tab
  workflow_dispatch:
  push:
    branches:
      - main
    paths:
      - 'debian/changelog'

jobs:
  format:
    name: Get formatted version for filename
    uses: WLAN-Pi/gh-workflows/.github/workflows/get-formatted-version-string.yml@main
  sbuild_deploy:
    name: sbuild deploy pkg
    needs:
      - format
    uses: WLAN-Pi/gh-workflows/.github/workflows/sbuild-deploy-pkg.yml@main
    with:
      pkg: wlanpi-hello
      version: ${{ needs.format.outputs.version }}
    secrets: inherit
```

The deploy workflow fires when a `debian/changelog` change reaches `main`. A
git tag on its own does not deploy. The `sbuild-deploy-pkg` reusable workflow
builds for the Debian suites in its `distros` input and uploads to the
Packagecloud `dev` repository.

## Step 9: Complete filesystem structure

After installation, the package will create:

```
/opt/wlanpi-hello/              # Application files (via dh_virtualenv)
├── bin/
│   └── wlanpi-hello           # Entry point script
├── lib/
│   └── python3.*/
│       └── site-packages/
│           └── hello/         # Python package
├── share/
│   └── python-wheels/

/etc/wlanpi-hello/             # Configuration
└── hello.conf                 # Config file

/var/log/wlanpi-hello/         # Log files
└── hello.log                  # Application logs

/usr/lib/systemd/system/       # Systemd service
└── wlanpi-hello.service
```

## Step 10: Testing on a WLAN Pi

Install and test on actual hardware:

```bash
# Copy the .deb file to your WLAN Pi
scp ../wlanpi-hello_1.0.0_arm64.deb wlanpi@your-device-ip:/tmp/

# SSH into the device
ssh wlanpi@your-device-ip

# Install the package
sudo dpkg -i /tmp/wlanpi-hello_1.0.0_arm64.deb

# Check if service is running
sudo systemctl status wlanpi-hello

# View logs
sudo journalctl -u wlanpi-hello -f

# Run manually
wlanpi-hello --message "Test message"
```

## Key decisions explained

### Why `/opt`?

WLAN Pi uses `/opt` as the installation root because:
- Applications are bundled with all dependencies via dh_virtualenv
- Avoids conflicts with system Python packages
- Simplifies application isolation and removal

### Why dh_virtualenv?

- Creates isolated Python environments per package
- Allows different apps to use different dependency versions
- Simplifies deployment - no need to manage system Python packages

### Why Systemd?

- Standard service management on modern Debian
- Built-in logging via journald
- Easy to control start/stop/restart
- Security hardening options available

## Common issues

### Issue: "command not found" after install

The binary is in `/opt/wlanpi-hello/bin/`. Either:
- Use full path: `/opt/wlanpi-hello/bin/wlanpi-hello`
- Or create a symlink in `/usr/local/bin/`

### Issue: Service fails to start

Check logs:
```bash
sudo journalctl -u wlanpi-hello -n 50
```

Common causes:
- Missing log directory permissions
- User doesn't exist
- Python errors in application

### Issue: Lintian errors

Check package for issues:
```bash
lintian ../wlanpi-hello_1.0.0_*.deb
```

`dir-or-file-in-opt` is an error. The override in
`debian/wlanpi-hello.lintian-overrides` suppresses it. With that override,
and with bytecode and pip removed in `debian/rules`, a Trixie lintian run
of this example reports one warning:
`unusual-interpreter /opt/wlanpi-hello/bin/python` on the console script.
That warning is expected. Installing the unit to `/lib/systemd/system`
instead reports `aliased-location`, also an error.

## Next steps

1. Adapt this example for your actual application
2. Add more error handling
3. Implement configuration file parsing
4. Add tests
5. Document the API/user interface

## See also

- [Architecture/FHS](architecture/FHS.md) - Filesystem standards
- [Architecture/Packaging](architecture/PACKAGING.md) - Detailed packaging policy
- [Release Process](RELEASE_PROCESS.md) - How to release your package
- [dh-virtualenv documentation](https://dh-virtualenv.readthedocs.io/)
