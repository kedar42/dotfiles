function backup --description 'Create a backup copy of a file with .bak extension'
    if test (count $argv) -ne 1
        echo "Usage: backup <file>"
        return 1
    end

    if not test -f $argv[1]
        echo "'$argv[1]' is not a regular file"
        return 1
    end

    command cp -i -- $argv[1] "$argv[1].bak"
    and echo "Created backup: $argv[1].bak"
end
