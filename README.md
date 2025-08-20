# Dotfiles

A highly personalized set of configuration files for my linux and macOS environments. This config relies on usage of fish shell, most tools are used by the fish config. In case you are using Linux, please use the `linux` branch.

## Basic info

As mentioned, this config relies on fish shell, but I advise against setting it as your default shell. Instead, you should set it up as a shell for your terminal emulator (ghostty in my case). Most of the tools mentioned are used to provide a better replacement for some of the default tools, overwriting them using fish aliases. Fish also provides some abbreviations for some commands I use frequently during software development, you can print them using `abbr` command in fish shell.

## Used tools

### Shell and active usage tools

- [fish](https://fishshell.com/): A smarter shell that provides autocompletion and syntax highlighting out of the box.
- [nvim](https://neovim.io/): Preferred text editor, basic plugins are included in the config.
- [ghostty](https://ghostty.org/): My choice of terminal emulator, provides a way to run fish shell in a terminal, this is probably the most opinionated choice in this config.
- [yazi](https://github.com/sxyazi/yazi): A terminal file manager that provides a way to navigate and manage files in the terminal.
- [paru](https://github.com/Morganamilo/paru): An AUR helper for Arch Linux, used for installing packages from the AUR. Includes abbreviations `p` and `pi` for quick package management.

### Tools used passively

These tools are mostly used as replacements for some of the default tools, or directly utilized by the fish shell config, therefore they are used "automatically" when you use the shell.

- [bat](https://github.com/sharkdp/bat): Used for syntax highlighting and file viewing, in this config it is NOT used as a replacement for `cat`, but rather as utility for viewing files.
- [bat-extras](https://github.com/eth-p/bat-extras): Used for man pages syntax highlighting.
- [eza](https://github.com/eza-community/eza): Replacement for `ls`, provides better formatting and colors.
- [fd](https://github.com/sharkdp/fd): Used as a replacement for `find`.
- [ripgrep](https://github.com/BurntSushi/ripgrep): Used as a replacement for `grep`.
- [zoxide](https://github.com/ajeetdsouza/zoxide): Replacement for `cd`, provides additional functionality like ability to change directories to visited directories quickly.
- [fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder, used for searching files and directories.
- [git-delta](https://github.com/dandavison/delta): A syntax-highlighting pager for git and diff output, used to enhance the output of `git diff` and `git log`.
- [stow](https://www.gnu.org/software/stow/): A symlink farm manager, used to manage dotfiles and configuration files, used in the setup process.
- [starship](https://starship.rs/): Customizable prompt for any shell, the default prompt is used in this config.
- [dust](https://github.com/bootandy/dust): A replacement for `du`.
- [dog](https://github.com/ogham/dog): A replacement for `dig`, used for DNS queries. ⚠️ **Note**: This alias may not cover all use cases, use with caution.

## Setup

The quickest way to set up this config is to clone the repository and use GNU Stow to symlink the files to your home directory. This will create symlinks for all the files in the `home` directory of the repository to your home directory. Stow will overwrite files in this repo in case you already have them in your home directory, `git reset --hard` will remove any changes you made to the files in the repository, therefore overwriting your files in the home directory with the files from the repository. **Use this command with caution!**

```bash
git clone https://github.com/kedar42/dotfiles.git
cd dotfiles
stow --dotfiles --no-folding --adopt -t ~ home
git reset --hard
```

### Installation of required tools

You can either use the automated installation script or install tools manually for your platform.

#### Automated Installation (Recommended)

```bash
# Run the installation script
./install.sh
```

The script will detect your operating system and install the appropriate packages. Currently supports:
- Arch Linux (pacman)
- macOS (Homebrew)  
- Ubuntu/Debian (APT, with notes for additional tools)

#### Manual Installation

##### Arch Linux

```bash
sudo pacman -S bat eza fd ripgrep zoxide fzf neovim fish git-delta yazi stow ghostty starship bat-extras dust
```

##### macOS (Homebrew)

```bash
brew install bat eza fd ripgrep zoxide fzf neovim fish git-delta yazi stow starship dust
brew install eth-p/software/bat-extras
```

**Note**: Ghostty needs to be installed separately from [ghostty.org](https://ghostty.org/).

##### Ubuntu/Debian (APT)

Most tools can be installed via apt, but some may need to be installed from their respective GitHub releases or via alternative methods:

```bash
# Available in standard repositories
sudo apt update
sudo apt install bat fd-find ripgrep fzf neovim fish git-delta stow

# Tools that may need alternative installation methods:
# - eza: Install from GitHub releases or via cargo
# - zoxide: Install from GitHub releases or via cargo  
# - yazi: Install from GitHub releases or via cargo
# - starship: Install from GitHub releases or via curl
# - dust: Install from GitHub releases or via cargo
# - ghostty: Install from ghostty.org
# - bat-extras: Install from GitHub
```

##### AUR packages (Arch Linux)

For AUR packages, you can use `paru` or `yay`:

```bash
# Install paru first if you don't have an AUR helper
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si

# Then install AUR packages if needed
paru -S ghostty-git  # if not available in official repos
```

## TODO
- [ ] Read on duf
- [ ] Read on dust
- [ ] Integrate git-delta
- [ ] Better integration with fzf
- [ ] Look into dog
- [ ] Look httpie

