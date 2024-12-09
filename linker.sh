#!/usr/bin/bash

# Path to the routes file
ROUTES_FILE="routes.txt"

# Check if routes file exists
if [[ ! -f "$ROUTES_FILE" ]]; then
    echo "Error: Routes file '$ROUTES_FILE' not found."
    exit 1
fi

# Function to safely backup a file or directory
safe_backup() {
    local target="$1"
    local backup_base="${target}.bak"
    local backup="$backup_base"
    local counter=1

    # Create unique backup name
    while [[ -e "$backup" ]]; do
        backup="${backup_base}${counter}"
        ((counter++))
    done

    # Backup the item
    if [[ -d "$target" ]]; then
        echo "Backing up directory: $target -> $backup"
        # Use a temporary location for the backup to avoid nesting
        temp_backup="/tmp/$(basename "$target").bak"
        cp -r "$target" "$temp_backup"
        mv "$temp_backup" "$backup"
        rm -rf "$target"
    elif [[ -f "$target" ]]; then
        echo "Backing up file: $target -> $backup"
        mv "$target" "$backup"
    fi
}

update() {
    # check if git is installed
    if ! command -v git &> /dev/null; then
        echo "Error: git is not installed. How did you even get here?"
        exit 1
    fi

    # check if the current directory is a git repository
    if ! git rev-parse --is-inside-work-tree &> /dev/null; then
        echo "Error: Not a git repository. Please run this script from the root of the repository."
        exit 1
    fi

    # check if the repository is clean
    if ! git diff-index --quiet HEAD --; then
        echo "Error: Repository is dirty. Please commit or stash your changes before updating."
        exit 1
    fi

    # pull the latest changes
    git pull
}

validate_routes() {
    local source_base="$(pwd)/config"  # Base directory for sources
    local valid=true

    echo "Validating routes file: $ROUTES_FILE"
    
    while read -r source_path target_path; do
        # Skip empty lines or comments
        [[ -z "$source_path" || "$source_path" == \#* ]] && continue

        # Construct full source path
        full_source="${source_base}/${source_path}"

        # Check if the source exists
        if [[ ! -e "$full_source" ]]; then
            echo "Error: Source path '$full_source' does not exist."
            valid=false
        fi
    done < "$ROUTES_FILE"

    if $valid; then
        echo "Validation successful: All sources exist."
        return 0
    else
        echo "Validation failed: One or more sources are missing."
        return 1
    fi
}

# Function to create symlinks
create_symlinks() {
    local source_base="$(pwd)/config"  # Current directory (repo root)

    # Read routes file line by line
    while read -r source_path target_path; do
        # Skip empty lines or comments
        [[ -z "$source_path" || "$source_path" == \#* ]] && continue

        # Construct full source and target paths
        full_source="${source_base}/${source_path}"
        full_target="${HOME}/${target_path}"

        # Check if source exists
        if [[ ! -e "$full_source" ]]; then
            echo "Warning: Source path '$full_source' does not exist. Skipping."
            continue
        fi

        # Handle directories
        if [[ -d "$full_source" ]]; then
            echo "Processing directory: $full_source"

            # Create target directory if it doesn't exist
            mkdir -p "$full_target"

            # Iterate over items in the source directory
            for item in "$full_source"/*; do
                local item_name="$(basename "$item")"
                local target_item="$full_target/$item_name"

                # Backup existing files or directories in the target
                if [[ -e "$target_item" ]]; then
                    safe_backup "$target_item"
                fi

                # Create symlink for each item
                ln -s "$item" "$target_item"
                echo "Created symlink: $item -> $target_item"
            done
        else
            # Handle files
            mkdir -p "$(dirname "$full_target")"

            # Backup existing file or symlink
            if [[ -e "$full_target" || -L "$full_target" ]]; then
                safe_backup "$full_target"
            fi

            # Create symlink
            ln -s "$full_source" "$full_target"
            echo "Created symlink: $full_source -> $full_target"
        fi
    done < "$ROUTES_FILE"
}

# Function to remove all symlinks created by this script
remove_symlinks() {
    local source_base="$(pwd)/config"

    # Read routes file line by line
    while read -r source_path target_path; do
        # Skip empty lines or comments
        [[ -z "$source_path" || "$source_path" == \#* ]] && continue

        full_target="${HOME}/${target_path}"

        # Handle directories
        if [[ -d "$full_target" && ! -L "$full_target" ]]; then
            echo "Restoring directory contents in: $full_target"

            # Remove symlinks and restore backups inside the directory
            for item in "$full_target"/*; do
                if [[ -L "$item" ]]; then
                    echo "Removing symlink: $item"
                    rm "$item"

                    # Look for backup files
                    backup_item="${item}.bak"
                    if [[ -e "$backup_item" ]]; then
                        echo "Restoring backup: $backup_item -> $item"
                        mv "$backup_item" "$item"
                    fi
                fi
            done
        elif [[ -L "$full_target" ]]; then
            # Remove symlink
            echo "Removing symlink: $full_target"
            rm -f "$full_target"

            # Restore backup if available
            backup_files=("$full_target".bak*)
            for backup_file in "${backup_files[@]}"; do
                if [[ -e "$backup_file" ]]; then
                    echo "Restoring backup: $backup_file -> $full_target"
                    mv "$backup_file" "$full_target"
                    break
                fi
            done
        fi
    done < "$ROUTES_FILE"
}

help() {
    echo "install: Create symlinks for all files and directories listed in $ROUTES_FILE"
    echo "remove: Remove all symlinks created by this script"
    echo "validate: Check if all sources listed in $ROUTES_FILE exist"
    echo "update: Pull the latest changes from the git repository"
}

# Parse command-line arguments
case "$1" in
    validate)
        validate_routes
        ;;
    install)
        create_symlinks
        ;;
    remove)
        remove_symlinks
        ;;
    update)
        update
        ;;
    *)
        echo "Usage: $0 {install|remove|validate|update}"
        exit 1
        ;;
esac
