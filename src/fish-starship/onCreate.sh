#!/bin/bash
set -e

MOUNT_POINT="/mnt/fish-persistent-data"
FISH_DATA_DIR="$HOME/.local/share/fish"

# Ensure mount point has correct ownership
if [ "$(id -u)" -eq 0 ]; then
    chown "$(id -un):$(id -gn)" "$MOUNT_POINT"
fi

# If there's an existing fish data directory (not a symlink), move it aside
if [ -d "$FISH_DATA_DIR" ] && [ ! -L "$FISH_DATA_DIR" ]; then
    mv "$FISH_DATA_DIR" "${FISH_DATA_DIR}-old"
fi

# Create parent directory and symlink fish data to the persistent volume
mkdir -p "$(dirname "$FISH_DATA_DIR")"
ln -sfn "$MOUNT_POINT" "$FISH_DATA_DIR"
