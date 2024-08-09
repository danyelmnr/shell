#!/bin/bash

# Script Information
# Author: Danyel Mendes
# Email: danyel.mendes.ramos@gmail.com
# Description: This script updates system packages, installs Python 3 and pip, 
# upgrades pip to the latest version, and installs Ansible using pip.

# Update system packages
echo "Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# Install Python 3 and pip
echo "Installing Python 3 and pip..."
sudo apt install -y python3 python3-pip

# Upgrade pip to the latest version
echo "Upgrading pip..."
python3 -m pip install --upgrade pip

# Install Ansible using pip
echo "Installing Ansible..."
python3 -m pip install ansible

# Verify installed versions
echo "Verifying installed versions..."
python3 -m pip -V
ansible --version

echo "Installation completed!"

