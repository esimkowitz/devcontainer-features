#!/bin/bash
set -e

echo "Installing SSH signing setup..."

# Install the runtime setup script
# SSH signing detection must happen at runtime since SSH_AUTH_SOCK
# is only available when the container runs, not at build time.
cat > /usr/local/share/ssh-signing-setup.sh << 'SCRIPT'
#!/bin/bash

setup_ssh_signing() {
    # Check if SSH_AUTH_SOCK is set and points to a valid socket
    if [ ! -S "${SSH_AUTH_SOCK:-}" ]; then
        echo "○ SSH_AUTH_SOCK not set or not a socket, skipping signing setup"
        return 0
    fi

    # Verify we can communicate with the agent
    # ssh-add -l returns: 0 = keys listed, 1 = agent running but empty, 2 = can't connect
    if ! ssh-add -l &>/dev/null && [ $? -eq 2 ]; then
        echo "○ Cannot connect to SSH agent, skipping signing setup"
        return 0
    fi

    echo "✓ SSH agent available, configuring git commit signing"

    # Configure git to use SSH for signing
    git config --global gpg.format ssh
    git config --global commit.gpgsign true

    # Get the first available signing key from the agent
    SIGNING_KEY=$(ssh-add -L 2>/dev/null | head -n 1)

    if [ -n "$SIGNING_KEY" ]; then
        git config --global user.signingkey "key::$SIGNING_KEY"
        echo "✓ Signing key configured"
    else
        echo "⚠ No keys found in agent, you'll need to set user.signingkey manually"
    fi
}

setup_ssh_signing
SCRIPT
chmod +x /usr/local/share/ssh-signing-setup.sh

# Install a profile.d script so signing is configured on shell login
cat > /etc/profile.d/ssh-signing-setup.sh << 'PROFILE'
# Run SSH signing setup on first login (only once per session)
if [ -z "$_SSH_SIGNING_CONFIGURED" ]; then
    /usr/local/share/ssh-signing-setup.sh
    export _SSH_SIGNING_CONFIGURED=1
fi
PROFILE

# Configure git user identity if provided
if [ -n "${GITUSERNAME}" ]; then
    git config --global user.name "${GITUSERNAME}"
    echo "✓ Git user.name set to '${GITUSERNAME}'"
fi

if [ -n "${GITUSEREMAIL}" ]; then
    git config --global user.email "${GITUSEREMAIL}"
    echo "✓ Git user.email set to '${GITUSEREMAIL}'"
fi

# Apply git aliases if option is enabled
if [ "${GITALIASES}" = "true" ]; then
    GITCONFIG_PATH="/usr/local/share/ssh-signing-gitconfig"
    cp "$(dirname "$0")/gitconfig" "$GITCONFIG_PATH"
    git config --global include.path "$GITCONFIG_PATH"
    echo "✓ Git aliases and settings applied"
fi

echo "SSH signing setup installed successfully!"
