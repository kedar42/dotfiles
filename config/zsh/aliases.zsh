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

alias gurl='curl --compressed'

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

alias y='xclip -selection clipboard -in'
alias p='xclip -selection clipboard -out'


if (( $+commands[exa] )); then
  alias ls="exa --group-directories-first --git --icons";
  alias l="ls -blaF";
  alias ll="ls -abghilmu";
  alias tree='exa --tree'
fi

if (( $+commands[fasd] )); then
  # fuzzy completion with 'z' when called without args
  unalias z 2>/dev/null
  function z {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  }
fi

autoload -U zmv

function take {
  mkdir "$1" && cd "$1";
}; compdef take=mkdir

function zman {
  PAGER="less -g -I -s '+/^       "$1"'" man zshall;
}

# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function r {
  local time=$1; shift
  sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched
