# Shell Config

## Info

This is my fish based shell configuration.

In short this is highly personalized "collection" of configs and tools I use daily. I wanted to have it somewhere where I can easily clone it and have my shell up and running in no time. This is not meant to be used by anyone else, but if you find something useful feel free to use it.

## Installation

```bash
git clone https://github.com/kedar42/dotfiles.git
cd dotfiles
cp -r config/* ~/.config/
```

## What is this?

This started as a personal dotfiles repo, but later I came to a conclusion that due to me using multiple machines and OSes, I would rather have this as a repo for my shell configuration and all the shell tools/scripts that I use. Due to this I will be taking out everything that is not used while INSIDE a terminal window. I mainly use linux as servers or WSL and Windows for desktops, if this changes workspace repo will be created and this will be used to bring my shell there.

## Dependencies

fish, bat, eza

### Me relevant distros installation

#### Fedora

```bash
sudo dnf install fish bat eza
```
