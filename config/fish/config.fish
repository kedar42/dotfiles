if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
end

set EDITOR nvim

fish_add_path /home/kedar/bin
abbr -a gco git checkout

abbr -a pac sudo pacman
abbr -a pacs sudo pacman -S
abbr -a pacr sudo pacman -R
abbr -a yays yay -S
abbr -a yayr yay -R

abbr -a vch vim ~/.config/hypr/hyprland.conf

