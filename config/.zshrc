# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
export EDITOR='nvim'

autoload -U promptinit; promptinit
zstyle ':completion:*' menu select

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# aliases
alias ls='exa --icons --color=always --group-directories-first'
alias ll='exa -l --icons --color=always --group-directories-first'
alias l='exa -al --icons --color=always --git --group-directories-first'
alias vi='nvim'
alias vim='nvim'
alias doom='~/.emacs.d/bin/doom'
alias dotfiles='~/Documents/dotfiles/dotfiles'
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
