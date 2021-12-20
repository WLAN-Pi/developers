# Filesystem Hierarchy Structure Policy for the WLAN Pi

The context of this document is in regards the [package archives](https://packagecloud.io/wlanpi/) managed by the core WLAN Pi team, and does not consider the scope of any changes which may be required to upload packages to other package archives.

## Single File Configurations

Standalone configuration files should be placed in the `/etc` directory. Examples include `/etc/wlanpi-release` and `/etc/wlanpi-state`.

## Applications

### Naming Convention

Naming for WLAN Pi applications should include the `wlanpi-` prefix to minimize conflicts with packages from other package archives. For example, names like `chat-bot` or `profiler` are generic names which means `wlanpi-chat-bot` or `wlanpi-profiler` makes sense to avoid conflicts.

To maintain consistency on package build stamps, the `wlanpi-` prefix is required.

### dh_virtualenv

The majority of the custom applications provided by the WLAN Pi use dh_virtualenv (a debhelper wrapper providing per-package virtualenvs).

Applications should follow the following file system structure:

### /opt/{app}

The core static files for the application should be located in `/opt/{app}`. This includes non-variable and non-configuration items. Those should be placed in other locations.

There is some controversy around this.

#### Maintainer Controversy

WLAN Pi builds, packages, and maintains several Debian packages, which are included as part of the WLAN Pi image. Hence they are not "add-on" packages. "Add-on" packages are those that are not provided by WLAN Pi and added by the end user to the host running the WLAN Pi OS.

However, the team has settled on using `/opt` as the root installation directory for our applications. Note that this will cause many [dir-or-file-in-etc-opt](https://lintian.debian.org/tags/dir-or-file-in-etc-opt) errors during application build.

Note, this is subject to change in the future, especially if there is a scope increase of distributing WLAN Pi packages beyond our maintained package archive on [packagecloud](http://packagecloud.io/wlanpi/). `/opt` is likely only one of the many changes that would be required. If one was to get a package into the Debian archive, the package must follow a proper source package format that compiles with Debian policy.

#### Debian Community Controversy

See [debian bug 888549](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=888549), which is about `chrome-gnome-shell` using `/opt`. However, note that as of writing chrome-gnome-shell does not use `/opt`. And `/usr/share` is where you will likely find packages installed from Debian. To be clear, if the package is installed from the Debian package archive, it is not "add-on" software.

### /etc/{app}

Configuration files for applications must be placed in `/etc`. `/etc/{app}` is preferred. If they are placed in `/opt`, the package manager will not preserve user changes during upgrades.

### /var/log

Any logs for applications should be set up to auto-rotate and placed in `/var/log` or `/var/log/{app}`.

The same applies to variable data.

## Read More

- [Linux Foundation: Filesystem Hierarchy System 3.0](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
- [Debian Policy: 9.1.1. File System Structure](https://www.debian.org/doc/debian-policy/ch-opersys.html#file-system-structure)
- [Linux Journal Blog: Point/Counterpoint - /opt vs. /usr/local](https://www.linuxjournal.com/magazine/pointcounterpoint-opt-vs-usrlocal)
- [StackExchange: What is the difference between /opt and /usr/local?](https://unix.stackexchange.com/questions/11544/what-is-the-difference-between-opt-and-usr-local)
