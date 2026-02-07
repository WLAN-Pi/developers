#!/bin/bash
# Build dependencies snstallation script for WLAN Pi
# Generated from control files 

set -e

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "WLAN Pi dev build dependencies installer"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""

echo "Updating package lists..."
sudo apt-get update

echo ""
echo "Installing build dependencies..."
echo ""

sudo apt-get install -y --no-install-recommends \
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
    python3-distutils \
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
