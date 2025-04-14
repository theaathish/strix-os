#!/bin/bash

echo "Uninstalling Visual Studio Code..."

# Remove VS Code
sudo apt remove --purge -y code
sudo apt autoremove -y

# Remove the repository
sudo rm -f /etc/apt/sources.list.d/vscode.list
sudo rm -f /etc/apt/trusted.gpg.d/microsoft.gpg

echo "Visual Studio Code has been uninstalled."
