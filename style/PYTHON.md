Python Style Guide
===========

Packaging
---------

See the official [Python packaging projects guide](https://packaging.python.org/en/latest/tutorials/packaging-projects/) to get started.

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

To ensure compatibility across WLAN Pi OS environments, please adhere to the following Python version requirements in development:

- Primary Version: Use [Python 3.9](https://docs.python.org/3.9/) for all development. This aligns with the system Python version in Debian Bullseye, which relies on Python 3.9 as the default. WLAN Pi applications written in Python rely on dh-virtualenv which uses the system python version.
- Future Transition: Once we fully transition to supporting only systems based on Debian Bookworm or Trixie, which uses [Python 3.11](https://docs.python.org/3.11/) or [Python 3.13](https://docs.python.org/3.13/) as the default, we will evaluate shifting development to Python 3.11 or Python 3.13 after some time of overlap. Until that point, Python 3.9 will remain the standard version used by WLAN Pi for compatibility.

In other words, do not use Python features introduced in versions later than 3.9 until WLAN Pi is no longer supporting the Bullseye images. By maintaining this guideline, we can better ensure consistent functionality and minimize compatibility issues across supported versions of WLAN Pi OS.

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

These are some things you should before submitting a PR:

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
