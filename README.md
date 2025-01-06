# Dotfiles

## Dependencies

### Shell

- [zsh](https://github.com/zsh-users/zsh)
- [starship](https://starship.rs)

### Cmd tools

- [bat](https://github.com/sharkdp/bat)
- [eza](https://github.com/eza-community/eza)
- [fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf)


## Info

This is my zsh based shell configuration.

In short this is highly personalized "collection" of configs and tools I use.

## Installation

```bash
git clone https://github.com/kedar42/dotfiles.git
cd dotfiles
stow --dotfiles -t ~ home
```

### Me relevant distros installation

#### MacOs

```bash
brew install bat eza zoxide fzf ripgrep starship fd
```

#### Fedora

```bash
sudo dnf install zsh bat eza zoxide fzf ripgrep starship fd
```

I am also using [ghostty](https://ghostty.org/) for terminal but it config is not included here 
