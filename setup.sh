#!/bin/bash

# Get the directory of the setup script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up Strix OS Package Manager..."

# Make sure directories exist
mkdir -p "$SCRIPT_DIR/modules"
mkdir -p "$SCRIPT_DIR/.strix_db"

# Make scripts executable
chmod +x "$SCRIPT_DIR/strix" 2>/dev/null || echo "Warning: strix script not found"
chmod +x "$SCRIPT_DIR/update.sh" 2>/dev/null || echo "Warning: update script not found"

# Create strix-manager.sh if it doesn't exist or make it executable
if [ -f "$SCRIPT_DIR/modules/strix-manager.sh" ]; then
    chmod +x "$SCRIPT_DIR/modules/strix-manager.sh"
else
    mkdir -p "$SCRIPT_DIR/modules"
    # Copy the strix-manager.sh code here...
    echo '#!/bin/bash
# Strix OS Package Manager Core
# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STRIX_ROOT="$( dirname "$SCRIPT_DIR" )"
# Locations
DB_DIR=$STRIX_ROOT/.strix_db
MODULES_DIR=$STRIX_ROOT/modules
INSTALLED_DB=$DB_DIR/installed.list
LOCK_FILE=$DB_DIR/manager.lock
# Initialize database
function init_db() {
    mkdir -p $DB_DIR
    touch $INSTALLED_DB
}
# Rest of the manager code...
' > "$SCRIPT_DIR/modules/strix-manager.sh"
    chmod +x "$SCRIPT_DIR/modules/strix-manager.sh"
fi

# Function to create a module
create_module() {
    NAME=$1
    DESC=$2
    INSTALL_CMD=$3
    
    MODULE_DIR="$SCRIPT_DIR/modules/$NAME"
    mkdir -p "$MODULE_DIR"
    
    # Create info.txt
    echo "$DESC" > "$MODULE_DIR/info.txt"
    
    # Create install.sh
    cat > "$MODULE_DIR/install.sh" << EOF
#!/bin/bash
echo "Installing $NAME..."
$INSTALL_CMD
echo "$NAME installed successfully!"
EOF
    chmod +x "$MODULE_DIR/install.sh"
    
    echo "Created module: $NAME"
}

# Create essential modules
create_module "gui-gnome" "GNOME Desktop Environment" "sudo apt update && sudo apt install -y gnome-shell ubuntu-gnome-desktop"
create_module "kali-tools" "Security and penetration testing tools" "sudo apt update && sudo apt install -y kali-tools-default"
create_module "ros2-humble" "ROS 2 Humble Hawksbill" "sudo apt update && sudo apt install -y curl && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu \$(. /etc/os-release && echo \$UBUNTU_CODENAME) main\" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null && sudo apt update && sudo apt install -y ros-humble-desktop"
create_module "vscode" "Visual Studio Code editor" "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && echo \"deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main\" | sudo tee /etc/apt/sources.list.d/vscode.list && sudo apt update && sudo apt install -y code"

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

# Initialize database
touch "$SCRIPT_DIR/.strix_db/installed.list"

echo "Setup complete. You can now use 'strix' from anywhere."
echo "Run 'strix list' to see available modules."
