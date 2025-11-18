
# Safety aliases - interactive prompts and verbose output
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'
alias ln='ln -v'

# System management
alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

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
    set -x BAT_THEME "Catppuccin Mocha"
    alias man="batman"
end

if type -q dust
    alias du="dust"
end

# Abbreviations, advantage over aliases is that they show as full command in history

abbr -a g git
abbr -a gs git status
abbr -a ga git add
abbr -a gp git push
abbr -a gl git pull
abbr -a gd git diff
abbr -a gcm --set-cursor 'git commit -m "%"'
abbr -a gcma --position command --set-cursor --function __aiva_commit
abbr -a k kubectl
abbr -a d docker
abbr -a dc docker-compose
abbr -a dcup 'docker-compose up -d'

if type -q paru
    abbr -a p paru
    abbr -a pi --set-cursor 'paru -S %'
end

# WARNING: I am not sure if the following aliases cover all cases, use with caution

if type -q dog
    alias dig="dog"
end
