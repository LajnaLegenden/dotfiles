#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if the 'op' command is already available
if command -v op &> /dev/null; then
    echo "✅ 1Password CLI is already installed."
    exit 0
fi

echo "1Password CLI not found. Attempting to install..."

# Detect the operating system
if [[ "$(uname -s)" == "Darwin" ]]; then
    ### macOS ###
    if command -v brew &> /dev/null; then
        echo "Installing 1Password CLI using Homebrew..."
        brew install 1password-cli
    else
        echo "Error: Homebrew is not installed. Please install Homebrew first." >&2
        exit 1
    fi

elif [[ "$(uname -s)" == "Linux" ]]; then
    if command -v pacman &> /dev/null; then
        ### Arch Linux ###
        echo "Arch Linux detected."

        # Install paru if not already installed
        if ! command -v paru &> /dev/null; then
            echo "AUR helper 'paru' not found. Installing..."
            sudo pacman -S --needed --noconfirm base-devel git
            git clone https://aur.archlinux.org/paru.git /tmp/paru
            (cd /tmp/paru && makepkg -si --noconfirm)
            rm -rf /tmp/paru
        fi

        echo "Installing 1password and 1password-cli using paru..."
        paru -S --noconfirm 1password 1password-cli

    elif command -v apt-get &> /dev/null; then
        ### Debian / Ubuntu ###
        echo "Installing 1Password CLI using apt..."
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
        echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
        sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
        curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
        sudo apt-get update && sudo apt-get install -y 1password-cli
    else
        echo "Error: Could not detect a supported Linux package manager (pacman or apt)." >&2
        exit 1
    fi
else
    echo "Error: Unsupported operating system '$(uname -s)'." >&2
    exit 1
fi

echo "✅ 1Password CLI installed successfully."
