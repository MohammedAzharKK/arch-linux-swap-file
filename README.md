# Arch Linux Swap File Setup Script

## Overview

This Bash script automates the process of creating, activating, and configuring a swap file on Arch Linux. Swap files provide additional virtual memory, which is particularly useful for systems with limited RAM. The script prompts the user for the desired swap file size and handles the setup steps safely.

## Features

- Create a swap file of specified size.
- Secure the swap file by setting appropriate permissions.
- Format the swap file for use as swap space.
- Activate the swap file immediately.
- Automatically add the swap file to `/etc/fstab` for persistence across reboots.
- Optionally configure the system's swappiness value.

## Prerequisites

- Arch Linux or an Arch-based distribution
- Root access (or ability to use `sudo`)
- Basic familiarity with command line operations

## Usage

1. **Download the Script**: Save the script as `create_swap.sh`.

2. **Make the Script Executable**:
   ```bash
   chmod +x swapfile.sh
   ```
**Run the Script with Root Privileges**:

```bash
sudo ./swapfile.sh
```
Follow the Prompts: Enter the desired swap file size (e.g., 1G, 2G, 512M) when prompted.

Script Details
SWAP_FILE: The path where the swap file will be created (default is /swapfile).
SYSCTL_CONF: The configuration file for the swappiness setting (default is /etc/sysctl.d/99-sysctl.conf).
SWAPPINESS: The system swappiness value (default is 10).
Validating Swap Setup
After the script completes, you can verify that the swap file is active and check the system's memory usage by running:

```bash
swapon --show
free -h
```
**If you need to increase the swap file size after running the script**:

Deactivate the Existing Swap File:

```bash
sudo swapoff /swapfile
```
Remove the Old Swap File Entry from /etc/fstab (optional, if you plan to re-run the script to create a new one):

```bash
sudo sed -i '/\/swapfile/d' /etc/fstab
```
**Re-run the Script**: 
Run
```bash
swapfile.sh
``` 
again and enter the new, larger swap size when prompted.



Customization
You can modify the default values of SWAP_FILE, SYSCTL_CONF, and SWAPPINESS within the script as needed.
Adjust the swappiness value in the /etc/sysctl.d/99-sysctl.conf file if you want to change how aggressively the system uses swap space.
License
This script is released under the MIT License. Feel free to modify and distribute as needed.

Contributions
Contributions are welcome! Please open an issue or submit a pull request for any improvements or enhancements.

Contact
For questions or feedback, please open an issue in the GitHub repository.

Feel free to adjust any sections to better fit your preferences or add any additional information you think might be helpful!

