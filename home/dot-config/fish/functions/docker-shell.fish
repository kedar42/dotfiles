function docker-shell --description "Open interactive shell in a running container"
    set -l options 'h/help'
    argparse $options -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: docker-shell [CONTAINER]"
        return 0
    end

    if test (count $argv) -gt 1
        echo "Usage: docker-shell [CONTAINER]" >&2
        return 1
    end

    set -l container $argv[1]
    if not set -q container[1]
        if not command -sq fzf
            echo "fzf is required when no container is provided" >&2
            return 1
        end

        set container (command docker ps --format '{{.Names}}' | command fzf --prompt='Container shell: ')
        set -q container[1]; or return 1
    end

    command docker exec -it $container /bin/sh
end
