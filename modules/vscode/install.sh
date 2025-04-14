#!/bin/bash

echo "Installing Visual Studio Code..."

# Import the Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

# Add the VS Code repository
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# Update package list and install VS Code
sudo apt update
sudo apt install -y code

echo "Visual Studio Code has been installed successfully!"
