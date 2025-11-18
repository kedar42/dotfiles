

# TODO: End non interactive shell here

# fnm setup - works on both macOS and Linux
if command -q fnm
    fnm env --use-on-cd | source
end

# Bitwarden SSH agent - platform-aware socket detection
if test -z "$SSH_AUTH_SOCK"
    # Linux (Flatpak)
    if test -S ~/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock
        set -x SSH_AUTH_SOCK ~/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock
    # macOS (typical location)
    else if test -S ~/Library/Application\ Support/Bitwarden/.bitwarden-ssh-agent.sock
        set -x SSH_AUTH_SOCK ~/Library/Application\ Support/Bitwarden/.bitwarden-ssh-agent.sock
    # Alternative Linux native install
    else if test -S ~/.config/Bitwarden/.bitwarden-ssh-agent.sock
        set -x SSH_AUTH_SOCK ~/.config/Bitwarden/.bitwarden-ssh-agent.sock
    end
end
