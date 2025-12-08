function docker-shell --description "Open interactive shell in a running container"
    # Define options
    set -l options 'h/help'

    # Parse arguments
    argparse $options -- $argv
    or return 1

    # Show help if requested
    if set -q _flag_help
        echo "Usage: docker-shell [CONTAINER]"
        echo ""
        echo "Opens an interactive shell in a running container."
        echo "If no container specified, interactive selection is shown."
        echo ""
        echo "Options:"
        echo "  -h, --help     Show this help"
        return 0
    end

    # Check for too many arguments
    if test (count $argv) -gt 1
        echo "Error: Too many arguments" >&2
        echo "Usage: docker-shell [CONTAINER]" >&2
        return 1
    end

    set -l container_arg $argv[1]

    if set -q container_arg[1]
        # Direct mode - container name provided
        echo (set_color cyan)"Opening shell in container: $container_arg"(set_color normal)

        # Try bash first, fall back to sh
        docker exec -it $container_arg /bin/bash 2>/dev/null
        or docker exec -it $container_arg /bin/sh
    else
        # Interactive container selection with preview
        set -l preview_cmd '
        echo -e "\033[1;36mImage:\033[0m   $(docker inspect {} --format "{{.Config.Image}}")"
        echo -e "\033[1;36mStatus:\033[0m  $(docker inspect {} --format "{{.State.Status}}")"
        echo -e "\033[1;36mUptime:\033[0m  $(docker inspect {} --format "{{.State.StartedAt}}" | xargs -I{} date -d {} +"%Y-%m-%d %H:%M" 2>/dev/null || echo "N/A")"

        ports=$(docker port {} 2>/dev/null)
        if [ -n "$ports" ]; then
            echo -e "\033[1;36mPorts:\033[0m"
            echo "$ports" | sed "s/^/         /"
        else
            echo -e "\033[1;36mPorts:\033[0m   none"
        fi

        echo ""
        echo -e "\033[1;33mRunning processes:\033[0m"
        docker top {} -o pid,user,comm 2>/dev/null | head -11 || echo "  (none)"
        '

        set -l container (docker ps --format "{{.Names}}" | \
                         fzf --preview=$preview_cmd \
                             --preview-window=right:50%:wrap \
                             --prompt="Select container: " \
                             --ansi)

        if set -q container[1]
            echo (set_color cyan)"Opening shell in container: $container"(set_color normal)

            # Try bash first, fall back to sh
            docker exec -it $container /bin/bash 2>/dev/null
            or docker exec -it $container /bin/sh
        else
            echo (set_color brblack)"Cancelled."(set_color normal)
            return 1
        end
    end
end
