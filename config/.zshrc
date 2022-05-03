# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/kedar/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

autoload -U promptinit; promptinit
zstyle ':completion:*' menu select

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# aliases
alias ls='exa -l --color=always --group-directories-first'
alias ll='exa -la --color=always --group-directories-first'
alias vim='nvim'
alias doom='~/.emacs.d/bin/doom'
alias dotfiles='~/Documents/dotfiles/dotfiles'

eval "$(starship init zsh)"
