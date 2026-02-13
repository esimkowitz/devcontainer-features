#!/bin/bash
set -e

echo "Testing ssh-signing feature..."

# Check setup script exists
if [ -x /usr/local/share/ssh-signing-setup.sh ]; then
    echo "✓ SSH signing setup script exists and is executable"
else
    echo "✗ SSH signing setup script not found"
    exit 1
fi

# Check profile.d script exists
if [ -f /etc/profile.d/ssh-signing-setup.sh ]; then
    echo "✓ profile.d login hook exists"
else
    echo "✗ profile.d login hook not found"
    exit 1
fi

# Check git aliases are configured (when gitAliases=true)
if git config --global --get alias.st > /dev/null 2>&1; then
    echo "✓ Git aliases configured"
else
    echo "⚠ Git aliases not configured (may be expected if gitAliases=false)"
fi

echo "All ssh-signing tests passed!"
