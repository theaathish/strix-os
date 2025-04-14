![Navy Blue And Red Modern YouTube Banner](https://github.com/user-attachments/assets/56cbbccc-b1d7-4faa-9d03-1a3ca85928ac)
# Strix OS
## Overview
Strix OS is a lightweight, modular Linux distribution built for developers, security researchers, and robotics enthusiasts. It's based on Ubuntu, and comes with tools for AI, robotics (ROS), development, and security.

## Features
- **GUI**: GNOME Desktop Environment
- **ROS 2**: Humble & Foxy
- **Security Tools**: Kali Linux tools
- **Robotics**: Tools like RViz, Gazebo, OpenCV
- **Smart Package Management**: Auto-detects your OS and uses appropriate package manager

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

## Using the Strix Package Manager

Strix OS comes with a built-in package manager that works with your system's native package manager.

### Basic Commands

```bash
# Install a module from Strix repository
strix install <module-name>

# Install any package using your system's package manager
strix system-install <package-name>

# Install ROS packages (automatically handles dependencies)
strix ros-install <ros-package-name>

# Uninstall a module or package
strix uninstall <module-name>

# Update Strix OS
strix update

# List available modules
strix list

# Search for modules
strix search <keyword>

# Check module status
strix status <module-name>

# Show help
strix help
```

### Examples

```bash
# Install GNOME Desktop Environment (from Strix modules)
strix install gui-gnome

# Install any package from your OS repository
strix system-install firefox

# Install ROS packages directly
strix ros-install turtlesim

# Install VLC media player
strix system-install vlc

# Check the status of ROS 2
strix status ros2-humble
```

## Supported Systems

Strix package manager automatically detects and works with:
- Ubuntu/Debian (apt)
- Fedora/RHEL (dnf)
- Arch Linux (pacman)

## Troubleshooting

If you encounter issues after installation:

1. Run the update command to fix module issues:
   ```bash
   strix update
   ```

2. Verify that modules are installed properly:
   ```bash
   strix list
   ```

3. If the problem persists, try reinstalling:
   ```bash
   cd ~/strix-os
   ./setup.sh
   source ~/.bashrc
   ```

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
