if status is-interactive
    set -g fish_greeting "{{FISH_GREETING}}"
    starship init fish | source
    if command -q task
        task --completion fish | source
    end
end
