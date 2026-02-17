#!/bin/bash
set -e

echo "Testing direnv feature..."

# Check direnv is installed
direnv version
echo "✓ direnv installed"

# Check bash hook
if [ -f /etc/bash.bashrc ]; then
    if grep -q 'direnv hook bash' /etc/bash.bashrc; then
        echo "✓ Bash hook configured"
    else
        echo "✗ Bash hook not found in /etc/bash.bashrc"
        exit 1
    fi
else
    echo "⚠ /etc/bash.bashrc not found (may be expected)"
fi

# Check zsh hook
if [ -f /etc/zsh/zshrc ]; then
    if grep -q 'direnv hook zsh' /etc/zsh/zshrc; then
        echo "✓ Zsh hook configured"
    else
        echo "✗ Zsh hook not found in /etc/zsh/zshrc"
        exit 1
    fi
else
    echo "⚠ /etc/zsh/zshrc not found (may be expected)"
fi

# Check fish hook
if [ -f "$HOME/.config/fish/config.fish" ]; then
    if grep -q 'direnv hook fish' "$HOME/.config/fish/config.fish"; then
        echo "✓ Fish hook configured"
    else
        echo "✗ Fish hook not found in config.fish"
        exit 1
    fi
else
    echo "⚠ Fish config not found (may be expected if fish-starship not installed)"
fi

# Check direnvrc
if [ -f "$HOME/.config/direnv/direnvrc" ]; then
    if grep -q 'load_dotenv' "$HOME/.config/direnv/direnvrc"; then
        echo "✓ direnvrc configured with load_dotenv"
    else
        echo "✗ direnvrc missing load_dotenv"
        exit 1
    fi
else
    echo "✗ direnvrc not found"
    exit 1
fi

echo "All direnv tests passed!"
