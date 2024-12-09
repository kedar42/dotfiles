alias rm='rm -iv'
alias cp='cp -iv --reflink=auto'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'
alias ln='ln -v'
alias chmod="chmod -c"
alias chown="chown -c"
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

if (( $+commands[eza] )); then
  alias ls="eza --group-directories-first --git";
  alias l="eza -blF --icons";
  alias ll="eza -abghilmu";
  alias tree='eza --tree'
fi

