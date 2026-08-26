#!/usr/bin/env bash
set -euo pipefail

# WinShift ISO builder
# Ubuntu Noble + live-build

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v lb >/dev/null 2>&1; then
    echo "Error: live-build is not installed."
    exit 1
fi

lb clean --purge

# Build a bootable Ubuntu Noble hybrid ISO using live-build's supported
# default bootloader path. The earlier --bootloader none setting was only
# useful as a diagnostic because it cannot produce a bootable ISO.
lb config \
    --distribution noble \
    --archive-areas "main restricted universe multiverse" \
    --binary-images iso-hybrid \
    --debian-installer false

lb build

# live-build normally creates binary.iso. Rename it to a useful WinShift name.
ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "${ISO}" ]]; then
    echo "Error: live-build did not produce an ISO."
    exit 1
fi

mv -- "$ISO" "WinShift-0.1.0-amd64.iso"
echo "Created WinShift-0.1.0-amd64.iso"
