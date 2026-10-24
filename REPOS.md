# Repository Reference

`REPOS.md` is a stable map of the WLAN Pi repositories. It records the default
branch, the package name, and how each repo builds and releases. Current
versions are in each repo's `debian/changelog` and on its GitHub Releases
page, `https://github.com/WLAN-Pi/<repo>/releases`.

Target rules live in [Contributing](CONTRIBUTING.md),
[Architecture/Packaging](architecture/PACKAGING.md),
[Style/Python](style/PYTHON.md), and
[Style/README Standards](style/README_STANDARDS.md).

Shared build and release workflows live in
[`gh-workflows`](https://github.com/WLAN-Pi/gh-workflows). The `tag-release`
column says whether `deploy-to-packagecloud.yml` on the default branch calls
[`tag-release.yml`](https://github.com/WLAN-Pi/gh-workflows/blob/main/.github/workflows/tag-release.yml).
`yes` means it does. `no` means that deploy workflow exists and does not call
it. `n/a` means the repo has no `deploy-to-packagecloud.yml`.

## Applications

| Repository | Purpose | Default branch | Package | Build and release | tag-release |
|------------|---------|----------------|---------|-------------------|-------------|
| [`scandump`](https://github.com/WLAN-Pi/scandump) | Scans for Wi-Fi networks with the 802.11 netlink API and writes PCAP | `main` | `scandump` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |
| [`wlanpi-bluetooth`](https://github.com/WLAN-Pi/wlanpi-bluetooth) | Enables Bluetooth management access to the WLAN Pi | `main` | `wlanpi-bluetooth` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action. Deploy calls `tag-release` | yes |
| [`wlanpi-common`](https://github.com/WLAN-Pi/wlanpi-common) | Common scripts and files for WLAN Pi RPi and CM4 hardware | `main` | `wlanpi-common` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |
| [`wlanpi-core`](https://github.com/WLAN-Pi/wlanpi-core) | Shares data between core services and applications on the WLAN Pi | `main` | `wlanpi-core` | Build calls `get-formatted-version-string` and `sbuild-pkg`. Deploy calls `check-py-deb-pkg-versions-match`, `get-formatted-version-string`, `sbuild-deploy-pkg`, and `tag-release` | yes |
| [`wlanpi-ctx`](https://github.com/WLAN-Pi/wlanpi-ctx) | Wi-Fi continuous transmitter testing tool | `main` | `wlanpi-ctx` | Build calls `get-formatted-version-string` and `sbuild-pkg`. Deploy calls `check-py-deb-pkg-versions-match`, `get-formatted-version-string`, and `sbuild-deploy-pkg` | no |
| [`wlanpi-desktop`](https://github.com/WLAN-Pi/wlanpi-desktop) | Desktop environment configuration for WLAN Pi | `main` | `wlanpi-desktop` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |
| [`wlanpi-fpms`](https://github.com/WLAN-Pi/wlanpi-fpms) | Front Panel Menu System for WLAN Pi RPi and CM4 hardware | `main` | `wlanpi-fpms` | Build calls the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action. Deploy calls that action, `check-py-deb-pkg-versions-match`, and `tag-release` | yes |
| [`wlanpi-grafana`](https://github.com/WLAN-Pi/wlanpi-grafana) | Grafana dashboards | `main` | `wlanpi-grafana` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |
| [`wlanpi-hotspot`](https://github.com/WLAN-Pi/wlanpi-hotspot) | Hotspot mode for the WLAN Pi RPi/CM4 hardware | `main` | `wlanpi-hotspot` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |
| [`wlanpi-hwtest`](https://github.com/WLAN-Pi/wlanpi-hwtest) | Drives a suite of tests for diagnostic health of WLAN Pi Pro hardware | `main` | `wlanpi-hwtest` | Build calls `get-formatted-version-string` and `sbuild-pkg`. Deploy calls `check-py-deb-pkg-versions-match`, `get-formatted-version-string`, and `sbuild-deploy-pkg` | no |
| [`wlanpi-librespeed-cli`](https://github.com/WLAN-Pi/wlanpi-librespeed-cli) | librespeed-cli tool packaged by the WLAN Pi team | `main` | `wlanpi-librespeed-cli` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action. Deploy calls `tag-release` | yes |
| [`wlanpi-mcp`](https://github.com/WLAN-Pi/wlanpi-mcp) | On-device MCP server for the WLAN Pi | `main` | `wlanpi-mcp` | Build calls `get-formatted-version-string` and `sbuild-pkg`. Deploy calls `check-py-deb-pkg-versions-match`, `get-formatted-version-string`, `sbuild-deploy-pkg`, and `tag-release` | yes |
| [`wlanpi-misc-firmware`](https://github.com/WLAN-Pi/wlanpi-misc-firmware) | Packages miscellaneous firmware files, such as MediaTek | `main` | `wlanpi-misc-firmware` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |
| [`wlanpi-persistent-identity`](https://github.com/WLAN-Pi/wlanpi-persistent-identity) | Prevents "host identification changed" SSH warnings across A/B partition switches | `main` | `wlanpi-persistent-identity` | `build-deb.yml` runs `dpkg-buildpackage`. Deploy calls the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |
| [`wlanpi-profiler`](https://github.com/WLAN-Pi/wlanpi-profiler) | Wi-Fi client capabilities analyzer for the WLAN Pi | `main` | `wlanpi-profiler` | Build calls `get-formatted-version-string` and `sbuild-pkg`. Deploy calls `check-py-deb-pkg-versions-match`, `get-formatted-version-string`, and `sbuild-deploy-pkg` | no |
| [`wlanpi-shell-config`](https://github.com/WLAN-Pi/wlanpi-shell-config) | Shell configuration and environment defaults for WLAN Pi | `main` | `wlanpi-shell-config` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |
| [`wlanpi-usb-ethernet`](https://github.com/WLAN-Pi/wlanpi-usb-ethernet) | Debian package that installs the USB ethernet gadget | `main` | `wlanpi-usb-ethernet` | `build-and-archive-debian-package.yml` runs `dpkg-buildpackage`. Deploy calls the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |
| [`wlanpi-webui`](https://github.com/WLAN-Pi/wlanpi-webui) | Web app for the WLAN Pi | `main` | `wlanpi-webui` | Build calls the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action. Deploy calls that action and `check-py-deb-pkg-versions-match` | no |
| [`wlanpi-wipry`](https://github.com/WLAN-Pi/wlanpi-wipry) | Dumps spectral data from an Oscium WiPry Clarity spectrum analyzer | `main` | `wlanpi-wipry` | Build and deploy call the [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) action | no |

## Platform and build

| Repository | Purpose | Default branch | Package | Build and release | tag-release |
|------------|---------|----------------|---------|-------------------|-------------|
| [`wlanpi-kernel`](https://github.com/WLAN-Pi/wlanpi-kernel) | Syncs and builds the kernel for WLAN Pi | `7.3-trixie` | `wlanpi-kernel-$DEBIAN_RELEASE`, `wlanpi-kernel-$DEBIAN_RELEASE-v8`, `wlanpi-kernel-$DEBIAN_RELEASE-2712`, `wlanpi-kernel-headers-$DEBIAN_RELEASE-v8`, `wlanpi-kernel-headers-$DEBIAN_RELEASE-2712` | `build-and-archive-kernel-package.yml` builds those packages and can upload them to `wlanpi/dev`. It does not call the shared `sbuild` workflows | n/a |
| [`wlanpi-misc-packages`](https://github.com/WLAN-Pi/wlanpi-misc-packages) | Packages miscellaneous binaries, such as iwlwifi and iw | `main` | `hostapd`, `iperf`, `iperf3`, `iw`, `wavemon`, `wlanpi-linux-firmware`, `wpasupplicant` | `build-packages.yml` builds those packages and pushes them to `wlanpi/dev`. It does not call the shared `sbuild` workflows | n/a |
| [`pi-gen`](https://github.com/WLAN-Pi/pi-gen) | WLAN Pi OS image build tool for RPi based hardware | `trixie64` | none (OS image) | `build.yml` runs on `workflow_dispatch`, builds the image, and publishes a GitHub release with `gh release create`. It does not call the shared `sbuild` workflows or `tag-release` | n/a |
| [`pi-gen-bookworm`](https://github.com/WLAN-Pi/pi-gen-bookworm) | Builds the WLAN Pi image using Debian Bookworm | `bookworm` | none (OS image) | `build.yml` runs on `workflow_dispatch`, builds the image, and publishes a GitHub release with `gh release create`. It does not call the shared `sbuild` workflows or `tag-release` | n/a |

## Tooling

| Repository | Purpose | Default branch | Package | Build and release | tag-release |
|------------|---------|----------------|---------|-------------------|-------------|
| [`gh-workflows`](https://github.com/WLAN-Pi/gh-workflows) | Reusable workflows for GitHub Actions used by WLAN Pi CI | `main` | none | Workflow files on `main`: `check-py-deb-pkg-versions-match.yml`, `get-formatted-version-string.yml`, `lint.yml`, `pr-size.yml`, `sbuild-deploy-pkg.yml`, `sbuild-pkg.yml`, `tag-release.yml`. `sbuild-deploy-pkg` uploads a caller's package to `wlanpi/dev` | n/a |
| [`sbuild-debian-package`](https://github.com/WLAN-Pi/sbuild-debian-package) | Builds a Debian package using sbuild | `main` | none | Composite action (`action.yml`). No workflow in this repo | n/a |
| [`.github`](https://github.com/WLAN-Pi/.github) | Community health files for the WLAN-Pi org | `main` | none | No package build and no workflows | n/a |

## Packagecloud promotion

Promotion from Packagecloud `wlanpi/dev` to `wlanpi/main` is a manual step.
The maintainer does it after testing. Shared `sbuild-deploy-pkg` uploads to
`wlanpi/dev` only (`wlanpi/dev/debian/<distro>`, or
`wlanpi/dev/raspbian/<distro>` for `armhf`).

[`wlanpi-desktop`](https://github.com/WLAN-Pi/wlanpi-desktop) has
[`promote-to-main.yml`](https://github.com/WLAN-Pi/wlanpi-desktop/blob/main/.github/workflows/promote-to-main.yml).
That workflow runs on `workflow_dispatch`. It builds the package and pushes
the `.deb` to `wlanpi/main`.

## Retired

[`wlanpi-bridge`](https://github.com/WLAN-Pi/wlanpi-bridge),
[`wlanpi-server`](https://github.com/WLAN-Pi/wlanpi-server), and
[`wlanpi-wconsole`](https://github.com/WLAN-Pi/wlanpi-wconsole) are archived.
They are off Packagecloud for trixie, on both `wlanpi/dev` and `wlanpi/main`,
and `trixie64` images do not install them. That removal is recorded in
[wlanpi-common#111](https://github.com/WLAN-Pi/wlanpi-common/issues/111).
[pi-gen#108](https://github.com/WLAN-Pi/pi-gen/issues/108) records the same
removal for `wlanpi-server`.

[`wlanpi-chat-bot`](https://github.com/WLAN-Pi/wlanpi-chat-bot) is archived.
