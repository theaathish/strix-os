![Navy Blue And Red Modern YouTube Banner](https://github.com/user-attachments/assets/56cbbccc-b1d7-4faa-9d03-1a3ca85928ac)
# Strix OS
## Overview
Strix OS is a lightweight, modular Linux distribution built for developers, security researchers, and robotics enthusiasts. It's based on Ubuntu, and comes with tools for AI, robotics (ROS), development, and security.

## Features
- **GUI**: GNOME Desktop Environment
- **ROS 2**: Humble & Foxy
- **Security Tools**: Kali Linux tools
- **Robotics**: Tools like RViz, Gazebo, OpenCV

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

Strix OS comes with a built-in package manager to easily install, update, and manage modules.

### Basic Commands

```bash
# Install a module
strix install <module-name>

# Uninstall a module
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

### Available Modules

- **gui-gnome**: GNOME Desktop Environment
- **kali-tools**: Security and penetration testing tools
- **ros2-humble**: Robot Operating System 2 Humble
- **vscode**: Visual Studio Code editor
- **ros2-foxy**: Robot Operating System 2 Foxy

### Examples

```bash
# Install GNOME Desktop Environment
strix install gui-gnome

# Install Visual Studio Code
strix install vscode

# Install Kali Linux tools
strix install kali-tools

# Check the status of ROS 2
strix status ros2-humble
```

### Troubleshooting

If you encounter "Command 'strix' not found" after installation:

1. Make sure you've run the setup script:
   ```bash
   cd ~/strix-os
   ./setup.sh
   source ~/.bashrc
   ```

2. Alternatively, you can run strix directly:
   ```bash
   cd ~/strix-os
   ./strix [command]
   ```

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
