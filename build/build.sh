#!/usr/bin/env bash
set -euo pipefail

# WinShift ISO builder
# Ubuntu Noble + live-build

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v lb >/dev/null 2>&1; then
    echo "Error: live-build is not installed."
    echo "Install it with: sudo apt install live-build"
    exit 1
fi

# Ubuntu Noble ships an older live-build whose Ubuntu/Syslinux defaults
# reference removed Oneiric theme packages. Use a minimal binary ISO and
# disable both legacy Syslinux and GRUB so live-build can build the image
# without pulling those obsolete theme packages.
lb clean --purge

lb config \
    --distribution noble \
    --archive-areas "main restricted universe multiverse" \
    --binary-images iso \
    --bootloader none \
    --debian-installer false

lb build
