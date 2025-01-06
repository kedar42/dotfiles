# Dotfiles

## Dependencies

### Shell

- [zsh](https://github.com/zsh-users/zsh)

### Cmd tools

- [bat](https://github.com/sharkdp/bat)
- [eza](https://github.com/eza-community/eza)
- [fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf)
- [nvim](https://neovim.io/)

## Info

This is my zsh based shell configuration.

In short this is highly personalized "collection" of configs and tools I use.

## Installation

### !BEWARE THIS WILL REPLACE ANY FILES THAT ARE ALSO INCLUDED IN DOTFILES

```bash
git clone https://github.com/kedar42/dotfiles.git
cd dotfiles
stow --dotfiles --no-folding --adopt -t ~ home
git --reset hard
```

### Me relevant distros installation

#### MacOs

```bash
brew install bat eza zoxide fzf ripgrep fd neovim
```

#### Fedora

```bash
sudo dnf install zsh bat eza zoxide fzf ripgrep fd neovim
```

I am also using [ghostty](https://ghostty.org/) for terminal but it config is not included here  
