#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"

# Run SSH signing setup
source "$DOTFILES_DIR/scripts/setup-ssh-signing.sh"

# Include gitconfig extras (optional)
if [ -f "$DOTFILES_DIR/git/.gitconfig" ]; then
    git config --global include.path "$DOTFILES_DIR/git/.gitconfig"
fi

echo "Dotfiles installation complete!"
