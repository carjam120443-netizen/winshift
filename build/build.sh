#!/usr/bin/env bash
set -euo pipefail

# WinShift ISO builder
# Requires a Debian/Ubuntu build environment with live-build installed.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v lb >/dev/null 2>&1; then
    echo "Error: live-build is not installed."
    echo "Install it with: sudo apt install live-build"
    exit 1
fi

lb clean --purge

# Ubuntu's Noble live-build package still defaults to the obsolete
# ubuntu-oneiric Syslinux theme. Use the supported --bootloader option
# with an ISO image; this live-build version will select the supported
# bootloader path for the ISO instead of the invalid --bootloaders option.
lb config \
    --distribution noble \
    --archive-areas "main restricted universe multiverse" \
    --binary-images iso \
    --bootloader grub \
    --debian-installer false

lb build
