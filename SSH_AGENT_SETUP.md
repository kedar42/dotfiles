# SSH Agent Setup for GUI Applications

## Problem
GUI applications (Zed, Cursor, etc.) can't access SSH keys from Bitwarden SSH agent because they don't inherit shell environment variables.

## Solution

### Linux (KDE Plasma)

Create `~/.config/environment.d/ssh.conf`:
```
SSH_AUTH_SOCK=${HOME}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock
```

Then logout/login or run:
```bash
systemctl --user import-environment SSH_AUTH_SOCK
```

### macOS

Create or edit `~/.bash_profile`:
```bash
export SSH_AUTH_SOCK="$HOME/Library/Application Support/Bitwarden/.bitwarden-ssh-agent.sock"
```

Then logout/login.

## Verify

Check if it's working:
```bash
echo $SSH_AUTH_SOCK
ssh-add -l
```
