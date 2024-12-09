if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT='-c'
fi

unsetopt BEEP             # Hush now, quiet now
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

## Directories
DIRSTACKSIZE=9
unsetopt AUTO_CD            # Implicit CD slows down plugins
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
unsetopt PUSHD_TO_HOME      # Don't push to $HOME when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
unsetopt GLOB_DOTS
unsetopt AUTO_NAME_DIRS     # Don't add variable-stored paths to ~ list

if (( $+commands[fd] )); then
    export FZF_DEFAULT_OPTS="--reverse --ansi"
    export FZF_DEFAULT_COMMAND="fd ."
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d . $HOME"
fi

if (( $+commands[eza] )); then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
fi