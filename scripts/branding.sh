#!/usr/bin/env bash
set -euo pipefail

# Apply basic WinShift branding inside the live filesystem.
ROOTFS="${1:-config/includes.chroot}"
mkdir -p "$ROOTFS/etc"

cat > "$ROOTFS/etc/os-release" <<'EOF'
NAME="WinShift"
PRETTY_NAME="WinShift"
ID=winshift
ID_LIKE=ubuntu debian
HOME_URL="https://github.com/carjam120443-netizen/winshift"
SUPPORT_URL="https://github.com/carjam120443-netizen/winshift/issues"
EOF
