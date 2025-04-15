#!/bin/bash

echo "Uninstalling KiCad..."

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$ID
    OS_VERSION=$VERSION_ID
else
    echo "Could not detect operating system."
    exit 1
fi

# Uninstall based on detected OS
case $OS_NAME in
    ubuntu|linuxmint|debian)
        # Check if installed via Flatpak
        if flatpak list | grep -q org.kicad.KiCad; then
            echo "Removing KiCad Flatpak..."
            flatpak uninstall -y org.kicad.KiCad
        else
            echo "Removing KiCad package..."
            sudo apt remove --purge -y kicad kicad-*
            # Clean up PPA if present
            if [ -f /etc/apt/sources.list.d/kicad-ubuntu-kicad-9_0-releases-*.list ]; then
                echo "Removing KiCad PPA..."
                sudo add-apt-repository -y --remove ppa:kicad/kicad-9.0-releases
            fi
        fi
        ;;
        
    fedora)
        echo "Removing KiCad for Fedora..."
        sudo dnf remove -y kicad kicad-packages3d kicad-doc
        ;;
        
    arch|manjaro)
        echo "Removing KiCad for Arch Linux..."
        sudo pacman -R --noconfirm kicad kicad-library kicad-library-3d
        ;;
        
    opensuse*)
        echo "Removing KiCad for openSUSE..."
        sudo zypper remove -y kicad
        # Remove the repository
        sudo zypper removerepo electronics
        ;;
        
    *)
        # Try to uninstall flatpak
        echo "Attempting to uninstall KiCad Flatpak..."
        flatpak uninstall -y org.kicad.KiCad
        ;;
esac

echo "KiCad has been uninstalled successfully."
