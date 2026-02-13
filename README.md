# Devcontainer Features

Personal [dev container features](https://containers.dev/implementors/features/) for configuring development environments.

## Features

### fish-starship

Installs [Fish shell](https://fishshell.com/) and [Starship](https://starship.rs/) prompt.

| Option | Type | Default |
|--------|------|---------|
| `fishGreeting` | string | `Glub glub! 🐟 🐠` |

### ssh-signing

Configures git to use SSH commit signing when an agent is available. Detects keys automatically at container start.

| Option | Type | Default |
|--------|------|---------|
| `gitUserName` | string | `""` |
| `gitUserEmail` | string | `""` |
| `gitAliases` | boolean | `true` |

Includes git aliases (`st`, `co`, `br`), `pull.rebase=true`, `autocrlf=input`, and `init.defaultBranch=main`.

## Usage

Add features to your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/esimkowitz/dotfiles/fish-starship:1": {},
        "ghcr.io/esimkowitz/dotfiles/ssh-signing:1": {}
    }
}
```

### SSH Agent Forwarding

For SSH signing to work, mount your host's SSH agent socket into the container. Add to VS Code User Settings (`Ctrl+Shift+P` > "Preferences: Open User Settings (JSON)"):

```json
{
    "dev.containers.defaultMounts": [
        "source=${localEnv:SSH_AUTH_SOCK},target=/ssh-agent,type=bind"
    ],
    "dev.containers.containerEnv": {
        "SSH_AUTH_SOCK": "/ssh-agent"
    }
}
```
