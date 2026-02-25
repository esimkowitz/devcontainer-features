#!/bin/bash
set -e

# Feature options (passed as environment variables by devcontainer)
PERSIST_CLAUDE_DIR="${PERSISTCLAUDEDIR:-true}"
PERSIST_CLAUDE_JSON="${PERSISTCLAUDEJSON:-false}"

# Mount points
MOUNT_CLAUDE_DIR="/mnt/claude-dir"
MOUNT_CLAUDE_JSON="/mnt/claude-json"

# User paths
USER_HOME="${_REMOTE_USER_HOME:-$HOME}"
USER_NAME="${_REMOTE_USER:-$(whoami)}"
CLAUDE_DIR="$USER_HOME/.claude"
CLAUDE_JSON="$USER_HOME/.claude.json"

# Helper: conditional sudo
maybe_sudo() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    else
        sudo "$@"
    fi
}

echo "Setting up Claude Code persistence..."

# Handle ~/.claude/ directory persistence
if [ "$PERSIST_CLAUDE_DIR" = "true" ]; then
    if [ -d "$MOUNT_CLAUDE_DIR" ]; then
        echo "Configuring ~/.claude/ persistence..."

        # Set ownership of mount point
        maybe_sudo chown -R "$USER_NAME:$USER_NAME" "$MOUNT_CLAUDE_DIR"

        # Back up existing directory if it exists and is not a symlink
        if [ -d "$CLAUDE_DIR" ] && [ ! -L "$CLAUDE_DIR" ]; then
            echo "Backing up existing ~/.claude/ to ~/.claude.old/"
            if [ -d "$CLAUDE_DIR.old" ]; then
                rm -rf "$CLAUDE_DIR.old"
            fi
            mv "$CLAUDE_DIR" "$CLAUDE_DIR.old"
        fi

        # Remove existing symlink if present
        if [ -L "$CLAUDE_DIR" ]; then
            rm "$CLAUDE_DIR"
        fi

        # Create symlink
        ln -s "$MOUNT_CLAUDE_DIR" "$CLAUDE_DIR"
        echo "✓ ~/.claude/ -> $MOUNT_CLAUDE_DIR"
    else
        echo "⚠ Mount point $MOUNT_CLAUDE_DIR not found, skipping ~/.claude/ persistence"
    fi
else
    echo "Skipping ~/.claude/ persistence (disabled)"
fi

# Handle ~/.claude.json file persistence
if [ "$PERSIST_CLAUDE_JSON" = "true" ]; then
    if [ -d "$MOUNT_CLAUDE_JSON" ]; then
        echo "Configuring ~/.claude.json persistence..."

        # Set ownership of mount point
        maybe_sudo chown -R "$USER_NAME:$USER_NAME" "$MOUNT_CLAUDE_JSON"

        # The actual file inside the volume
        VOLUME_JSON_FILE="$MOUNT_CLAUDE_JSON/claude.json"

        # Back up existing file if it exists and is not a symlink
        if [ -f "$CLAUDE_JSON" ] && [ ! -L "$CLAUDE_JSON" ]; then
            echo "Backing up existing ~/.claude.json to ~/.claude.json.old"
            if [ -f "$CLAUDE_JSON.old" ]; then
                rm -f "$CLAUDE_JSON.old"
            fi
            mv "$CLAUDE_JSON" "$CLAUDE_JSON.old"

            # If volume file doesn't exist, copy the backup to volume
            if [ ! -f "$VOLUME_JSON_FILE" ]; then
                cp "$CLAUDE_JSON.old" "$VOLUME_JSON_FILE"
            fi
        fi

        # Remove existing symlink if present
        if [ -L "$CLAUDE_JSON" ]; then
            rm "$CLAUDE_JSON"
        fi

        # Create symlink to file inside volume
        ln -s "$VOLUME_JSON_FILE" "$CLAUDE_JSON"
        echo "✓ ~/.claude.json -> $VOLUME_JSON_FILE"
    else
        echo "⚠ Mount point $MOUNT_CLAUDE_JSON not found, skipping ~/.claude.json persistence"
    fi
else
    echo "Skipping ~/.claude.json persistence (disabled)"
fi

echo "Claude Code persistence setup complete."
