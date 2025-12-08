function docker-cleanup --description "Complete Docker cleanup (containers, images, volumes, networks)"
    # Define options
    set -l options 'h/help' 'f/force'

    # Parse arguments
    argparse $options -- $argv
    or return 1

    # Show help if requested
    if set -q _flag_help
        echo "Usage: docker-cleanup [OPTIONS]"
        echo ""
        echo "Removes stopped containers, dangling images, unused volumes,"
        echo "unused networks, and build cache."
        echo ""
        echo "Options:"
        echo "  -f, --force    Skip confirmation prompt"
        echo "  -h, --help     Show this help"
        return 0
    end

    echo "Docker Cleanup Summary"
    echo "========================="
    echo ""

    # Collect what will be cleaned
    set -l containers (docker ps -a -q -f status=exited)
    set -l images (docker images -q -f dangling=true)
    set -l volumes (docker volume ls -q -f dangling=true)

    set -l has_items 0

    # Show stopped containers
    if set -q containers[1]
        set has_items 1
        echo (set_color yellow --bold)"Stopped containers to remove:"(set_color normal)
        docker ps -a -f status=exited --format "  "(set_color cyan)"{{.ID}}"(set_color normal)"  {{.Names}}  "(set_color brblack)"({{.Status}})"(set_color normal)
        echo ""
    end

    # Show dangling images
    if set -q images[1]
        set has_items 1
        echo (set_color yellow --bold)"Dangling images to remove:"(set_color normal)
        docker images -f dangling=true --format "  "(set_color cyan)"{{.ID}}"(set_color normal)"  {{.Repository}}:{{.Tag}}  "(set_color brblack)"({{.Size}})"(set_color normal)
        echo ""
    end

    # Show unused volumes
    if set -q volumes[1]
        set has_items 1
        echo (set_color yellow --bold)"Unused volumes to remove:"(set_color normal)
        docker volume ls -f dangling=true --format "  "(set_color cyan)"{{.Name}}"(set_color normal)
        echo ""
    end

    # Show unused networks
    # Find custom networks without containers attached
    set -l networks (docker network ls --filter "type=custom" --format "{{.ID}}" | \
        while read -l id
            docker network inspect $id --format '{{if not .Containers}}{{.Name}}{{end}}'
        end | grep -v '^$')

    if set -q networks[1]
        set has_items 1
        echo (set_color yellow --bold)"Unused networks to remove:"(set_color normal)
        for network in $networks
            echo "  "(set_color cyan)"$network"(set_color normal)
        end
        echo ""
    end

    # Show build cache info
    echo (set_color yellow --bold)"Build cache will be pruned"(set_color normal)
    echo ""

    # If nothing to clean, exit early
    if test $has_items -eq 0
        echo "Nothing to clean up!"
        echo ""
        echo "Current Docker disk usage:"
        docker system df
        return 0
    end

    # Ask for confirmation
    echo "========================="

    if not set -q _flag_force
        read -l -P "Proceed with cleanup? [y/N] " confirm
        if test "$confirm" != y; and test "$confirm" != Y
            echo (set_color brblack)"Cancelled."(set_color normal)
            return 1
        end
    end

    echo ""
    echo "Starting cleanup..."
    echo ""

    # Remove stopped containers
    if set -q containers[1]
        echo "1. Removing stopped containers..."
        docker rm $containers
        echo ""
    end

    # Remove dangling images
    if set -q images[1]
        echo "2. Removing dangling images..."
        docker rmi $images
        echo ""
    end

    # Remove unused volumes
    echo "3. Removing unused volumes..."
    docker volume prune -f
    echo ""

    # Remove unused networks
    echo "4. Removing unused networks..."
    docker network prune -f
    echo ""

    # Remove build cache
    echo "5. Removing build cache..."
    docker builder prune -f
    echo ""

    echo (set_color green --bold)"Done!"(set_color normal)
    echo ""
    echo "Current Docker disk usage:"
    docker system df
end
