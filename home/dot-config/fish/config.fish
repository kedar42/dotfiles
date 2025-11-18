

# TODO: End non interactive shell here

# fnm setup - works on both macOS and Linux
if command -q fnm
    fnm env --use-on-cd | source
end

# Bitwarden SSH agent - platform-aware socket detection
if test -z "$SSH_AUTH_SOCK"
    # Linux (native install - home directory)
    if test -S ~/.bitwarden-ssh-agent.sock
        set -x SSH_AUTH_SOCK ~/.bitwarden-ssh-agent.sock
    # Linux (native install - config directory)
    else if test -S ~/.config/Bitwarden/.bitwarden-ssh-agent.sock
        set -x SSH_AUTH_SOCK ~/.config/Bitwarden/.bitwarden-ssh-agent.sock
    # macOS (Homebrew cask)
    else if test -S ~/Library/Group\ Containers/LTZ2PFU5D6.com.8bit.bitwarden/.bitwarden-ssh-agent.sock
        set -x SSH_AUTH_SOCK ~/Library/Group\ Containers/LTZ2PFU5D6.com.8bit.bitwarden/.bitwarden-ssh-agent.sock
    # macOS (App Store or direct download)
    else if test -S ~/Library/Application\ Support/Bitwarden/.bitwarden-ssh-agent.sock
        set -x SSH_AUTH_SOCK ~/Library/Application\ Support/Bitwarden/.bitwarden-ssh-agent.sock
    # Linux (Flatpak - legacy)
    else if test -S ~/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock
        set -x SSH_AUTH_SOCK ~/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock
    end
end
