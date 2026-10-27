# Repository Reference

`REPOS.md` says what each WLAN Pi repository should be. When a repository
differs, that is drift to fix in that repository, or a deliberate change to
the standard here.

Current versions are in each repo's `debian/changelog` and on its GitHub
Releases page, `https://github.com/WLAN-Pi/<repo>/releases`.

## Standards

An application deploy workflow should call the shared workflows in
[`gh-workflows`](https://github.com/WLAN-Pi/gh-workflows): `sbuild-pkg`,
`sbuild-deploy-pkg`, and `tag-release`.

CI builds and tests Debian Trixie packages, plus compiler builds and tests.

A `debian/changelog` push to `main` uploads to Packagecloud `wlanpi/dev`.
Promotion to `wlanpi/main` is done by hand. An upload to `wlanpi/main` when
the release pull request merges, and an automatic tag, are planned. See
[What Is Live](RELEASING.md#what-is-live).

`pi-gen` and `wlanpi-kernel` follow their own release rules. See
[Scope](RELEASING.md#scope).

## Applications

| Repository | Purpose | Default branch | Package | Note |
|------------|---------|----------------|---------|------|
| [`scandump`](https://github.com/WLAN-Pi/scandump) | Scans for Wi-Fi networks with the 802.11 netlink API and writes PCAP | `main` | `scandump` | Fork of [`intuitibits/scandump`](https://github.com/intuitibits/scandump). Version as `<upstream>+wlanpi<N>`. |
| [`wlanpi-bluetooth`](https://github.com/WLAN-Pi/wlanpi-bluetooth) | Enables Bluetooth management access to the WLAN Pi | `main` | `wlanpi-bluetooth` | |
| [`wlanpi-common`](https://github.com/WLAN-Pi/wlanpi-common) | Common scripts and files for WLAN Pi RPi and CM4 hardware | `main` | `wlanpi-common` | |
| [`wlanpi-core`](https://github.com/WLAN-Pi/wlanpi-core) | Shares data between core services and applications on the WLAN Pi | `main` | `wlanpi-core` | Repo-specific build and test rules belong in this repo's own `AGENTS.md`. |
| [`wlanpi-ctx`](https://github.com/WLAN-Pi/wlanpi-ctx) | Wi-Fi continuous transmitter testing tool | `main` | `wlanpi-ctx` | |
| [`wlanpi-desktop`](https://github.com/WLAN-Pi/wlanpi-desktop) | Desktop environment configuration for WLAN Pi | `main` | `wlanpi-desktop` | Optional apt package; install it when you need the desktop. |
| [`wlanpi-fpms`](https://github.com/WLAN-Pi/wlanpi-fpms) | Front Panel Menu System for WLAN Pi RPi and CM4 hardware | `main` | `wlanpi-fpms` | |
| [`wlanpi-grafana`](https://github.com/WLAN-Pi/wlanpi-grafana) | Grafana dashboards | `main` | `wlanpi-grafana` | |
| [`wlanpi-hotspot`](https://github.com/WLAN-Pi/wlanpi-hotspot) | Hotspot mode for the WLAN Pi RPi/CM4 hardware | `main` | `wlanpi-hotspot` | |
| [`wlanpi-hwtest`](https://github.com/WLAN-Pi/wlanpi-hwtest) | Drives a suite of tests for diagnostic health of WLAN Pi Pro hardware | `main` | `wlanpi-hwtest` | |
| [`wlanpi-librespeed-cli`](https://github.com/WLAN-Pi/wlanpi-librespeed-cli) | librespeed-cli tool packaged by the WLAN Pi team | `main` | `wlanpi-librespeed-cli` | |
| [`wlanpi-mcp`](https://github.com/WLAN-Pi/wlanpi-mcp) | On-device MCP server for the WLAN Pi | `main` | `wlanpi-mcp` | |
| [`wlanpi-misc-firmware`](https://github.com/WLAN-Pi/wlanpi-misc-firmware) | Packages miscellaneous firmware files, such as MediaTek | `main` | `wlanpi-misc-firmware` | |
| [`wlanpi-persistent-identity`](https://github.com/WLAN-Pi/wlanpi-persistent-identity) | Prevents "host identification changed" SSH warnings across A/B partition switches | `main` | `wlanpi-persistent-identity` | |
| [`wlanpi-profiler`](https://github.com/WLAN-Pi/wlanpi-profiler) | Wi-Fi client capabilities analyzer for the WLAN Pi | `main` | `wlanpi-profiler` | |
| [`wlanpi-shell-config`](https://github.com/WLAN-Pi/wlanpi-shell-config) | Shell configuration and environment defaults for WLAN Pi | `main` | `wlanpi-shell-config` | |
| [`wlanpi-usb-ethernet`](https://github.com/WLAN-Pi/wlanpi-usb-ethernet) | Debian package that installs the USB ethernet gadget | `main` | `wlanpi-usb-ethernet` | |
| [`wlanpi-webui`](https://github.com/WLAN-Pi/wlanpi-webui) | Web app for the WLAN Pi | `main` | `wlanpi-webui` | |
| [`wlanpi-wipry`](https://github.com/WLAN-Pi/wlanpi-wipry) | Dumps spectral data from an Oscium WiPry Clarity spectrum analyzer | `main` | `wlanpi-wipry` | |

## Platform and build

| Repository | Purpose | Default branch | Package | Note |
|------------|---------|----------------|---------|------|
| [`wlanpi-kernel`](https://github.com/WLAN-Pi/wlanpi-kernel) | Syncs and builds the kernel for WLAN Pi | `7.3-trixie` | `wlanpi-kernel`, `wlanpi-kernel-headers` | Own release rules. See [Scope](RELEASING.md#scope). |
| [`wlanpi-misc-packages`](https://github.com/WLAN-Pi/wlanpi-misc-packages) | Packages miscellaneous binaries, such as iwlwifi and iw | `main` | `hostapd`, `iperf`, `iperf3`, `iw`, `wavemon`, `wlanpi-linux-firmware`, `wpasupplicant` | |
| [`pi-gen`](https://github.com/WLAN-Pi/pi-gen) | WLAN Pi OS image build tool for RPi based hardware | `trixie64` | none (OS image) | Fork of [`RPi-Distro/pi-gen`](https://github.com/RPi-Distro/pi-gen). Own release rules. New image work belongs here. |

WLAN Pi Go is BE200-only. It ships every `iwlwifi-gl-c0-fm-c0-*` ucode file
plus `pnvm`. The user sets the regulatory domain.

## Tooling

| Repository | Purpose | Default branch | Package | Note |
|------------|---------|----------------|---------|------|
| [`developers`](https://github.com/WLAN-Pi/developers) | Guidance for WLAN Pi developers including style guides, architecture, git, testing, and more | `main` | none | This repository. |
| [`gh-workflows`](https://github.com/WLAN-Pi/gh-workflows) | Reusable workflows for GitHub Actions used by WLAN Pi CI | `main` | none | Application deploys should call `sbuild-pkg`, `sbuild-deploy-pkg`, and `tag-release`. |
| [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) | Builds a Debian package using sbuild | `main` | none | Fork of [`danielmundi/sbuild-debian-package`](https://github.com/danielmundi/sbuild-debian-package). |
| [`.github`](https://github.com/WLAN-Pi/.github) | Community health files for the WLAN-Pi org | `main` | none | |

## Legacy

[`pi-gen-bookworm`](https://github.com/WLAN-Pi/pi-gen-bookworm) builds the
WLAN Pi image using Debian Bookworm. Default branch `bookworm`. New image
work belongs in [`pi-gen`](https://github.com/WLAN-Pi/pi-gen).

## Legacy candidates

| Repository | Default branch | Note |
|------------|----------------|------|
| [`feedback`](https://github.com/WLAN-Pi/feedback) | `main` | Public feedback discussions for WLAN Pi, our software, and more |
| [`experimental`](https://github.com/WLAN-Pi/experimental) | `main` | |
| [`drivers`](https://github.com/WLAN-Pi/drivers) | `main` | Drivers that can be used for the WLAN Pi such as RNDIS |
| [`neo2`](https://github.com/WLAN-Pi/neo2) | `master` | WLAN Pi release repository |
| [`build`](https://github.com/WLAN-Pi/build) | `main` | Image build tool for WLAN Pi NEO2 hardware running Armbian. Fork of [`danielmundi/build`](https://github.com/danielmundi/build). |
| [`armbian-build`](https://github.com/WLAN-Pi/armbian-build) | `wlanpi-neo2-6e` | Armbian Linux build framework. Fork of [`adriangranados/build`](https://github.com/adriangranados/build). |
| [`rpi-linux`](https://github.com/WLAN-Pi/rpi-linux) | `rpi-5.14.y` | Kernel source tree for Raspberry Pi Foundation-provided kernel builds. Fork of [`raspberrypi/linux`](https://github.com/raspberrypi/linux). |
| [`pidcodes.github.com`](https://github.com/WLAN-Pi/pidcodes.github.com) | `master` | Website for pid.codes. Fork of [`pidcodes/pidcodes.github.com`](https://github.com/pidcodes/pidcodes.github.com). |

## Retired

[`wlanpi-bridge`](https://github.com/WLAN-Pi/wlanpi-bridge),
[`wlanpi-server`](https://github.com/WLAN-Pi/wlanpi-server),
[`wlanpi-wconsole`](https://github.com/WLAN-Pi/wlanpi-wconsole), and
[`wlanpi-chat-bot`](https://github.com/WLAN-Pi/wlanpi-chat-bot) are archived.
