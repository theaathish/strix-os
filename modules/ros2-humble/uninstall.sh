#!/bin/bash

echo "Uninstalling ROS 2 Humble..."

# Remove ROS 2 packages
sudo apt remove -y ~nros-humble-* && sudo apt autoremove -y

# Remove the repository
sudo rm /etc/apt/sources.list.d/ros2.list
sudo apt update
sudo apt autoremove -y

# Consider upgrading for packages previously shadowed
sudo apt upgrade -y

# Remove the ROS setup from .bashrc
sed -i '/source \/opt\/ros\/humble\/setup.bash/d' ~/.bashrc

echo "ROS 2 Humble has been uninstalled."
