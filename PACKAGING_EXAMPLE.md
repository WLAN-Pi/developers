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
│   ├── compat                 # Debhelper version
│   ├── control                # Package metadata
│   ├── copyright              # License info
│   ├── wlanpi-hello.install   # File installation rules
│   ├── postinst               # Post-install script
│   ├── prerm                  # Pre-remove script
│   └── rules                  # Build instructions
├── src/                       # Application source
│   └── hello/
│       ├── __init__.py
│       └── main.py
├── config/                    # Configuration files
│   └── hello.conf
├── systemd/                   # Systemd service files
│   └── wlanpi-hello.service
├── tests/                     # Test files
│   └── test_hello.py
├── requirements.txt           # Python dependencies
├── setup.py                   # Python package setup
├── README.md                  # Project documentation
└── .github/
    └── workflows/             # CI/CD workflows
        ├── build.yml
        └── deploy.yml
```

## Step 1: Application code

Create the Python application in `src/hello/main.py`:

```python
#!/usr/bin/env python3
"""
WLAN Pi hello world - A simple example
"""

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

Create `src/hello/__init__.py`:

```python
"""WLAN Pi Hello package"""
__version__ = "1.0.0"
```

## Step 2: Python package setup

Create `setup.py`:

```python
from setuptools import setup, find_packages

setup(
    name="wlanpi-hello",
    version="1.0.0",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    entry_points={
        "console_scripts": [
            "wlanpi-hello=hello.main:main",
        ],
    },
    install_requires=[
        # Add production dependencies here
    ],
    extras_require={
        "test": [
            "pytest>=7.0.0",
            "pytest-cov>=4.0.0",
        ],
    },
    python_requires=">=3.7",
)
```

Alternatively, use modern `pyproject.toml`:

```toml
[build-system]
requires = ["setuptools>=45", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "wlanpi-hello"
version = "1.0.0"
description = "WLAN Pi Hello example application"
readme = "README.md"
license = {text = "MIT"}
requires-python = ">=3.9"
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: System Administrators",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
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

Create `requirements.txt`:

```
# Production dependencies
# Add any non-standard library packages here

# Development dependencies
pytest>=7.0.0
pytest-cov>=4.0.0
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

Create `systemd/wlanpi-hello.service`:

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
Standards-Version: 4.6.0
Homepage: https://github.com/wlan-pi/wlanpi-hello

Package: wlanpi-hello
Architecture: all
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

### debian/compat

```
13
```

### debian/copyright

```
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: wlanpi-hello
Source: https://github.com/wlan-pi/wlanpi-hello

Files: *
Copyright: 2026 Your Name <you@example.com>
License: MIT

License: MIT
 Permission is hereby granted, free of charge, to any person obtaining a
 copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 .
 The above copyright notice and this permission notice shall be included
 in all copies or substantial portions of the Software.
 .
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

### debian/rules

```makefile
#!/usr/bin/make -f

export DH_VIRTUALENV_INSTALL_ROOT=/opt

%:
	dh $@ --with python-virtualenv

override_dh_virtualenv:
	dh_virtualenv \
		--python python3 \
		--install-suffix wlanpi-hello

override_dh_installsystemd:
	dh_installsystemd --name=wlanpi-hello
```

Make it executable:

```bash
chmod +x debian/rules
```

### debian/wlanpi-hello.install

```
config/hello.conf etc/wlanpi-hello/
systemd/wlanpi-hello.service lib/systemd/system/
```

### debian/postinst

```bash
#!/bin/bash
set -e

case "$1" in
    configure)
        # Create log directory
        mkdir -p /var/log/wlanpi-hello
        chown wlanpi:wlanpi /var/log/wlanpi-hello
        
        # Create user if doesn't exist
        if ! id -u wlanpi > /dev/null 2>&1; then
            useradd -r -s /bin/false wlanpi
        fi
        
        # Enable and start service
        deb-systemd-helper enable wlanpi-hello.service
        deb-systemd-helper start wlanpi-hello.service
        ;;
esac

#DEBHELPER#

exit 0
```

Make it executable:

```bash
chmod +x debian/postinst
```

### debian/prerm

```bash
#!/bin/bash
set -e

case "$1" in
    remove|upgrade|deconfigure)
        deb-systemd-helper stop wlanpi-hello.service
        deb-systemd-helper disable wlanpi-hello.service
        ;;
esac

#DEBHELPER#

exit 0
```

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

import pytest

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
# Install test dependencies
pip install -r requirements.txt

# Install package editable
pip install -e .

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

You should see `wlanpi-hello_1.0.0-1_all.deb` in the parent directory.

## Step 8: GitHub actions workflows

Create `.github/workflows/build.yml`:

```yaml
name: Build and Archive

on:
  pull_request:
    paths:
      - 'debian/changelog'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y build-essential debhelper dh-virtualenv python3-venv
          pip install -r requirements.txt

      - name: Run tests
        run: pytest -v

      - name: Build package
        run: dpkg-buildpackage -us -uc -b

      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: wlanpi-hello
          path: ../wlanpi-hello_*.deb
```

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Packagecloud

on:
  push:
    tags:
      - 'v*.*.*'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y build-essential debhelper dh-virtualenv python3-venv
      
      - name: Build package
        run: dpkg-buildpackage -us -uc -b
      
      - name: Deploy to Packagecloud
        uses: wlan-pi/sbuild-debian-package@main
        with:
          repo: wlanpi/dev
          packagecloud_token: ${{ secrets.PACKAGECLOUD_TOKEN }}
```

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

/lib/systemd/system/           # Systemd service
└── wlanpi-hello.service
```

## Step 10: Testing on a WLAN Pi

Install and test on actual hardware:

```bash
# Copy the .deb file to your WLAN Pi
scp ../wlanpi-hello_1.0.0-1_all.deb wlanpi@your-device-ip:/tmp/

# SSH into the device
ssh wlanpi@your-device-ip

# Install the package
sudo dpkg -i /tmp/wlanpi-hello_1.0.0-1_all.deb

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
lintian ../wlanpi-hello_1.0.0-1_all.deb
```

Many `/opt` related warnings are expected and can be overridden.

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
