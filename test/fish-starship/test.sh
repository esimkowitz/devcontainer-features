#!/bin/bash
set -e

echo "Testing fish-starship feature..."

# Check Fish is installed
fish --version
echo "✓ Fish shell installed"

# Check Starship is installed
starship --version
echo "✓ Starship installed"

# Check config.fish exists
if [ -f "$HOME/.config/fish/config.fish" ]; then
    echo "✓ config.fish exists"
else
    echo "✗ config.fish not found"
    exit 1
fi

echo "All fish-starship tests passed!"
