Python Style Guide
===========

Packaging
---------

See the official [Python packaging projects guide](https://packaging.python.org/en/latest/tutorials/packaging-projects/) to get started.

New projects must use `pyproject.toml` for project metadata. Do not use `setup.py` for new packages.

If you cannot run your Python project directly as a module `python -m app`, it is not packaged correctly.

If you rely on data outside of your package, you must to handle considerations for when that data is not present when your package is run. Do not rely on hard coding paths, make them configurable.

Arguments
---------

Do not roll your own options parser. Use [argparse](https://docs.python.org/3/library/argparse.html) from the stdlib.

Python conventions
------------------

In general the rules of thumb are:

- Class names should use `UpperCamelCase`
- Constant names should be `CAPITALIZED_WITH_UNDERSCORES`
- Other names should use `lowercase_separated_by_underscores`
- Private variables/methods should start with an undescore: `_myvar`
- Some special class methods are surrounded by two underscores: `__init__`

In some cases, we break the rules.

CamelCase
---------

When using abbreviations with `CamelCase`, capitalize all the letters of the abbreviation. For example, `Dot11FT` is desired rather than `Dot11Ft`.

Python Version Guidelines
-------------------------

[Python 3.13](https://docs.python.org/3.13/) is the standard for new development. This aligns with the system Python in Debian Trixie, which is the active development target for WLAN Pi.

Bookworm (Python 3.11) may still receive bug fixes on existing packages. Bullseye (Python 3.9) is end-of-life for WLAN Pi.

Tests
-----

The Python testing framework of choice should be [pytest](https://docs.pytest.org/).

Tox for standardized testing, linting, and formatting
-----------------------------------------------------

To familiarize yourself with tox, read the [tox documentation here](https://tox.wiki/en/latest/).

Install tox:

```bash
python3 -m pip install tox 
```

You can now invoke tox in the directory where `tox.ini` resides.

These are some things you should do before submitting a PR:

To initiate testing:

```bash
tox
```

These assume your `tox.ini` support these options. See [wlanpi-profiler/tox.ini](https://github.com/WLAN-Pi/wlanpi-profiler/blob/main/tox.ini) for example.

We should lint our code. Example:

```bash
tox -e lint
```

We should format our code. Example:

```bash
tox -e format
```
