# Development Setup

This guide walks through setting up a local development environment for a WLAN Pi Python package. The example uses `wlanpi-fpms`, but the steps apply to any WLAN Pi Python repo.

## System requirements

Some packages have hardware requirements. For `wlanpi-fpms`, the SPI interface must be enabled on the target device for the display to work.

Enable SPI via `raspi-config`:

```bash
sudo raspi-config
```

Or by editing `/boot/firmware/config.txt` directly and adding:

```
dtparam=spi=on
```

## Initial setup

These steps only need to be done once per environment.

1. Clone the repo:

```bash
git clone git@github.com:WLAN-Pi/wlanpi-fpms.git && cd wlanpi-fpms
```

2. Create a virtualenv:

```bash
python3 -m venv venv
```

3. Activate it:

```bash
source venv/bin/activate
```

4. Update pip and install build tools:

```bash
pip install -U pip setuptools wheel pip-tools
```

5. Install the package with test dependencies:

```bash
pip install -e .[testing]
```

The `testing` extras bring in tools like tox, pytest, ruff, and mypy.

## Running the module

WLAN Pi packages are structured as Python modules and should be run with `-m`:

1. Stop the running service if the package is already installed on the device:

```bash
sudo systemctl stop wlanpi-fpms
sudo systemctl status wlanpi-fpms
```

2. Run using the virtualenv's interpreter (some packages require root):

```bash
sudo venv/bin/python3 -m fpms
```

For keyboard-interactive mode (enables display screenshots with `g`):

```bash
sudo venv/bin/python3 -m fpms -e
```

Further reading on executing Python modules: <https://docs.python.org/3/library/runpy.html>

## Running tests

```bash
tox
```

Or directly with pytest:

```bash
pytest
```

## Cheatsheet

New environment:

```bash
git clone git@github.com:WLAN-Pi/wlanpi-fpms.git && cd wlanpi-fpms
python3 -m venv venv
source venv/bin/activate
pip install -U pip setuptools wheel pip-tools
pip install -e .[testing]
sudo systemctl stop wlanpi-fpms
sudo venv/bin/python3 -m fpms
```

Returning to an existing environment:

```bash
cd wlanpi-fpms
source venv/bin/activate
sudo systemctl stop wlanpi-fpms
sudo venv/bin/python3 -m fpms
```
