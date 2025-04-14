#!/bin/bash

# Get the directory of the setup script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up Strix OS Package Manager..."

# Make sure modules directory exists with default modules
mkdir -p "$SCRIPT_DIR/modules"

# Make sure all scripts are executable
chmod +x "$SCRIPT_DIR/strix"
chmod +x "$SCRIPT_DIR/update.sh"

# Find and make all module install scripts executable
find "$SCRIPT_DIR/modules" -name "*.sh" -exec chmod +x {} \;

# Make strix manager executable
chmod +x "$SCRIPT_DIR/modules/strix-manager.sh" 2>/dev/null || {
    # Create strix-manager.sh if it doesn't exist
    mkdir -p "$SCRIPT_DIR/modules"
    cat > "$SCRIPT_DIR/modules/strix-manager.sh" << 'EOF'
#!/bin/bash

# Strix OS Package Manager Core
# This script handles the core package management functionality

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STRIX_ROOT="$( dirname "$SCRIPT_DIR" )"

# Locations
DB_DIR=$STRIX_ROOT/.strix_db
MODULES_DIR=$STRIX_ROOT/modules
INSTALLED_DB=$DB_DIR/installed.list
LOCK_FILE=$DB_DIR/manager.lock

# Initialize database if it doesn't exist
function init_db() {
    mkdir -p $DB_DIR
    touch $INSTALLED_DB
}

# Lock the manager to prevent concurrent operations
function lock_manager() {
    if [ -f "$LOCK_FILE" ]; then
        echo "Another strix manager operation is in progress. Please try again later."
        exit 1
    fi
    touch $LOCK_FILE
}

# Unlock the manager
function unlock_manager() {
    if [ -f "$LOCK_FILE" ]; then
        rm $LOCK_FILE
    fi
}

# Register a module as installed
function register_module() {
    MODULE=$1
    init_db
    lock_manager
    
    # Check if module is already registered
    if grep -q "^$MODULE$" $INSTALLED_DB; then
        echo "Module $MODULE is already registered."
    else
        echo "$MODULE" >> $INSTALLED_DB
        echo "Module $MODULE registered successfully."
    fi
    
    unlock_manager
}

# Unregister a module (mark as uninstalled)
function unregister_module() {
    MODULE=$1
    init_db
    lock_manager
    
    # Check if module is registered
    if grep -q "^$MODULE$" $INSTALLED_DB; then
        grep -v "^$MODULE$" $INSTALLED_DB > $INSTALLED_DB.tmp
        mv $INSTALLED_DB.tmp $INSTALLED_DB
        echo "Module $MODULE unregistered successfully."
    else
        echo "Module $MODULE is not registered."
    fi
    
    unlock_manager
}

# Check module installation status
function module_status() {
    MODULE=$1
    init_db
    
    # Check if module exists
    if [ ! -d "$MODULES_DIR/$MODULE" ]; then
        echo "Module $MODULE not found in repository."
        return
    fi
    
    # Check if module is installed
    if grep -q "^$MODULE$" $INSTALLED_DB; then
        echo "Module $MODULE is installed."
    else
        echo "Module $MODULE is available but not installed."
    fi
    
    # Display module information if available
    if [ -f "$MODULES_DIR/$MODULE/info.txt" ]; then
        echo "--- Module Information ---"
        cat "$MODULES_DIR/$MODULE/info.txt"
    fi
}

# List all installed modules
function list_installed() {
    init_db
    echo "Installed modules:"
    cat $INSTALLED_DB
}

# Check for module dependencies
function check_dependencies() {
    MODULE=$1
    DEP_FILE="$MODULES_DIR/$MODULE/dependencies.txt"
    
    if [ -f "$DEP_FILE" ]; then
        echo "Checking dependencies for $MODULE..."
        while read -r dep; do
            if ! grep -q "^$dep$" $INSTALLED_DB; then
                echo "Dependency $dep is required but not installed."
                echo "Install it using: strix install $dep"
            fi
        done < "$DEP_FILE"
    fi
}

# Command actions
case "$1" in
    register)
        if [ -z "$2" ]; then
            echo "Please specify a module to register."
        else
            register_module $2
        fi
        ;;
    unregister)
        if [ -z "$2" ]; then
            echo "Please specify a module to unregister."
        else
            unregister_module $2
        fi
        ;;
    status)
        if [ -z "$2" ]; then
            echo "Please specify a module to check status."
        else
            module_status $2
        fi
        ;;
    list-installed)
        list_installed
        ;;
    check-deps)
        if [ -z "$2" ]; then
            echo "Please specify a module to check dependencies."
        else
            check_dependencies $2
        fi
        ;;
    *)
        echo "Usage: strix-manager.sh {register|unregister|status|list-installed|check-deps} <module>"
        ;;
esac
EOF
    chmod +x "$SCRIPT_DIR/modules/strix-manager.sh"
}

# Create basic modules if they don't exist
function create_module() {
    MODULE_NAME=$1
    MODULE_DESC=$2
    INSTALL_SCRIPT=$3
    
    mkdir -p "$SCRIPT_DIR/modules/$MODULE_NAME"
    
    # Create info.txt
    echo "$MODULE_DESC" > "$SCRIPT_DIR/modules/$MODULE_NAME/info.txt"
    
    # Create install.sh
    echo "#!/bin/bash" > "$SCRIPT_DIR/modules/$MODULE_NAME/install.sh"
    echo "" >> "$SCRIPT_DIR/modules/$MODULE_NAME/install.sh"
    echo "echo \"Installing $MODULE_NAME...\"" >> "$SCRIPT_DIR/modules/$MODULE_NAME/install.sh"
    echo "" >> "$SCRIPT_DIR/modules/$MODULE_NAME/install.sh"
    echo "$INSTALL_SCRIPT" >> "$SCRIPT_DIR/modules/$MODULE_NAME/install.sh"
    echo "" >> "$SCRIPT_DIR/modules/$MODULE_NAME/install.sh"
    echo "echo \"$MODULE_NAME installed successfully!\"" >> "$SCRIPT_DIR/modules/$MODULE_NAME/install.sh"
    
    chmod +x "$SCRIPT_DIR/modules/$MODULE_NAME/install.sh"
}

# Create modules if they don't exist
[ -d "$SCRIPT_DIR/modules/gui-gnome" ] || create_module "gui-gnome" "GNOME Desktop Environment" "sudo apt update && sudo apt install -y gnome-shell ubuntu-gnome-desktop"
[ -d "$SCRIPT_DIR/modules/kali-tools" ] || create_module "kali-tools" "Kali Linux security tools" "sudo apt update && sudo apt install -y kali-tools-default"
[ -d "$SCRIPT_DIR/modules/ros2-humble" ] || create_module "ros2-humble" "ROS 2 Humble Hawksbill" "sudo apt update && sudo apt install -y curl gnupg lsb-release && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main\" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null && sudo apt update && sudo apt install -y ros-humble-desktop"
[ -d "$SCRIPT_DIR/modules/vscode" ] || create_module "vscode" "Visual Studio Code editor" "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && echo \"deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main\" | sudo tee /etc/apt/sources.list.d/vscode.list && sudo apt update && sudo apt install -y code"

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
echo "Strix command is now available system-wide."

# Initialize the database
mkdir -p "$SCRIPT_DIR/.strix_db"
touch "$SCRIPT_DIR/.strix_db/installed.list"

echo "Setup complete. You can now use 'strix' from anywhere."
