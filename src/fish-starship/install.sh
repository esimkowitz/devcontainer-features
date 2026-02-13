#!/bin/bash
set -e

echo "Installing Fish shell and Starship prompt..."

# Install Fish shell via PPA (added manually to avoid apt-add-repository Launchpad API issues)
# Adapted from https://github.com/meaningful-ooo/devcontainer-features/blob/main/src/fish/install.sh
apt-get update
apt-get install -y --no-install-recommends curl ca-certificates
. /etc/os-release
echo "deb https://ppa.launchpadcontent.net/fish-shell/release-4/ubuntu ${UBUNTU_CODENAME} main" \
    > /etc/apt/sources.list.d/fish-shell-release-4.list
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x88421e703edc7af54967ded473c9fcc9e2bb48da" \
    > /etc/apt/trusted.gpg.d/fish-shell-release-4.asc
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
