# "Safety" aliases    
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'
alias ln='ln -v'
#alias chmod="chmod -c"
#alias chown="chown -c"
#alias wget='wget -c'

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

# More modern tools
if (( $+commands[eza] )); then
  alias ls="eza --group-directories-first --git";
  alias l="eza -blF --icons";
  alias ll="eza -abghilmu";
  alias tree='eza --tree'
fi

#### Experimental ####

# Experimental aliases might be removed if I don't find them useful.
alias g='git'
alias dc='docker-compose'
alias k='kubectl'
alias tf='terraform'
alias py='python3'

# More modern tools that might cause breakage in some cases !!!

# fd
if (( $+commands[fd] )); then
  alias find='fd'
fi

# ripgrep
if (( $+commands[rg] )); then
  alias grep='rg'
fi
