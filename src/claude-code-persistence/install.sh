#!/bin/sh
set -e

# Create directory for feature scripts
FEATURE_DIR="/usr/local/share/claude-code-persistence"
mkdir -p "$FEATURE_DIR"

# Copy onCreate script
cp "$(dirname "$0")/onCreate.sh" "$FEATURE_DIR/onCreate.sh"
chmod +x "$FEATURE_DIR/onCreate.sh"

echo "Claude Code Persistence feature installed."
