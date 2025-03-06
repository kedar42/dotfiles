function fish_greeting
    #if type -q neofetch
    #    neofetch
    #end
end

fish_add_path /opt/homebrew/bin

function fish_user_key_bindings
    bind \t complete
end

set -x SSH_AUTH_SOCK /Users/$USER/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

starship init fish | source
enable_transience
