#!/bin/bash

echo "Installing ROS 2 Humble..."

# Install dependencies
sudo apt update
sudo apt install -y curl gnupg lsb-release

# Add ROS 2 repository
curl -sSL https://raw.githubusercontent.com/ros2/ros2/master/ros2.repos -o ros2.repos
vcs import src < ros2.repos

# Install ROS 2 Humble
sudo apt install -y ros-humble-desktop

echo "ROS 2 Humble installed successfully!"
