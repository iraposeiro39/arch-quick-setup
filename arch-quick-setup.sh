#!/bin/bash 
##
## Arch quick install made by Iraposeiro :)
## This is just a simple script and should be not taken seriously
## Follow my projects on Github: https://github.com/iraposeiro39
##
######### Start Script ######### 
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
read -p "Enter the packages you want to be installed (The default packages are base, linux, linux-firmware, linux-headers, dhcpcd, nano and sudo)
: " PKGS
echo "$USER / $PASS_USER / $PASS_ROOT / $HOSTNAME / $SWAP / $PKGS"
read -p "Just a test: " TEST
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
pacstrap /mnt base linux linux-firmware linux-headers dhcpcd nano sudo $PKGS
echo " "
## Generating the fstab file
echo "Done! Sending the fstab file to /etc/fstab in the new system"
genfstab -U /mnt >> /mnt/etc/fstab
######### Pumping into Arch-chroot #########
{
    ## Setting the timezone
    ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
    hwclock -w
    ## Setting the locales
    echo "en_GB.UTF-8
    en_GB ISO-8859-1" >> /etc/locale.gen
    locale-gen
    ## Setting the Language
    echo "LANG=en_GB.UTF-8" > /etc/locale.conf
    ## Setting the Keyboard Layout
    echo "KEYMAP=pt-latin1" > /etc/vconsole.conf
    ## Setting the Hostname
    echo $HOSTNAME > /etc/hostname
    ## Setting the root password
    echo root:$PASS_ROOT | chpasswd
    ## Enabling dhcp
    systemctl enable dhcpcd
    ## Installing Grub
    grub-install /dev/sda
    echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
    ## Create User
    useradd -mG wheel $USER
    echo $USER:$PASS_USER | chpasswd
    ## Sudo config
    echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
    exit
} | arch-chroot /mnt

echo "Arch is now installed, you should be able to reboot.
If you want, make any changes you deem necessary."
sleep 2
echo "Exiting..."
exit
