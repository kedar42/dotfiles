function extract --description 'Extract various archive formats'
    if test (count $argv) -ne 1
        echo "Usage: extract <archive_file>"
        return 1
    end

    if not test -f $argv[1]
        echo "'$argv[1]' is not a valid file"
        return 1
    end

    switch $argv[1]
        case '*.tar' '*.tar.*' '*.tgz' '*.tbz2' '*.txz'
            command tar xf $argv[1]
        case '*.zip'
            command unzip $argv[1]
        case '*.7z'
            command 7z x $argv[1]
        case '*.rar'
            command unrar x $argv[1]
        case '*'
            echo "'$argv[1]' is not a supported archive"
            return 1
    end
end
