#!/bin/bash

echo "Installing ROS 2 Humble..."

# Check if we're running on Ubuntu 22.04 (Jammy)
if grep -q "Ubuntu 22.04\|jammy" /etc/os-release; then
    echo "Ubuntu 22.04 detected - proceeding with installation"
else
    echo "WARNING: ROS 2 Humble is designed for Ubuntu 22.04 (Jammy)."
    echo "Your OS may not be fully compatible. Installation might fail or work incorrectly."
    echo "Proceeding anyway in 5 seconds (Ctrl+C to cancel)..."
    sleep 5
fi

echo "Step 1: Setting up locale..."
# Set locale
sudo apt update && sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo "Step 2: Adding the ROS 2 repository..."
# Make sure Universe repo is enabled
sudo apt install -y software-properties-common
sudo add-apt-repository -y universe

# Add ROS 2 GPG key
sudo apt update && sudo apt install -y curl gnupg lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# Add repository to sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo "Step 3: Updating package list and upgrading system packages..."
# Update apt repository caches
sudo apt update

# Make sure the system is updated before installing ROS 2
# This is important for Ubuntu 22.04 to avoid system package conflicts
sudo apt upgrade -y

echo "Step 4: Installing ROS 2 Humble desktop packages..."
# Install ROS 2 Humble desktop packages
sudo apt install -y ros-humble-desktop

echo "Step 5: Installing development tools..."
# Install development tools
sudo apt install -y ros-dev-tools

echo "Step 6: Setting up environment..."
# Source the setup file
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
echo "# Adding ROS 2 Humble to .bashrc was successful"

echo "ROS 2 Humble has been successfully installed!"
echo ""
echo "To start using ROS 2, either:"
echo "  - Open a new terminal"
echo "  - Or run: source /opt/ros/humble/setup.bash"
echo ""
echo "Test your installation with: ros2 run demo_nodes_cpp talker"
echo "In another terminal: ros2 run demo_nodes_py listener"
