# Workflow tips

## Releases

Each release should contain appropriate git tagging and versioning.

CI/CD will be setup and triggered by pushes to `{repo}/debian/changelog`.

So, this meaning you should have some hope that your hotfix or feature works as intended. It would be a good idea to format, lint, and test the code at this stage.

Thus, don't push changes to the `changelog` until you are ready to deploy.

## Setup development environment

In general:

1. Clone repo
1. Create virtualenv
1. Install wheel and setuptools in virtualenv
1. Install package into virtualenv with extras

```bash
git clone git@github.com:WLAN-Pi/wlanpi-app.git 
cd wlanpi-app
python3 -m venv venv && source venv/bin/activate
pip install -U pip wheel setuptools 

# normal users who do not need to run or create tests
pip install .

# developers install test depends like so
pip install .[testing]
```

## Debchange from devscripts

Create a changelog entry for a new release: `dch -i`

Describe what you changed, fixed, or enhanced.

If you were to do this initially, and create the changelog file, you can create it by browsing to the root of the repository, and running `debchange --create`. This will be already done by the time you read this.

See the [DCH](DCH.md) page for further reading.

## Versioning

Each release requires versions to be updated in __two__ locations:

1. debian changelog: `{repo}/debian/changelog` via `debchange`

2. python package: `{repo}/wlanpi_app/__version__.py` via manual update.

Please note that Python package versioning should follow PEP 440. https://www.python.org/dev/peps/pep-0440/

Please note that the Debian package versioning does not strictly align with Python versioning. 

- Debian generally follows `<DebianPackageName>_<VersionNumber>-<DebianRevisionNumber>_<DebianArchitecture>.deb`. Package format also matters. Quilt vs native have differences. Native does not allow revision numbers (`1.0.0` instead of `1.0.0-1`). [More on quilt vs native here](https://wiki.debian.org/Projects/DebSrc3.0).

## Committing

Before committing, please lint, format, and test your code. Remove trailing whitespace. Remove whitespace from blank lines. In other words, make your code neat and conform to the style of the repository you're proposing changes to.

### Linting and formatting

You can in general install `tox` and then you will be able to run `tox -e format` and `tox -e lint` to format and lint respectively. Tox should automatically handle creating the virtual environments and dependencies to run tests and format/lint code. 

Here are some of the Python tools used:

* autoflake
* black
* flake8
* isort
* mypy

However, we are moving to `ruff` to replace the functionality of these tools with one tool. One tool to rule them all?

### Testing

You can in general install `tox`, and then you will be able to run `tox` to run tests.

## Building the Debian package

From the root directory of this repository run:

```bash
dpkg-buildpackage -us -uc -b
```

Iterate until you get files in `../` for the target application.

See [PACKAGING.md](PACKAGING.md) for further reading.
