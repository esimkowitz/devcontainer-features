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

### direnv

Installs [direnv](https://direnv.net/) and configures shell hooks for bash, zsh, and fish. Enables `load_dotenv` by default so `.env` files are automatically loaded.

| Option | Type | Default |
|--------|------|---------|
| `version` | string | `"latest"` |

The `version` option accepts `"latest"`, `"system"`, or a specific version like `"2.34.0"`.

### claude-code-persistence

Persists [Claude Code](https://claude.ai/code) configuration across container rebuilds using Docker named volumes.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `persistClaudeDir` | boolean | `true` | Persist `~/.claude/` directory (history, projects, settings) |
| `persistClaudeJson` | boolean | `false` | Persist `~/.claude.json` file (auth/config) |
| `sharedAcrossContainers` | boolean | `false` | Reserved for future use |

Use alongside a Claude Code installation feature (e.g., `ghcr.io/anthropics/devcontainer-features/claude-code`).

## Usage

Add features to your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/esimkowitz/devcontainer-features/fish-starship:1": {},
        "ghcr.io/esimkowitz/devcontainer-features/ssh-signing:1": {},
        "ghcr.io/esimkowitz/devcontainer-features/direnv:1": {},
        "ghcr.io/esimkowitz/devcontainer-features/claude-code-persistence:1": {}
    }
}
```

### SSH Agent Forwarding

VS Code [automatically forwards your SSH agent](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials) into dev containers. The ssh-signing feature detects this at shell login and configures git commit signing automatically — no additional configuration needed.
