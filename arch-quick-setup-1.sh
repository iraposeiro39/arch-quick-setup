#!/bin/bash 
##
## Arch quick install made by Iraposeiro :)
## This is just a simple script and should be not taken seriously
## Follow my projects on Github: https://github.com/iraposeiro39
##
######### Start Script ######### 
clear
echo "Starting Setup"
## Connection test
if ping -c 4 8.8.8.8 &>/dev/null
then
    echo "You're connected! Moving on..."
else
    echo "You're not connected! You must be connected to the internet to continue."
    echo "Exiting..."
    exit
fi
sleep 1
######### Variables #########
read -p "Enter the name for your user
: " USER
echo " "
read -p "Enter the pass for your user
: " PASS_USER
echo " "
read -p "Enter root's password
: " PASS_ROOT
echo " "
read -p "Enter the PCs hostname
: " HOSTNAME
echo " "
read -p "Enter your Swap partition size (should be the same as your RAM, if not bigger)
: " SWAP
echo " "
read -p "Enter the packages you want to be installed (The default packages are base, linux, linux-firmware, linux-headers, dhcpcd, grub, nano and sudo)
: " PKGS
echo "User=$USER / User's pass=$PASS_USER / Root's pass=$PASS_ROOT / Hostname=$HOSTNAME / Swap size=$SWAP / Aditional Packages=$PKGS"
read -p "Press any key to continue..."
## Set NTP server to true
timedatectl set-ntp true
## PT Keyboard
loadkeys pt-latin1
######### Create partitions #########
## Setting the partition table
echo "Setting the partition table (MBR)..."
sleep 1
echo "label: dos" | sfdisk /dev/sda
## Making the Swap partition, formatting and mounting it
echo "Making the Swap partition..."
sleep 1
echo "size="$SWAP"G" | sfdisk /dev/sda -N 1
echo "type= S" | sfdisk /dev/sda -N 1
## Making the Standard partition, formatting and mounting it
echo "Making the Standard partition..."
sleep 1
echo "size=" "" | sfdisk /dev/sda -N 2
echo "type= L" | sfdisk /dev/sda -N 2
## Mounting and formatting
mkswap /dev/sda1
mkfs.ext4 /dev/sda2
swapon /dev/sda1
mount /dev/sda2 /mnt
## Lsblk to check the results
echo "lsblk output:"
lsblk
sleep 3
######### Installing the System #########
## Using pacstrap to send pkgs to the new system
echo "Installing the System"
sleep 1
pacstrap /mnt base linux linux-firmware linux-headers dhcpcd grub nano sudo $PKGS
echo " "
## Generating the fstab file
echo "Done! Sending the fstab file to /etc/fstab in the new system"
genfstab -U /mnt >> /mnt/etc/fstab
######### Arch-chroot #########
chmod +x arch-quick-setup-2.sh
## Send it to the new system
cp arch-quick-setup-2.sh /mnt/script.sh
## Exec
arch-chroot /mnt ./script.sh
# It enters chroot, and when it exits...
echo "Cleaning up..."
sleep 3
rm /mnt/script.sh
echo "Arch is now installed, you should be able to reboot.
If you want, make any changes you deem necessary."
sleep 2
echo "Exiting..."
exit