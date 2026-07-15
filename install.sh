#!/bin/bash
# Build dependencies installation script for WLAN Pi
# Generated from control files

set -euo pipefail

# Report where and why we failed instead of dying with a bare apt error, and
# propagate the real exit code so callers (and CI) can act on it.
# shellcheck disable=SC2329  # invoked indirectly via the ERR trap below
on_error() {
    local rc=$?
    local line=$1
    echo >&2
    echo "ERROR: install.sh failed on line ${line} (exit code ${rc})." >&2
    exit "${rc}"
}
trap 'on_error "${LINENO}"' ERR

# Preflight: this installer targets Debian and drives apt-get via sudo.
if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: apt-get not found. This installer targets Debian-based systems." >&2
    exit 1
fi
if [ "$(id -u)" -ne 0 ] && ! command -v sudo >/dev/null 2>&1; then
    echo "ERROR: this script needs root privileges but neither root nor sudo is available." >&2
    exit 1
fi

# Run a command as root: directly if we already are, otherwise via sudo.
if [ "$(id -u)" -eq 0 ]; then
    as_root() { "$@"; }
else
    as_root() { sudo "$@"; }
fi

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "WLAN Pi dev build dependencies installer"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""

echo "Updating package lists..."
as_root apt-get update

echo ""
echo "Installing build dependencies..."
echo ""

as_root apt-get install -y --no-install-recommends \
    debhelper \
    debhelper-compat \
    dh-python \
    dh-virtualenv \
    build-essential \
    devscripts \
    sbuild \
    schroot \
    debootstrap \
    ca-certificates \
    quilt \
    autotools-dev \
    autoconf \
    pkg-config \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-venv \
    python3-tk \
    python3-gi \
    gcc-aarch64-linux-gnu \
    gcc-arm-linux-gnueabihf \
    bc \
    flex \
    bison \
    rsync \
    tar \
    libtiff5-dev \
    libopenjp2-7-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev \
    tcl8.6-dev \
    tk8.6-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libxcb1-dev \
    dbus \
    libdbus-1-dev \
    libdbus-glib-1-dev \
    libglib2.0-dev \
    libcairo2-dev \
    libgirepository1.0-dev \
    libffi-dev \
    libnl-3-dev \
    libnl-genl-3-dev \
    libnl-route-3-dev \
    libnl-cli-3-200 \
    libssl-dev \
    libpcsclite-dev \
    libreadline-dev \
    git \
    vim \
    parted \
    qemu-user-static \
    binfmt-support \
    zerofree \
    zip \
    dosfstools \
    libarchive-tools \
    libcap2-bin \
    udev \
    xz-utils \
    curl \
    file \
    kmod \
    fdisk \
    gpg \
    pigz \
    arch-test \
    qemu-utils \
    kpartx \
    coreutils

echo ""
echo "~~~~"
echo "Done"
echo "~~~~"
echo ""

exit 0
