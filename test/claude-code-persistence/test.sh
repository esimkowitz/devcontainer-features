#!/bin/bash
set -e

echo "Testing claude-code-persistence feature..."

# Check onCreate.sh was installed
if [ -f /usr/local/share/claude-code-persistence/onCreate.sh ]; then
    echo "✓ onCreate.sh installed"
else
    echo "✗ onCreate.sh not found"
    exit 1
fi

# Check mount points exist
if [ -d /mnt/claude-dir ]; then
    echo "✓ /mnt/claude-dir mount exists"
else
    echo "✗ /mnt/claude-dir mount not found"
    exit 1
fi

if [ -d /mnt/claude-json ]; then
    echo "✓ /mnt/claude-json mount exists"
else
    echo "✗ /mnt/claude-json mount not found"
    exit 1
fi

# Check symlinks based on default options (persistClaudeDir=true, persistClaudeJson=false)
if [ -L "$HOME/.claude" ]; then
    TARGET=$(readlink "$HOME/.claude")
    if [ "$TARGET" = "/mnt/claude-dir" ]; then
        echo "✓ ~/.claude symlink correctly points to /mnt/claude-dir"
    else
        echo "✗ ~/.claude symlink points to wrong target: $TARGET"
        exit 1
    fi
else
    echo "✗ ~/.claude is not a symlink"
    exit 1
fi

# ~/.claude.json should NOT be a symlink with default options
if [ -L "$HOME/.claude.json" ]; then
    echo "✗ ~/.claude.json should not be a symlink with default options"
    exit 1
else
    echo "✓ ~/.claude.json is not a symlink (expected with default options)"
fi

# Test persistence by writing a file
echo "test-data" > "$HOME/.claude/test-persistence"
if [ -f /mnt/claude-dir/test-persistence ]; then
    echo "✓ Data persists through symlink"
    rm /mnt/claude-dir/test-persistence
else
    echo "✗ Data not found in volume"
    exit 1
fi

echo "All claude-code-persistence tests passed!"
