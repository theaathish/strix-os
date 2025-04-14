#!/bin/bash

# Get the directory of the setup script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up Strix OS Package Manager..."

# Make all scripts executable
chmod +x "$SCRIPT_DIR/strix" 2>/dev/null || echo "Warning: strix script not found"
chmod +x "$SCRIPT_DIR/update.sh" 2>/dev/null || echo "Warning: update script not found"

# Add to PATH
if [ -z "$(grep 'strix-os' ~/.bashrc)" ]; then
    echo "# Strix OS PATH" >> ~/.bashrc
    echo "export PATH=\"\$PATH:$SCRIPT_DIR\"" >> ~/.bashrc
    echo "Strix OS has been added to your PATH."
    echo "Please run 'source ~/.bashrc' or restart your terminal to apply changes."
else
    echo "Strix OS is already in your PATH."
fi

# Create symlink in /usr/local/bin (requires sudo)
echo "Creating system-wide symlink (requires sudo)..."
sudo ln -sf "$SCRIPT_DIR/strix" /usr/local/bin/strix

# Run strix update to initialize modules
"$SCRIPT_DIR/strix" update

echo "Setup complete. You can now use 'strix' from anywhere."
echo "Run 'strix list' to see available modules."
