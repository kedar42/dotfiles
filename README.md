# Dotfiles

Personal Fish, Zsh, Ghostty, Git, and Neovim configuration. The shell setup
keeps Zsh as the login shell and uses Fish interactively in Ghostty.

The configuration keeps useful optional integrations while avoiding generated
state and aliases that pretend incompatible commands are drop-in replacements.

## Included

- Fish abbreviations, `fnm`, `fzf`, and Starship setup
- Small `backup`, `cdm`, `up`, and `extract` helpers
- Interactive Docker log and shell selection helpers
- Ghostty appearance and quick-terminal bindings
- Git Delta, LFS, rebase, rerere, and diff defaults
- Neovim editing, navigation, LSP, completion, formatting, and linting setup

## Install

On macOS, install Homebrew, clone this repository, and install the managed tool
set:

```sh
git clone https://github.com/kedar42/dotfiles.git
cd dotfiles
brew bundle --file ./Brewfile
```

Preview the links first:

```sh
stow --dotfiles --no-folding --target "$HOME" --simulate --verbose home
```

Move conflicting files out of the target locations before linking. Stow aborts
rather than overwriting existing files:

```sh
stow --dotfiles --no-folding --target "$HOME" home
```

Do not use `stow --adopt` followed by `git reset --hard`; that workflow can
overwrite local files.

The current Ghostty command points to `/opt/homebrew/bin/fish` for Apple
Silicon. Override that line with the appropriate Fish path on other platforms.

## Theme

Kanagawa Wave is configured consistently for Ghostty, Fish, Neovim, Zed, and
Claude Code. Only Claude's appearance settings, custom theme, and statusline
script are tracked; authentication, histories, project state, and caches remain
local.

## Local Git Identity

Personal and work identities are deliberately excluded. Create
`~/.config/git/config.local` outside this repository:

```gitconfig
[user]
    name = Your Name
    email = you@example.com
```

Add signing or conditional work configuration there only when needed. Secrets
and service tokens must not be stored in this repository.

## Local Secrets

Fish and Zsh automatically export every regular file in
`~/.config/local/env.d`. The filename is the environment-variable name and the
file contents, with trailing newlines removed, are its value. For example:

```text
~/.config/local/env.d/GRAFANA_SERVICE_ACCOUNT_TOKEN
```

Variable names must match `[A-Za-z_][A-Za-z0-9_]*`; symlinks and invalid names
are ignored. Adding another token requires only another file, with no shell
configuration change.

The repository manages only the loading logic. Stow does not manage or
overwrite `~/.config/local`.

Keep `~/.config/local` and `env.d` private (`700`) and each value file readable
only by the current user (`600`).

## Neovim Tools

Mason installs the configured language servers. Formatters and linters are
used when their executables are available; install only those needed for the
languages used on a given machine.
