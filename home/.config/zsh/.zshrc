# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## Bootstrap zgenom
export ZGEN_DIR="$HOME/.local/share/zgenom"
if [[ ! -d "$ZGEN_DIR" ]]; then
  echo "Installing jandamm/zgenom"
  git clone https://github.com/jandamm/zgenom "$ZGEN_DIR"
fi

source $ZGEN_DIR/zgenom.zsh

if ! zgenom saved; then
  echo "Creating zgenom save"
  
  zgenom ohmyzsh
  zgenom ohmyzsh ssh

  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-completions src
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load dxrcy/zsh-history-substring-search
  zgenom load romkatv/powerlevel10k powerlevel10k

  zgenom save
fi

ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"

# Options
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt EXTENDED_GLOB       # Use extended globbing syntax.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt COMPLETE_ALIASES  # Disabling this enables completion for aliases
unsetopt CASE_GLOB

alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'
alias ln='ln -v'
alias chmod="chmod -c"
alias chown="chown -c"
alias wget='wget -c'

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

if (( $+commands[eza] )); then
  alias ls="eza --group-directories-first --git";
  alias l="eza -blF --icons";
  alias ll="eza -abghilmu";
  alias tree='eza --tree'
fi

eval "$(zoxide init --cmd cd zsh)"
source <(fzf --zsh)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias vim="nvim"

test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh" || true

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
