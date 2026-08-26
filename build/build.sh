#!/usr/bin/env bash
set -euo pipefail

# WinShift ISO builder
# Ubuntu Noble + modern live-build

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v lb >/dev/null 2>&1; then
    echo "Error: live-build is not installed."
    exit 1
fi

lb clean --purge

# Modern live-build does not provide the old *-updates options. The base
# Ubuntu mirror plus its normal suite handling is enough for Noble.
lb config \
    --distribution noble \
    --archive-areas "main restricted universe multiverse" \
    --mirror-bootstrap http://archive.ubuntu.com/ubuntu \
    --mirror-chroot http://archive.ubuntu.com/ubuntu \
    --mirror-chroot-security http://security.ubuntu.com/ubuntu \
    --mirror-binary http://archive.ubuntu.com/ubuntu \
    --mirror-binary-security http://security.ubuntu.com/ubuntu \
    --binary-images iso-hybrid \
    --debian-installer none

lb build

# live-build normally creates binary.iso. Rename it to a useful WinShift name.
ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "${ISO}" ]]; then
    echo "Error: live-build did not produce an ISO."
    exit 1
fi

mv -- "$ISO" "WinShift-0.1.0-amd64.iso"
echo "Created WinShift-0.1.0-amd64.iso"
