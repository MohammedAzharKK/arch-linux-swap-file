#!/bin/bash

# ==========================================
# Arch Linux Swap File Setup Script
# ==========================================
# This script will create, activate, and configure a swap file on Arch Linux.
# Swap files provide additional virtual memory, especially useful for systems
# with limited RAM. Follow the prompts to create a swap file safely.
#
# Usage:
# 1. Save this script as create_swap.sh
# 2. Make it executable: chmod +x create_swap.sh
# 3. Run with sudo: sudo ./create_swap.sh
#
# ==========================================

# Configurable Variables
SWAP_FILE="/swapfile"  # Path for the swap file
SYSCTL_CONF="/etc/sysctl.d/99-sysctl.conf"  # Swappiness configuration file
SWAPPINESS=10  # System swappiness value

# Prompt the user to enter the swap file size
read -p "Enter the swap file size (e.g., 1G, 2G, 4G): " SWAP_SIZE

# Validate input
if [[ ! $SWAP_SIZE =~ ^[0-9]+[GM]$ ]]; then
  echo "Invalid size. Please enter a valid size (e.g., 1G, 2G, 512M)."
  exit 1
fi

echo "Starting swap file setup with size $SWAP_SIZE..."

# Step 1: Create the Swap File
echo "==> Creating a $SWAP_SIZE swap file at $SWAP_FILE..."
if ! fallocate -l $SWAP_SIZE $SWAP_FILE 2>/dev/null; then
  echo "fallocate failed; trying dd method..."
  dd if=/dev/zero of=$SWAP_FILE bs=1M count=$(echo $SWAP_SIZE | sed 's/G/*1024/;s/M//' | bc) status=progress
fi

# Step 2: Set Permissions
echo "==> Securing the swap file by setting permissions..."
chmod 600 $SWAP_FILE

# Step 3: Mark the File as Swap Space
echo "==> Formatting $SWAP_FILE as swap space..."
mkswap $SWAP_FILE

# Step 4: Enable the Swap File
echo "==> Activating the swap file..."
swapon $SWAP_FILE

# Step 5: Add Swap File to /etc/fstab for Persistence
echo "==> Adding the swap file to /etc/fstab to enable it on boot..."
if ! grep -q "$SWAP_FILE" /etc/fstab; then
  echo "$SWAP_FILE none swap defaults 0 0" | tee -a /etc/fstab
else
  echo "Swap file already exists in /etc/fstab."
fi

# Step 6: Configure Swappiness (Optional)
echo "==> Setting system swappiness to $SWAPPINESS (lower values reduce swapping)..."
echo "vm.swappiness=$SWAPPINESS" | tee -a $SYSCTL_CONF
sysctl -p $SYSCTL_CONF

# Final Check
echo "==> Swap file setup complete! Verifying swap status:"
swapon --show
free -h

echo -e "\nAll done! Your system now has a swap file of $SWAP_SIZE located at $SWAP_FILE."
echo "You can adjust the swappiness value in $SYSCTL_CONF if needed."
