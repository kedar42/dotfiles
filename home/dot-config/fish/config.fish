fish_add_path --global $HOME/.local/bin $HOME/.dotnet/tools

if test -d /opt/homebrew/bin
    fish_add_path --global /opt/homebrew/bin
end

if type -q nvim
    set -gx EDITOR nvim
end

set -l local_env_dir $HOME/.config/local/env.d
if test -d $local_env_dir
    for env_file in $local_env_dir/*
        test -f $env_file; and not test -L $env_file; or continue

        set -l env_name (string replace -r '^.*/' '' -- $env_file)
        string match -qr '^[A-Za-z_][A-Za-z0-9_]*$' -- $env_name; or continue
        set -gx $env_name (string collect < $env_file)
    end
end

status is-interactive; or return

if command -sq fnm
    command fnm env --use-on-cd --shell fish | source
end

if command -sq fzf
    command fzf --fish | source
end

if command -sq starship
    command starship init fish | source
end

if command -sq eza
    alias ls="eza --group-directories-first --git --icons=auto"
    alias l="eza -blF --group-directories-first --icons=auto"
    alias ll="eza -abghilmu --git --icons=auto"
    alias tree="eza --tree --group-directories-first --icons=auto"
end

if command -sq nvim
    alias vi nvim
    alias vim nvim
end

abbr -a g git
abbr -a gs git status
abbr -a ga git add
abbr -a gp git push
abbr -a gl git pull
abbr -a gd git diff
abbr -a gcm --set-cursor 'git commit -m "%"'
abbr -a k kubectl
abbr -a d docker
abbr -a dc 'docker compose'
abbr -a dcup 'docker compose up -d'
