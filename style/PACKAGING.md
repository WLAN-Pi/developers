# General Debian Packaging Instructions for Packages using dh-virtualenv

We're using spotify's opensurce dh-virtualenv to provide debian packaging and deployment of our Python code inside a virtualenv.

dh-virtualenv is essentially a wrapper or a set of extensions around existing debian tooling. You can find the official page [here](https://github.com/spotify/dh-virtualenv).

Our goal is to use dh-virtualenv for accomplishing things like packaging, symlinks, installing configuration files, systemd service installation, and virtualization at deployment.

## Getting Started

On your _build host_, install the build tools (these are only needed on your build host):

```bash
sudo apt-get install build-essential debhelper devscripts equivs python3-pip python3-all-dev python3-setuptools dh-virtualenv
```

Install Python depends:

```bash
python3 -m pip install mock
```

Update pip, setuptools, and install wheels:

```bash
python3 -m pip install -U pip setuptools wheel
```

This is required, otherwise the tooling will fail when tries to evaluate which tests to run.

## This will install build dependencies

```bash
sudo mk-build-deps -ri
```

## Building our project

From the root directory of this repository run:

```bash
dpkg-buildpackage -us -uc -b
```

Note that -us -uc disables signing the package with GPG. So, if you want to build, test with lintian, sign with GPG:

```bash
debuild
```

If you are found favorable by the packaging gods, you should see some output files at `../wlanpi-app` like this:

```bash
dpkg-deb: building package 'wlanpi-app-dbgsym' in '../wlanpi-app-dbgsym_0.0.1~rc1_arm64.deb'.
dpkg-deb: building package 'wlanpi-app' in '../wlanpi-app_0.0.1~rc1_arm64.deb'.
 dpkg-genbuildinfo --build=binary
 dpkg-genchanges --build=binary >../wlanpi-app_0.0.1~rc1_arm64.changes
dpkg-genchanges: info: binary-only upload (no source code included)
 dpkg-source --after-build .
dpkg-buildpackage: info: binary-only upload (no source included)
(venv) wlanpi@rbpi4b-8gb:[~/dev/wlanpi-app]: ls .. | grep wlanpi-app_
wlanpi-app_0.0.1~rc1_arm64.buildinfo
wlanpi-app_0.0.1~rc1_arm64.changes
wlanpi-app_0.0.1~rc1_arm64.deb
```

### debchange - usage

#### Create a new version entry

You can run debchange from the root of the repository as debchange will climb the directory tree until it finds a `debian/changelog` file.

```
(venv) wlanpi@rbpi4b-8gb:[~/dev/profiler]: debchange
```

#### Update an existing version entry

You should minially use `dch -i` when adding a new changelog because `-i` increases the release number and adds a changelog entry.

If you want to edit the changelog without changing the version or adding a new entry, use `-e` instead of `-i`.

### debchange - versions

On version numbers, from the Debian maintainers guide:

> One tricky case can occur when you make a local package, to experiment with the packaging before uploading the normal version to the official archive, e.g., 1.0.1-1. For smoother upgrades, it is a good idea to create a changelog entry with a version string such as 1.0.1-1~rc1. You may unclutter changelog by consolidating such local change entries into a single entry for the official package.

### debchange - environment variables

You will likely want to set the `DEBFULLNAME` and `DEBEMAIL` environment variables on your development system. Two options demonstrated:

Set per session:

```bash
(venv) wlanpi@rbpi4b-8gb:[~/dev/profiler]: export DEBFULLNAME="Josh Schmelzle"
(venv) wlanpi@rbpi4b-8gb:[~/dev/profiler]: export DEBEMAIL="Josh Schmelzle <josh@joshschmelzle.com>"
```

Set to take effect at shell login via `~/.profile`


```bash
# vim ~/.profile
# append the following:
export DEBFULLNAME="Josh Schmelzle"
export DEBEMAIL="Josh Schmelzle <josh@joshschmelzle.com>"
```

### debchange - review

For more information on debchange review the manpages by running `man debchange` from your terminal.

Additionally review the [Debian maintainers guide Chapter 8](https://www.debian.org/doc/manuals/maint-guide/update.en.html).

### lintian

There is a static analyzer we can use to check our debian package.

```bash
lintian
lintian -i
lintian -EviIL +pedantic
```

## sudo apt remove vs sudo apt purge

If we remove our package, it will leave behind the config file in `/etc`:

`sudo apt remove wlanpi-app`

If we want to clean `/etc` we should purge:

`sudo apt purge wlanpi-app`

## Debian Packaging Breakdown

- `changelog`: Contains changelog information and sets the version of the package. date must be in RFC 5322 format.
- `control`: provides dependencies, package name, and other package meta data. tols like apt uses these to build dependencies, etc.
- `copyright`: copyright information for upstream source and packaging
- `compat`: sets compatibility level for debhelper
- `rules`: this is the build recipe for make. it does the work for creating our package. it is a makefile with targets to compile and install the application, then create the .deb file.
- `wlanpi-app.service`: `dh` automatically picks up and installs this systemd service
- `wlanpi-app.triggers`: tells dpkg what packages we're interested in

### Maintainer Scripts

- `postinst` - this runs after the install and handles setting up a few things. dh_installdeb will replace this with shell code automatically.
- `postrm` - this runs and handles `remove` and `purge` args when uninstalling or purging the package. dh_installdeb will replace this with shell code automatically.

### Installing dh-virtualenv from source

Some OS repositories have packages already.

```bash
sudo apt install dh-virtualenv
```

If not available, you can build it from source:

```bash
cd ~

# Install needed packages
sudo apt-get install devscripts python3-virtualenv python3-sphinx \
                     python3-sphinx-rtd-theme git equivs
# Clone git repository
git clone https://github.com/spotify/dh-virtualenv.git
# Change into working directory
cd dh-virtualenv
# This will install build dependencies
sudo mk-build-deps -ri
# Build the *dh-virtualenv* package
dpkg-buildpackage -us -uc -b

# And finally, install it (you might have to solve some
# dependencies when doing this)
sudo dpkg -i ../dh-virtualenv_<version>.deb
```

## Read More

- [Debian Packaging Tutorial](https://www.debian.org/doc/manuals/packaging-tutorial/packaging-tutorial.en.pdf)
- [Debian Systemd Packaging](https://wiki.debian.org/Teams/pkg-systemd/Packaging)
