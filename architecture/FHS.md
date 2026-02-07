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

**Note:** Using `/opt` will cause `dir-or-file-in-etc-opt` lintian warnings. These are expected and acceptable for our use case.

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

/lib/systemd/system/           # Service files
└── wlanpi-example.service
```

## References

- [Linux Foundation: FHS 3.0](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
- [Debian Policy: File System Structure](https://www.debian.org/doc/debian-policy/ch-opersys.html#file-system-structure)
- [dh-virtualenv Documentation](https://dh-virtualenv.readthedocs.io/)
