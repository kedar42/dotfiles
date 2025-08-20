#!/bin/bash

# Dotfiles Installation Script
# This script installs the required tools for the dotfiles configuration

set -e

echo "🚀 Dotfiles Installation Script"
echo "==============================="

# Detect the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v pacman &> /dev/null; then
        OS="arch"
    elif command -v apt &> /dev/null; then
        OS="debian"
    else
        OS="linux"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo "❌ Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "📋 Detected OS: $OS"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install packages on Arch Linux
install_arch() {
    echo "📦 Installing packages for Arch Linux..."
    
    # Core packages available in official repos
    PACMAN_PACKAGES="bat eza fd ripgrep zoxide fzf neovim fish git-delta yazi stow starship bat-extras dust"
    
    echo "Installing packages with pacman: $PACMAN_PACKAGES"
    sudo pacman -S --needed $PACMAN_PACKAGES
    
    # Check if ghostty is available, otherwise suggest AUR
    if ! pacman -Q ghostty &> /dev/null; then
        echo "⚠️  Ghostty not found in official repos. You may need to install it from AUR:"
        echo "   paru -S ghostty-git"
    fi
    
    echo "✅ Arch Linux packages installed successfully!"
}

# Function to install packages on macOS
install_macos() {
    echo "📦 Installing packages for macOS..."
    
    if ! command_exists brew; then
        echo "❌ Homebrew not found. Please install Homebrew first:"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    
    BREW_PACKAGES="bat eza fd ripgrep zoxide fzf neovim fish git-delta yazi stow starship dust"
    
    echo "Installing packages with brew: $BREW_PACKAGES"
    brew install $BREW_PACKAGES
    
    echo "Installing bat-extras..."
    brew install eth-p/software/bat-extras
    
    echo "⚠️  Please install Ghostty manually from: https://ghostty.org/"
    echo "✅ macOS packages installed successfully!"
}

# Function to install packages on Debian/Ubuntu
install_debian() {
    echo "📦 Installing packages for Debian/Ubuntu..."
    
    sudo apt update
    
    # Packages available in standard repos
    APT_PACKAGES="bat fd-find ripgrep fzf neovim fish git-delta stow"
    
    echo "Installing packages with apt: $APT_PACKAGES"
    sudo apt install -y $APT_PACKAGES
    
    echo "⚠️  Some tools may need manual installation:"
    echo "   - eza: https://github.com/eza-community/eza"
    echo "   - zoxide: https://github.com/ajeetdsouza/zoxide"
    echo "   - yazi: https://github.com/sxyazi/yazi"
    echo "   - starship: https://starship.rs/"
    echo "   - dust: https://github.com/bootandy/dust"
    echo "   - ghostty: https://ghostty.org/"
    echo "   - bat-extras: https://github.com/eth-p/bat-extras"
    
    echo "✅ Debian/Ubuntu packages installed successfully!"
}

# Main installation logic
case $OS in
    arch)
        install_arch
        ;;
    macos)
        install_macos
        ;;
    debian)
        install_debian
        ;;
    *)
        echo "❌ Unsupported OS for automatic installation: $OS"
        echo "Please refer to the README.md for manual installation instructions."
        exit 1
        ;;
esac

echo ""
echo "🎉 Tool installation completed!"
echo ""
echo "📋 Next steps:"
echo "1. Set up the dotfiles:"
echo "   stow --dotfiles --no-folding --adopt -t ~ home"
echo "   git reset --hard"
echo ""
echo "2. Change your terminal's shell to fish (don't set it as default system shell)"
echo ""
echo "3. Restart your terminal and enjoy your new setup!"