#!/bin/bash

echo "Setting up Strix OS Package Manager..."

# Make strix executable
chmod +x $(pwd)/strix

# Add to PATH
if [ -z "$(grep 'strix-os' ~/.bashrc)" ]; then
    echo "# Strix OS PATH" >> ~/.bashrc
    echo "export PATH=\"\$PATH:$(pwd)\"" >> ~/.bashrc
    echo "Strix OS has been added to your PATH."
    echo "Please run 'source ~/.bashrc' or restart your terminal to apply changes."
else
    echo "Strix OS is already in your PATH."
fi

# Create symlink in /usr/local/bin (requires sudo)
echo "Creating system-wide symlink (requires sudo)..."
sudo ln -sf $(pwd)/strix /usr/local/bin/strix
echo "Strix command is now available system-wide."

echo "Setup complete. You can now use 'strix' from anywhere."
