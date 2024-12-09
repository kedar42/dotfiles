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
unsetopt FLOW_CONTROL        # Redundant with tmux
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt COMPLETE_ALIASES  # Disabling this enables completion for aliases
unsetopt CASE_GLOB

ZCOMPCACHE="$XDG_CACHE_HOME/zsh/zcompdump.$ZSH_VERSION"
if autoload -Uz compinit; then
  compinit -u -C -d "$ZCOMPCACHE"
  [[ ! -f "$ZCOMPCACHE.zwc" && -f $ZCOMPCACHE ]] && zcompile "$ZCOMPCACHE"
fi