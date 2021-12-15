# Workflow Tips

## Releases

Each release should contain appropriate git tagging and versioning.

CI/CD will be setup and triggered by pushes to `{repo}/debian/changelog`.

So, this meaning you should have some hope that your hotfix or feature works as intended. It would be a good idea to format, lint, and test the code at this stage.

Thus, you should not make changes to the `changelog` until you are ready to deploy.

## Setup development environment

1. Clone repo
2. Create virtualenv
3. Install wheel and setuptools in virtualenv
4. Install package into virtualenv with extras

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

## Debcange

Create a changelog entry for a new release: `dch -i`

Describe what you changed, fixed, or enhanced.

If you were to do this initially, and create the changelog file, you can create it by browsing to the root of the repository, and running `debchange --create`. This will be already done by the time you read this.

See [DCH](DCH.md) for further reading.

## Versioning

Each release requires versions to be updated in __two__ locations:

1. debian changelog: `{repo}/debian/changelog` via `debchange`

2. python package: `{repo}/wlanpi_app/__version__.py` via manual update.

Please note that Python package versioning should follow PEP 440. https://www.python.org/dev/peps/pep-0440/

## Committing

Before committing, please lint, format, and test your code.

### Linting and formatting

You should install depends with `pip install .[testing]` and then you will be able to run `tox -e format` and `tox -e lint` to format and lint respectively.

For reference, there are `format.sh`, `lint.sh`, and `test.sh` scripts found in `{repo}/scripts`.

Here are some of the tools used:

* autoflake
* black
* flake8
* isort
* mypy

### Testing

You should install depends with `pip install .[testing]` and then you will be able to run `tox` to run tests.

## Building the Debian Package

From the root directory of this repository run:

```bash
dpkg-buildpackage -us -uc -b
```

See [PACKAGING.md](PACKAGING.md) for further reading.
