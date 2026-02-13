#!/bin/bash
set -e

MOUNT_POINT="/mnt/fish-persistent-data"
FISH_DATA_DIR="${_REMOTE_USER_HOME}/.local/share/fish"

run_as_user() {
    if [ "$(id -u)" -eq 0 ] && [ "$(id -u "${_REMOTE_USER}")" -ne 0 ]; then
        sudo -u "${_REMOTE_USER}" "$@"
    else
        "$@"
    fi
}

# Ensure mount point has correct ownership
chown "${_REMOTE_USER}:${_REMOTE_USER}" "$MOUNT_POINT"

# If there's an existing fish data directory (not a symlink), move it aside
if [ -d "$FISH_DATA_DIR" ] && [ ! -L "$FISH_DATA_DIR" ]; then
    mv "$FISH_DATA_DIR" "${FISH_DATA_DIR}-old"
fi

# Create parent directory and symlink fish data to the persistent volume
mkdir -p "$(dirname "$FISH_DATA_DIR")"
run_as_user ln -sfn "$MOUNT_POINT" "$FISH_DATA_DIR"

chown -R "${_REMOTE_USER}:${_REMOTE_USER}" "$(dirname "$FISH_DATA_DIR")"
