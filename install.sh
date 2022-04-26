#!/bin/sh

DOTFILES=$0
# todo make more modular not hardcoded, remove . before files in dotfiles

sudo rm -rf ~/.bashrc
sudo rm -rf ~/.config/kitty
sudo rm -rf ~/.config/nvim

ln -s $DOTFILES/.bashrc $HOME/.bashrc
mkdir $HOME/.config/kitty
ln -s $DOTFILES/.config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf 
ln -s $DOTFILES/.config/kitty/current-theme.conf $HOME/.config/kitty/current-theme.conf
mkdir $HOME/.config/nvim 
ln -s $DOTFILES/.config/nvim/init.lua $HOME/.config/nvim/init.lua
