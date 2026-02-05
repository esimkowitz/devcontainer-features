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
    # Or you can hardcode your preferred key here
    SIGNING_KEY=$(ssh-add -L 2>/dev/null | head -n 1)

    if [ -n "$SIGNING_KEY" ]; then
        git config --global user.signingkey "key::$SIGNING_KEY"
        echo "✓ Signing key configured"
    else
        echo "⚠ No keys found in agent, you'll need to set user.signingkey manually"
    fi
}

setup_ssh_signing
