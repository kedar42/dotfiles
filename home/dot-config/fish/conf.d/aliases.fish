
if type -q nvim
    set -gx EDITOR nvim
    alias vi nvim
    alias vim nvim
end

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
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# Abbreviations, advantage over aliases is that they show as full command in history

abbr -a g git
abbr -a gcm --set-cursor 'git commit -m "%"'
abbr -a gcma --position command --set-cursor --function __aiva_commit
