function docker-clean-containers --description "Remove all stopped containers"
    # Define options
    set -l options 'h/help' 'f/force'

    # Parse arguments
    argparse $options -- $argv
    or return 1

    # Show help if requested
    if set -q _flag_help
        echo "Usage: docker-clean-containers [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  -f, --force    Skip confirmation prompt"
        echo "  -h, --help     Show this help"
        return 0
    end

    set -l containers (docker ps -a -q -f status=exited)

    if set -q containers[1]
        echo (set_color yellow --bold)"Stopped containers to remove:"(set_color normal)
        docker ps -a -f status=exited --format "  "(set_color cyan)"{{.ID}}"(set_color normal)"  {{.Names}}  "(set_color brblack)"({{.Status}})"(set_color normal)
        echo ""

        if not set -q _flag_force
            read -l -P "Remove these containers? [y/N] " confirm
            if test "$confirm" != y; and test "$confirm" != Y
                echo (set_color brblack)"Cancelled."(set_color normal)
                return 1
            end
        end

        echo (set_color green)"Removing stopped containers..."(set_color normal)
        docker rm $containers
        echo (set_color green --bold)"Done!"(set_color normal)
    else
        echo (set_color brblack)"No stopped containers to remove"(set_color normal)
    end
end
