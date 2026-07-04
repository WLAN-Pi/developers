# Developers

A collection of documentation for WLAN Pi developers and contributors.

## Quick Start

**New to WLAN Pi development?** Start here:

1. [Getting Started](GETTING_STARTED.md) - Set up your environment and make your first contribution
2. [Git Workflow Guide](GIT_WORKFLOW.md) - Git fundamentals (if you're new to Git)
3. [Contributing](CONTRIBUTING.md) - Detailed workflow guidelines
4. [Packaging Example](PACKAGING_EXAMPLE.md) - Create your first package

### Install Dev Dependencies

To set up a WLAN Pi device for development (requires `curl` and `sudo`):

```bash
curl -vfSL http://wlanpi.us/install | sudo bash
```

## Documentation

### For Contributors

| Document | Description |
|----------|-------------|
| [Getting Started](GETTING_STARTED.md) | Development environment setup and first contribution guide |
| [Git Workflow Guide](GIT_WORKFLOW.md) | Git fundamentals for beginners |
| [Contributing](CONTRIBUTING.md) | Detailed Git workflow, branch naming, PR guidelines, and code review |
| [Packaging Example](PACKAGING_EXAMPLE.md) | Complete walkthrough of creating a Debian package from scratch |

### For Core Team

| Document | Description |
|----------|-------------|
| [Release Process](RELEASE_PROCESS.md) | Tagging, versioning, and deployment procedures |

### Architecture

| Document | Description |
|----------|-------------|
| [Filesystem Hierarchy](architecture/FHS.md) | Directory structure standards (`/opt`, `/etc`, `/var`) |
| [Debian Packaging](architecture/PACKAGING.md) | Packaging policy and required files |

### Style Guides

| Document | Description |
|----------|-------------|
| [Contributing Style](style/CONTRIBUTING.md) | See [CONTRIBUTING.md](CONTRIBUTING.md) |
| [Python](style/PYTHON.md) | Python coding standards |
| [Packaging Style](style/PACKAGING.md) | See [architecture/PACKAGING.md](architecture/PACKAGING.md) |
| [Anti-patterns](style/ANTIPATTERNS.md) | Common mistakes to avoid |
| [Debchange](style/DCH.md) | Changelog formatting |
| [Developer Workflow](style/WORKFLOW.md) | Development process standards |
| [Manpages](style/MANPAGES.MD) | Creating and generating manpages for WLAN Pi applications |

### Workflow

| Document | Description |
|----------|-------------|
| [Development Setup](workflow/development-setup.md) | Detailed environment setup |
| [IDE Setup](workflow/ide.md) | IDE configuration |
| [Developing on Windows](workflow/dev-on-windows.md) | Windows/WSL development guide |
| [Update from Dev Branch](workflow/update-from-dev.md) | Testing dev packages |
| [VSC Remote-SSH](workflow/VSC_64bit_kernel_and_32bit_userland.md) | VS Code troubleshooting |

### Licensing

| Document | Description |
|----------|-------------|
| [Licensing](licensing/licensing.md) | Project licensing policy (MIT) |

### Community

| Document | Description |
|----------|-------------|
| [Code of Conduct](https://github.com/WLAN-Pi/.github/blob/main/docs/code_of_conduct.md) | Community standards |

## Feedback

We welcome your feedback. Feel free to [open an issue](../../issues) with suggestions and rationale for any proposed changes.

## Resources

- [WLAN Pi Website](https://wlanpi.com)
- [Packagecloud Archive](https://packagecloud.io/wlanpi/)
- [GitHub Organization](https://github.com/wlan-pi/)
- [WLAN Pi Slack Community](https://wlanpi.slack.com)

## See Also

External resources for learning:

### Git
- [GitHub Git Guide](https://docs.github.com/en/get-started/quickstart/git-and-github-learning-resources) - Official GitHub resources
- [Oh Shit, Git!?!](https://ohshitgit.com/) - Practical Git problem solving
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/) - Deep Git internals
- [Pro Git](https://git-scm.com/book/en/v2) - Comprehensive free Git reference

### Debian packaging
- [Debian New Maintainers' Guide](https://www.debian.org/doc/manuals/maint-guide/) - Debian packaging
- [Debian Policy Manual](https://www.debian.org/doc/debian-policy/) - Authoritative Debian packaging standards
- [dh-virtualenv Documentation](https://dh-virtualenv.readthedocs.io/) - Python packaging tool

### Python
- [Python Packaging User Guide](https://packaging.python.org/en/latest/) - Modern Python packaging with pyproject.toml
- [pip-tools Documentation](https://pip-tools.readthedocs.io/) - Dependency pinning via requirements.in / requirements.txt
- [ruff Documentation](https://docs.astral.sh/ruff/) - Linter and formatter used in new WLAN Pi projects
- [pytest Documentation](https://docs.pytest.org/) - Testing framework used across WLAN Pi projects
- [FastAPI Documentation](https://fastapi.tiangolo.com/) - Web framework used in wlanpi-core
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/) - Async ORM used in wlanpi-core
- [Authlib Documentation](https://docs.authlib.org/) - OAuth and JWT library used in wlanpi-core
- [Scapy Documentation](https://scapy.readthedocs.io/) - Packet manipulation used in wlanpi-profiler and wlanpi-ctx
- [TextFSM Documentation](https://github.com/google/textfsm/wiki) - CLI output parsing used in wlanpi-fpms
- [piwheels](https://www.piwheels.org/) - Pre-built Python wheels for Raspberry Pi

### Web
- [htmx Documentation](https://htmx.org/docs/) - HTML-driven interactivity used in wlanpi-webui
- [websockets Documentation](https://websockets.readthedocs.io/) - WebSocket library used in wlanpi-core
- [MDN WebSockets API](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API) - WebSocket protocol reference

### Linux and platform
- [Linux Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html) - FHS 3.0
- [Linux Namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html) - Network namespace isolation used in wlanpi-core
- [systemd](https://www.freedesktop.org/wiki/Software/systemd/) - Service manager used by all WLAN Pi packages
- [dbus-python Documentation](https://dbus.freedesktop.org/doc/dbus-python/tutorial.html) - IPC used for Linux service communication
- [nginx Documentation](https://nginx.org/en/docs/) - Reverse proxy used by wlanpi-core
- [BlueZ Documentation](http://www.bluez.org/) - Linux Bluetooth stack used in wlanpi-bluetooth
- [lldpd](https://lldpd.github.io/) - LLDP/CDP daemon used for neighbor detection in wlanpi-common

### Raspberry Pi
- [Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/) - Hardware platform reference
- [Raspberry Pi Pinout: UART](https://pinout.xyz/pinout/uart) - UART pin reference
- [Raspberry Pi Pinout: I2C](https://pinout.xyz/pinout/i2c) - I2C pin reference

### Wireless
- [Linux Wireless Documentation](https://wireless.docs.kernel.org/en/latest/) - Kernel wireless subsystem docs
- [Linux Wireless Wiki](https://wireless.wiki.kernel.org/) - cfg80211, mac80211, nl80211 kernel subsystem docs
- [nl80211 Netlink API](https://wireless.docs.kernel.org/en/latest/en/developers/documentation/nl80211.html) - Kernel nl80211 netlink interface
- [Linux Wireless Mailing List](https://lore.kernel.org/linux-wireless/) - Upstream kernel wireless development
- [hostap Project](https://w1.fi/) - Upstream source for hostapd and wpa_supplicant
- [hostapd Documentation](https://w1.fi/hostapd/) - AP daemon used and patched in wlanpi-profiler
- [wpa_supplicant Documentation](https://w1.fi/wpa_supplicant/) - Supplicant used for station-mode connections
- [iw Documentation](https://wireless.wiki.kernel.org/en/users/documentation/iw) - Userspace nl80211 configuration tool
- [iwlwifi Documentation](https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi) - Intel wireless driver
- [ath Driver Documentation](https://wireless.wiki.kernel.org/en/users/drivers/ath) - Qualcomm/Atheros driver family
- [MediaTek mt76 Driver](https://wireless.wiki.kernel.org/en/users/drivers/mt76) - MediaTek wireless driver
- [morrownr USB WiFi](https://github.com/morrownr) - USB Wi-Fi adapter compatibility and driver reference
- [WikiDevi](https://wikidevi.wi-cat.ru/) - Wireless hardware database and NIC identification

### IEEE 802.11
- [IEEE 802.11 Working Group](https://www.ieee802.org/11/) - Standards body, drafts, and meeting documents
- [IEEE 802.11 Timelines](https://grouper.ieee.org/groups/802/11/Reports/802.11_Timelines.htm) - Amendment status and publication dates
- [IEEE GET Program](https://ieeexplore.ieee.org/browse/standards/get-program/page) - Free access to selected IEEE 802.11 standards
- [Wi-Fi Alliance](https://www.wi-fi.org/) - Certification programs and technical specifications

### Tools and utilities
- [Wireshark Wiki](https://wiki.wireshark.org/) - Packet analysis reference
- [Wireshark Source](https://gitlab.com/wireshark/wireshark) - Wireshark source code
- [tcpdump](https://www.tcpdump.org/manpages/tcpdump.1.html) - Packet capture reference
- [Kismet](https://kismetwireless.net/) - Wireless network detector and sniffer
- [Scandump](https://github.com/intuitibits/scandump) - Wireless scan dump tool
- [Grafana Documentation](https://grafana.com/docs/) - Dashboard platform used in wlanpi-grafana
- [ShellCheck](https://www.shellcheck.net/) - Shell script static analysis
- [explainshell](https://explainshell.com/) - Explain any shell command interactively
- [regexr](https://regexr.com/) - Regular expression testing and reference
- [JSONLint](https://jsonlint.com/) - JSON validator
- [Terminal Trove TUI](https://terminaltrove.com/categories/tui/) - Catalogue of TUI applications
- [tmux Wiki](https://github.com/tmux/tmux/wiki) - Terminal multiplexer
- [vim](https://github.com/vim/vim) - Text editor
