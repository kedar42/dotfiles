function fish_greeting
    #if type -q neofetch
    #    neofetch
    #end
end

fish_add_path /opt/homebrew/bin

function fish_user_key_bindings
    bind \t complete
end


starship init fish | source
enable_transience
