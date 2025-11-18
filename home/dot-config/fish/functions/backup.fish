function backup --description 'Create a backup copy of a file with .bak extension'
    if test (count $argv) -eq 0
        echo "Usage: backup <file>"
        return 1
    end

    if test -e $argv[1]
        cp "$argv[1]" "$argv[1].bak"
        echo "Created backup: $argv[1].bak"
    else
        echo "'$argv[1]' does not exist"
        return 1
    end
end
