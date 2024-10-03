# safety reasons
alias rm='rm -iv'
alias cp='cp -iv --reflink=auto'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'
alias ln='ln -v'
alias chmod="chmod -c"
alias chown="chown -c"
alias wget='wget -c'
alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

# pretty ls

alias ls="eza --group-directories-first";
alias l="ls -blaF";
alias ll="ls -abghilmu";
alias tree='eza --tree'
