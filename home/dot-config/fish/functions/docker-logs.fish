function docker-logs --description "Docker logs with container selection and preview"
    # Define options for argparse
    set -l options 'h/help' 'f/follow' 'n/tail='

    # Parse arguments
    argparse $options -- $argv
    or return 1

    # Show help if requested
    if set -q _flag_help
        echo "Usage: docker-logs [OPTIONS] [CONTAINER...]"
        echo ""
        echo "Options:"
        echo "  -f, --follow       Follow log output (default behavior)"
        echo "  -n, --tail N       Number of lines to show (default: 100)"
        echo "  -h, --help         Show this help"
        echo ""
        echo "If no container specified, interactive selection is shown."
        return 0
    end

    # Set defaults
    set -l tail_lines 100
    if set -q _flag_tail
        set tail_lines $_flag_tail
    end

    # Remaining arguments are containers
    set -l containers $argv

    if set -q containers[1]
        # Direct mode - container name(s) provided
        if set -q _flag_follow
            if type -q bat
                docker logs -f --tail $tail_lines $containers 2>&1 | bat --paging=never --style=plain -l log
            else
                docker logs -f --tail $tail_lines $containers
            end
        else
            if type -q bat
                docker logs --tail $tail_lines $containers 2>&1 | bat --style=plain -l log
            else
                docker logs --tail $tail_lines $containers
            end
        end
    else
        # Interactive container selection with log preview
        set -l preview_cmd "docker logs --tail 50 {} 2>&1"
        if type -q bat
            set preview_cmd "docker logs --tail 50 {} 2>&1 | bat --color=always --style=plain -l log"
        end

        set -l container (docker ps -a --format "{{.Names}}" | \
            fzf --prompt="Select container for logs: " \
                --preview=$preview_cmd \
                --preview-window=right:60%:wrap \
                --ansi)

        if set -q container[1]
            if set -q _flag_follow
                if type -q bat
                    docker logs -f --tail $tail_lines $container 2>&1 | bat --paging=never --style=plain -l log
                else
                    docker logs -f --tail $tail_lines $container
                end
            else
                if type -q bat
                    docker logs --tail $tail_lines $container 2>&1 | bat --style=plain -l log
                else
                    docker logs --tail $tail_lines $container
                end
            end
        end
    end
end
