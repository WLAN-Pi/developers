# Filesystem Hierarchy Structure (FHS) Policy

This document defines the standard filesystem layout for WLAN Pi Debian packages distributed through our [package archive](https://packagecloud.io/wlanpi/).

**Scope:** These standards apply to all packages maintained by the core WLAN Pi team. If you plan to distribute packages through other archives (e.g., official Debian), additional requirements may apply.

## Single file configurations

Standalone configuration files should be placed directly in `/etc`. Examples:

- `/etc/wlanpi-release`
- `/etc/wlanpi-state`

## Applications

### Naming convention

All WLAN Pi application packages should use the `wlanpi-` prefix to avoid conflicts with packages from other archives and to ensure consistent build stamps.

**Correct:** `wlanpi-profiler`, `wlanpi-chat-bot`  
**Incorrect:** `profiler`, `chat-bot`

This prefix is mandatory for all packages in our archive.

## Directory structure

### /opt/wlanpi-{app}

Applications are installed in `/opt/wlanpi-{app}`. This includes:

- Application binaries
- Python virtualenv (via dh_virtualenv)
- Static application files

**Rationale:** We use `/opt` because:

- Applications are bundled with dependencies via dh_virtualenv (isolated virtualenvs)
- This prevents conflicts with system Python packages
- Simplifies complete application removal
- Consistent with "add-on software" definition in FHS 3.0

**Note:** Installing under `/opt` makes lintian report `dir-or-file-in-opt`, and that tag is an error. WLAN Pi packages are add-on software, not candidates for the Debian archive, so each package ships a `debian/<package>.lintian-overrides` entry with that justification. The override is described in [Packaging](PACKAGING.md#lintian-and-opt). `dir-or-file-in-etc-opt` is a different error, for files under `/etc/opt`, and these packages do not install there.

### /etc/wlanpi-{app}

Configuration files must be placed in `/etc/wlanpi-{app}/`. 

**Why not /opt?** Package managers will not preserve user modifications to files in `/opt` during upgrades. Configuration in `/etc` is properly handled by dpkg.

Example:
```
/etc/wlanpi-profiler/
└── config.ini
```

### /var/log/wlanpi-{app}

Application logs go in `/var/log/wlanpi-{app}/` with automatic log rotation configured.

Variable data (databases, caches) should also be placed in `/var/lib/wlanpi-{app}/`.

### Shared system paths

Packages also install into shared locations when they integrate with system
services. Use the narrowest path that works and prefer a drop-in or an
app-scoped directory over editing another package's files:

- `/usr/lib/systemd/system/` for unit files. On Trixie, `/lib` is a symlink to `/usr/lib`, and lintian reports `aliased-location` (an error) for a unit installed through that alias. `dh_installsystemd` in debhelper 13.24 installs units into `/usr/lib/systemd/system`. Debhelper 13.11.4 on Bookworm still installs those units into `lib/systemd/system`, and Bookworm lintian 2.116.3 accepts that path and `usr/lib/systemd/system`. A destination written in a `.install` file is `usr/lib/systemd/system/` on both suites. `/etc/systemd/system/` remains the place for local administrator overrides, not for files shipped by the package.
- `/etc/systemd/system/<unit>.service.d/` for drop-ins to another package's units
- `/etc/sudoers.d/` for sudoers fragments
- `/etc/profile.d/` for login shell snippets
- `/usr/bin/` for small helper scripts (or `/usr/libexec/wlanpi-{app}/` for internal helpers)
- `/usr/share/` for architecture-independent data
- `/var/www/` for web assets
- `/etc/nginx/sites-enabled/` for nginx site configs (or the app-scoped
  `/etc/wlanpi-{app}/nginx/` directory that the app's own nginx instance includes)
- `/etc/cockpit/` for cockpit configuration

## Complete example

For a package named `wlanpi-example`:

```
/opt/wlanpi-example/           # Application (via dh_virtualenv)
├── bin/
│   └── wlanpi-example
├── lib/
│   └── python3.x/
│       └── site-packages/
│           └── example/

/etc/wlanpi-example/           # Configuration
└── config.ini

/var/log/wlanpi-example/       # Logs
└── example.log

/var/lib/wlanpi-example/       # Variable data
└── data.db

/usr/lib/systemd/system/       # Service files
└── wlanpi-example.service
```

## References

- [Linux Foundation: FHS 3.0](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
- [Debian Policy: File System Structure](https://www.debian.org/doc/debian-policy/ch-opersys.html#file-system-structure)
- [dh-virtualenv Documentation](https://dh-virtualenv.readthedocs.io/)
