
if type -q nvim
    set -gx EDITOR nvim
    alias vi nvim
    alias vim nvim
end

abbr -a vpn "sudo snx-rs -m command"

if type -q eza
    alias ls="eza --group-directories-first --git --icons=auto"
    alias l="eza -blF --group-directories-first --icons=auto"
    alias ll="eza -abghilmu --git --icons=auto"
    alias tree="eza --tree --group-directories-first --icons=auto"
end

if type -q fd
    alias find="fd"
end

if type -q rg
    alias grep="rg"
end

if type -q zoxide
    zoxide init --cmd cd fish | source
end

if type -q bat
    set -x BAT_THEME "Catppuccin Mocha"
    alias man="batman"
end

if type -q dust
    alias du="dust"
end

# Abbreviations, advantage over aliases is that they show as full command in history

# GIT abbreviations
abbr -a g git
abbr -a gs git status
abbr -a ga git add
abbr -a gp git push
abbr -a gc --set-cursor 'git commit -m "%"'
abbr -a gca --position command --set-cursor --function __aiva_commit

# Docker and Kubernetes abbreviations
abbr -a k kubectl
abbr -a d docker
abbr -a dcup 'docker-compose up -d'

if type -q paru
    abbr -a p paru
    abbr -a pi --set-cursor 'paru -S %'
end

# WARNING: I am not sure if the following aliases cover all cases, use with caution

if type -q zeditor
    abbr -a zed zeditor
end

if type -q dog
    alias dig="dog"
end
