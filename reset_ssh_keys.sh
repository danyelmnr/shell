#!/bin/bash

# Script Information
# Author: Danyel Mendes
# Email: danyel.mendes.ramos@gmail.com
# Description: This script resets SSH keys on a Debian-based system.
# Usage: sudo ./reset_ssh_keys.sh

# Function to reset SSH keys
reset_ssh_keys() {
    echo "Removing existing SSH host keys..."
    sudo rm -f /etc/ssh/ssh_host_*

    echo "Generating new SSH host keys..."
    sudo dpkg-reconfigure openssh-server

    echo "Restarting SSH service..."
    sudo systemctl restart ssh

    echo "SSH keys have been reset successfully."
}

# Main script execution
reset_ssh_keys
