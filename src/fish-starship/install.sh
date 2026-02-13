#!/bin/bash
set -e

echo "Installing Fish shell and Starship prompt..."

# Install Fish shell
apt-get update
apt-get install -y --no-install-recommends software-properties-common
apt-add-repository -y ppa:fish-shell/release-3
apt-get update
apt-get install -y --no-install-recommends fish
apt-get clean -y
rm -rf /var/lib/apt/lists/*

# Install Starship
curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

# Set up Fish config
FISH_CONFIG_DIR="${_REMOTE_USER_HOME}/.config/fish"
mkdir -p "$FISH_CONFIG_DIR"

# Substitute greeting option and copy config
GREETING="${FISHGREETING:-"Glub glub! 🐟 🐠"}"
sed "s|{{FISH_GREETING}}|${GREETING}|g" "$(dirname "$0")/config.fish" > "$FISH_CONFIG_DIR/config.fish"

# Set ownership
chown -R "${_REMOTE_USER}:${_REMOTE_USER}" "${_REMOTE_USER_HOME}/.config"

# Install onCreate script for persistent fish data
FEATURE_DIR="/usr/local/share/fish-starship"
mkdir -p "$FEATURE_DIR"
cp "$(dirname "$0")/onCreate.sh" "$FEATURE_DIR/onCreate.sh"
chmod +x "$FEATURE_DIR/onCreate.sh"

echo "Fish shell and Starship prompt installed successfully!"
