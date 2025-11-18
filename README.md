# Dotfiles

A highly personalized set of configuration files for my linux and macOS environments. This config relies on usage of fish shell, most tools are used by the fish config. In case you are using Linux, please use the `linux` branch.

## Basic info

As mentioned, this config relies on fish shell, but I advise against setting it as your default shell. Instead, you should set it up as a shell for your terminal emulator (ghostty in my case). Most of the tools mentioned are used to provide a better replacement for some of the default tools, overwriting them using fish aliases. Fish also provides some abbreviations for some commands I use frequently during software development, you can print them using `abbr` command in fish shell.

## Used tools

### Shell and active usage tools

- [fish](https://fishshell.com/): A smarter shell that provides autocompletion and syntax highlighting out of the box.
- [zsh](https://www.zsh.org/): Used for non interactive shell scripts, as fish is not POSIX compliant.
- [nvim](https://neovim.io/): Preferred text editor, basic plugins are included in the config.
- [ghostty](https://ghostty.org/): My choice of terminal emulator, provides a way to run fish shell in a terminal, this is probably the most opinionated choice in this config.

### Tools used passively

These tools are mostly used as replacements for some of the default tools, or directly utilized by the fish shell config, therefore they are used "automatically" when you use the shell.

- [bat](https://github.com/sharkdp/bat): Used for syntax highlighting and file viewing, in this config it is NOT used as a replacement for `cat`, but rather as utility for viewing files. Also automatically used for `man` pages via `batman` alias from bat-extras.
- [eza](https://github.com/eza-community/eza): Replacement for `ls`, provides better formatting and colors.
- [fd](https://github.com/sharkdp/fd): Used as a replacement for `find`.
- [ripgrep](https://github.com/BurntSushi/ripgrep): Used as a replacement for `grep`.
- [zoxide](https://github.com/ajeetdsouza/zoxide): Replacement for `cd`, provides additional functionality like ability to change directories to visited directories quickly.
- [fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder, used for searching files and directories.
- [git-delta](https://github.com/dandavison/delta): A syntax-highlighting pager for git and diff output, enhances `git diff`, `git log`, and `git show` with syntax highlighting and side-by-side view.
- [stow](https://www.gnu.org/software/stow/): A symlink farm manager, used to manage dotfiles and configuration files, used in the setup process.
- [starship](https://starship.rs/): Customizable prompt for any shell, the default prompt is used in this config.
- [dust](https://github.com/bootandy/dust): A replacement for `du`.
- [fnm](https://github.com/Schniz/fnm): Fast Node.js version manager, automatically switches Node versions based on `.node-version` or `.nvmrc` files.



## Setup

The quickest way to set up this config is to clone the repository and use GNU Stow to symlink the files to your home directory. This will create symlinks for all the files in the `home` directory of the repository to your home directory. Stow will overwrite files in this repo in case you already have them in your home directory, `git reset --hard` will remove any changes you made to the files in the repository, therefore overwriting your files in the home directory with the files from the repository. **Use this command with caution!**

```bash
git clone https://github.com/kedar42/dotfiles.git
cd dotfiles
stow --dotfiles --no-folding --adopt -t ~ home
git reset --hard
```

### Git configuration (personal info)

The `.gitconfig` includes sensible defaults and git-delta configuration, but you need to add your personal information:

1. **Edit `~/.config/git/config.local`** with your personal details (template included in dotfiles)

2. **(Optional) For work repositories:** Edit `~/.config/git/config.work` with your work details, then add to `~/.config/git/config.local`:
   ```gitconfig
   # Work overrides - only applies in work directories
   [includeIf "gitdir:~/work/"]
       path = ~/.config/git/config.work
   ```

This will automatically use your work credentials for any repositories inside `~/work/`.

### Installation of required tools

#### Arch Linux

Update system and install core tools:
```bash
sudo pacman -Syu bat bat-extras eza fd ripgrep zoxide fzf neovim fish stow ghostty starship dust fnm dog git-delta zsh
```

Set zsh as default shell (required for system compatibility):
```bash
chsh -s /usr/bin/zsh
```

#### macOS

Install Homebrew if not already installed:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Update Homebrew:
```bash
brew update
```

Install core tools:
```bash
brew install bat bat-extras eza fd ripgrep zoxide fzf neovim fish stow starship dust fnm dog git-delta
```

Install Ghostty (GUI application):
```bash
brew install --cask ghostty
```

## TODO
- [ ] Read on duf
- [ ] Read on dust
- [ ] Integrate git-delta
- [ ] Better integration with fzf
- [ ] Look into dog
- [ ] Look httpie
