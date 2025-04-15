#!/bin/bash

echo "Installing KiCad Electronic Design Automation suite..."

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$ID
    OS_VERSION=$VERSION_ID
else
    echo "Could not detect operating system."
    exit 1
fi

echo "Detected OS: $OS_NAME $OS_VERSION"

# Install based on detected OS
case $OS_NAME in
    ubuntu|linuxmint|debian)
        echo "Installing KiCad for Ubuntu/Debian-based system..."
        
        # Check if flatpak is requested
        if [ "$1" == "flatpak" ]; then
            echo "Installing via Flatpak..."
            sudo apt update
            sudo apt install -y flatpak
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak install -y --noninteractive flathub org.kicad.KiCad
        else
            # Default to PPA for Ubuntu
            echo "Adding KiCad PPA and installing..."
            sudo add-apt-repository -y ppa:kicad/kicad-9.0-releases
            sudo apt update
            sudo apt install -y kicad
        fi
        ;;
        
    fedora)
        echo "Installing KiCad for Fedora..."
        sudo dnf install -y kicad kicad-packages3d kicad-doc
        ;;
        
    arch|manjaro)
        echo "Installing KiCad for Arch Linux..."
        sudo pacman -Syu --noconfirm kicad kicad-library kicad-library-3d
        ;;
        
    opensuse*)
        echo "Installing KiCad for openSUSE..."
        sudo zypper addrepo -f https://download.opensuse.org/repositories/electronics/openSUSE_Tumbleweed/electronics.repo
        sudo zypper refresh
        sudo zypper install -y kicad
        ;;
        
    *)
        # Try to use flatpak for other distributions
        echo "Unknown distribution. Trying Flatpak installation..."
        
        # Check if flatpak is installed, if not try to install it
        if ! command -v flatpak &> /dev/null; then
            echo "Flatpak not found. Attempting to install Flatpak..."
            
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y flatpak
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y flatpak
            elif command -v pacman &> /dev/null; then
                sudo pacman -Syu --noconfirm flatpak
            else
                echo "Cannot install Flatpak automatically. Please install Flatpak manually and try again."
                exit 1
            fi
        fi
        
        # Add Flathub repository if it doesn't exist
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        
        # Install KiCad
        flatpak install -y --noninteractive flathub org.kicad.KiCad
        ;;
esac

echo "KiCad has been installed successfully!"
echo "You can launch KiCad from your application menu or by running 'kicad' in terminal."
