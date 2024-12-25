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
  
  # Oh My Zsh plugins
  zgenom ohmyzsh
  zgenom ohmyzsh ssh

  # plugins
  # zgenom load Aloxaf/fzf-tab
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-completions src
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-history-substring-search
  zgenom load romkatv/powerlevel10k powerlevel10k

  zgenom save
fi

ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30

# Completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case-insensitive matching
zstyle ':completion:*' menu select  # Interactive completion menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  # Colored completion menu
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt EXTENDED_GLOB       # Use extended globbing syntax.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt COMPLETE_ALIASES  # Disabling this enables completion for aliases
unsetopt CASE_GLOB

# Options
unsetopt BEEP
HISTORY_SUBSTRING_SEARCH_PREFIXED=1
HISTORY_SUBSTRING_SEARCH_FUZZY=1
HISTSIZE=100000   # Max events to store in internal history.
SAVEHIST=100000   # Max events to store in history file.
setopt BANG_HIST                 # History expansions on '!'
setopt EXTENDED_HISTORY          # Include start time in history records
setopt APPEND_HISTORY            # Appends history to history file on exit
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Remove old events if new event is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_REDUCE_BLANKS        # Minimize unnecessary whitespace
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.
setopt HIST_FCNTL_LOCK        # Use modern file-locking
setopt HIST_NO_STORE          # Don't store history commands
setopt HIST_SAVE_BY_COPY      # Safer history file writing
unsetopt AUTO_CD                  # Implicit CD slows down plugins

# "Safety" aliases    
alias rm='rm -Iv'
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

# More modern tools
if (( $+commands[eza] )); then
  alias ls="eza --group-directories-first --git";
  alias l="eza -blF --icons";
  alias ll="eza -abghilmu";
  alias tree='eza --tree'
fi

if (( $+commands[bat] )); then
  alias cat='bat'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

if (( $+commands[nvim] )); then
  alias vim='nvim'
  export EDITOR=nvim
fi

if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

eval "$(zoxide init --cmd cd zsh)"

cdmk() { mkdir -p $1 && cd $1 }
backup() { cp "$1"{,.bak}; }

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f $HOME/.config/zsh/.p10k.zsh ]] || source $HOME/.config/zsh/.p10k.zsh
