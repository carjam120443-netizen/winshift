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

# Ubuntu Noble mirrors. Only use mirror options supported by the Debian
# live-build version installed by the GitHub Actions workflow.
lb config \
    --distribution noble \
    --architectures amd64 \
    --archive-areas "main restricted universe multiverse" \
    --mirror-bootstrap http://archive.ubuntu.com/ubuntu \
    --mirror-chroot http://archive.ubuntu.com/ubuntu \
    --mirror-chroot-security http://security.ubuntu.com/ubuntu \
    --mirror-binary http://archive.ubuntu.com/ubuntu \
    --mirror-binary-security http://security.ubuntu.com/ubuntu \
    --linux-packages "linux-image-generic" \
    --binary-images iso-hybrid \
    --debian-installer none

lb build

ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "${ISO}" ]]; then
    echo "Error: live-build did not produce an ISO."
    exit 1
fi

mv -- "$ISO" "WinShift-0.1.0-amd64.iso"
echo "Created WinShift-0.1.0-amd64.iso"
