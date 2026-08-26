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
lb config --distribution noble --archive-areas "main restricted universe multiverse"
lb build
