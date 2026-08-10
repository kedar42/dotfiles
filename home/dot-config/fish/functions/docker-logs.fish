function docker-logs --description "Docker logs with container selection and preview"
    set -l options 'h/help' 'f/follow' 'n/tail='
    argparse $options -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: docker-logs [OPTIONS] [CONTAINER]"
        echo ""
        echo "Options:"
        echo "  -f, --follow       Follow log output"
        echo "  -n, --tail N       Number of lines to show (default: 100)"
        echo "  -h, --help         Show this help"
        return 0
    end

    if test (count $argv) -gt 1
        echo "Usage: docker-logs [OPTIONS] [CONTAINER]" >&2
        return 1
    end

    set -l tail_lines 100
    if set -q _flag_tail
        if not string match -qr '^\d+$' $_flag_tail
            echo "Tail count must be a non-negative integer" >&2
            return 1
        end
        set tail_lines $_flag_tail
    end

    set -l container $argv[1]
    if not set -q container[1]
        if not command -sq fzf
            echo "fzf is required when no container is provided" >&2
            return 1
        end

        set container (command docker ps -a --format '{{.Names}}' | command fzf --prompt='Container logs: ')
        set -q container[1]; or return 1
    end

    set -l docker_args logs --tail $tail_lines
    if set -q _flag_follow
        set -a docker_args --follow
    end

    command docker $docker_args $container
end
