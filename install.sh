#!/bin/bash
shopt -s dotglob
DOTFILES=$(dirname $(readlink -f $0))
DOTFILES="$DOTFILES/config"

handleFile() {
    for item in "$DOTFILES"/"$1"/*; do
    if [ "$1" == "$item" ]; then
        continue
    fi

    filename=$(basename "$item")
    
    if [ -d "$item" ]; then
        [ ! -d "$HOME""$1"/"$filename" ] && mkdir "$HOME""$1"/"$filename"
        handleFile "$1"/"$filename"
    else 
       ln -sf "$DOTFILES""$1"/"$filename" "$HOME""$1"/"$filename"
    fi
done
}

# todo make more modular not hardcoded, remove . before files in dotfiles

#sudo rm -rf ~/.bashrc
#sudo rm -rf ~/.config/kitty
#sudo rm -rf ~/.config/nvim

#ln -s $DOTFILES/.bashrc $HOME/.bashrc
#mkdir $HOME/.config/kitty
#ln -s $DOTFILES/.config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf 
#ln -s $DOTFILES/.config/kitty/current-theme.conf $HOME/.config/kitty/current-theme.conf
#mkdir $HOME/.config/nvim 
#ln -s $DOTFILES/.config/nvim/init.lua $HOME/.config/nvim/init.lua
#ln -fs $DOTFILES/.zshrc $HOME/.zshrc
handleFile ""
