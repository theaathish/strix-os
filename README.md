![Navy Blue And Red Modern YouTube Banner](https://github.com/user-attachments/assets/56cbbccc-b1d7-4faa-9d03-1a3ca85928ac)

# Strix OS Package Manager

The Strix OS Package Manager is a powerful, cross-distribution tool that simplifies installing software packages, modules, and developer tools with a unified interface.

## Features

- **Universal package installation** - Works with native package managers (apt, dnf, pacman)
- **ROS package integration** - Direct installation of ROS packages
- **Module system** - Pre-configured module bundles for specific use cases
- **Auto-OS detection** - Automatically uses the appropriate package manager for your system
- **Smart fallback** - Falls back to system package manager when modules aren't available

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/theaathish/strix-os.git
   cd strix-os
   ```

2. Set up the Strix package manager:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   source ~/.bashrc  # Apply the PATH changes
   ```

## Usage

### Basic Commands

```bash
# Install any package (tries module, then system package manager)
strix install <package-name>

# Install ROS packages with automatic dependency handling
strix ros-install <ros-package-name>

# Uninstall a module or package
strix uninstall <module-name>

# Update the Strix package manager
strix update

# List available modules
strix list

# Search for packages
strix search <keyword>

# Check installation status
strix status <module-name>

# Display help
strix help
```

### Example Usage

```bash
# Install common packages
strix install firefox
strix install vlc

# Install pre-configured modules
strix install gui-gnome
strix install kali-tools
strix install vscode

# Install ROS packages
strix ros-install turtlesim
strix ros-install rviz2

# Check status of installed modules
strix status ros2-humble
```

## Available Modules

- **gui-gnome**: GNOME Desktop Environment
- **kali-tools**: Security and penetration testing tools
- **ros2-humble**: Robot Operating System 2 Humble
- **vscode**: Visual Studio Code editor

## Supported Systems

The package manager automatically detects and works with:
- Ubuntu/Debian (apt)
- Fedora/RHEL (dnf)
- Arch Linux (pacman)

## Troubleshooting

If you encounter issues:

1. Update the modules:
   ```bash
   strix update
   ```

2. Check if modules are properly initialized:
   ```bash
   strix list
   ```

3. Try installing packages directly:
   ```bash
   strix install <package-name>
   ```

## License
This project is licensed under the MIT License - see the LICENSE file for details.
