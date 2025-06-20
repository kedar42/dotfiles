# Dotfiles

## Dependencies

### Shell

- [fish](https://fishshell.com/)

### Cmd tools

- [bat](https://github.com/sharkdp/bat)
- [bat-extras]()
- [eza](https://github.com/eza-community/eza)
- [fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf)
- [nvim](https://neovim.io/)
- [git-delta]()
- [yazi]()
- [stow](https://www.gnu.org/software/stow/)
- [ghostty]()
- [starship](https://starship.rs/)
- [dust]()

## Info

This is my zsh based shell configuration.

In short this is highly personalized "collection" of configs and tools I use.

## Setup

Quickest way to get this working. Don't use it if you don't know what you are doing. This will overwrite your home directory files. You also need to have `stow` installed.

```bash
git clone https://github.com/kedar42/dotfiles.git
cd dotfiles
stow --dotfiles --no-folding --adopt -t ~ home
git reset --hard
```

### Me relevant distros installation

#### Arch Linux

```bash
sudo pacman -S bat eza fd ripgrep zoxide fzf neovim fish git-delta yazi stow ghostty starship bat-extras
```

## TODO
- [ ] Read on duf
- [ ] Read on dust
- [ ] Integrate git-delta
- [ ] Better integration with fzf
- [ ] Look into dog
- [ ] Look httpie

