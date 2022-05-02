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

# remove . before files in dotfiles
handleFile ""
