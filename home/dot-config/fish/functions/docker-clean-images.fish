function docker-clean-images --description "Remove dangling images"
    # Define options
    set -l options 'h/help' 'f/force'

    # Parse arguments
    argparse $options -- $argv
    or return 1

    # Show help if requested
    if set -q _flag_help
        echo "Usage: docker-clean-images [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  -f, --force    Skip confirmation prompt"
        echo "  -h, --help     Show this help"
        return 0
    end

    set -l images (docker images -q -f dangling=true)

    if set -q images[1]
        echo (set_color yellow --bold)"Dangling images to remove:"(set_color normal)
        docker images -f dangling=true --format "  "(set_color cyan)"{{.ID}}"(set_color normal)"  {{.Repository}}:{{.Tag}}  "(set_color brblack)"({{.Size}})"(set_color normal)
        echo ""

        if not set -q _flag_force
            read -l -P "Remove these images? [y/N] " confirm
            if test "$confirm" != y; and test "$confirm" != Y
                echo (set_color brblack)"Cancelled."(set_color normal)
                return 1
            end
        end

        echo (set_color green)"Removing dangling images..."(set_color normal)
        docker rmi $images
        echo (set_color green --bold)"Done!"(set_color normal)
    else
        echo (set_color brblack)"No dangling images to remove"(set_color normal)
    end
end
