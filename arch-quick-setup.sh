#!/bin/bash 
##
## Arch quick install made by Iraposeiro39 :)
## This is just a simple script and should be not taken seriously
## Follow my projects on Github: https://github.com/iraposeiro39
##
######### Initial Settings ######### 
clear
echo "Initializing Setup..."
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
> " USER
read -sp "Enter the pass for your user
> " PASS_USER
echo " "
read -sp "Enter root's password
> " PASS_ROOT
echo " "
read -p "Enter the PCs hostname
> " HOSTNAME
read -p "Enter your Swap partition size (should be the same as your RAM, if not bigger)
> " SWAP
read -p "Enter the packages you want to be installed, they have to be separated by a space (The default packages are base, linux, linux-firmware, linux-headers, dhcpcd, grub, nano and sudo)
> " PKGS
echo " "
echo "User=$USER
Hostname=$HOSTNAME
Swap size=$SWAP"G" 
Aditional Packages=$PKGS"
echo " "
while true
    do
        read -p "Do you wish to check the passwords you inputed? (y/n)" VAR
        case $VAR in
            [Yy]*) echo " "
                   echo User pass=$PASS_USER
                   echo Root pass=$PASS_ROOT
                   echo " "
                   break;;
            [Nn]*) echo " "
                   break;;
        esac
done
read -p "Press any key to continue..."
clear
######### Start Install #########
echo "Starting Setup..."
sleep 2
## Set NTP server to true
timedatectl set-ntp true
## PT Keyboard
loadkeys pt-latin1
######### Create partitions #########
## Setting the partition table
echo "Setting the partition table (MBR)..."
sleep 1
echo "label: dos" | sfdisk /dev/sda
## Making the Swap partition
echo "Making the Swap partition..."
sleep 1
echo "size="$SWAP"G" | sfdisk /dev/sda -N 1
echo "type= S" | sfdisk /dev/sda -N 1
## Making the Standard partition
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
pacman-key --init && pacman-key --populate
pacstrap /mnt base linux linux-firmware linux-headers dhcpcd grub nano sudo $PKGS
echo " "
## Generating the fstab file
echo "Done! Sending the fstab file to /etc/fstab in the new system"
genfstab -U /mnt >> /mnt/etc/fstab
######### Arch-chroot #########
## Creating the slave script
touch temp.sh
chmod +x temp.sh
echo "######### Arch-chroot #########
## Setting the timezone
ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
hwclock -w
## Setting the locales
echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen
echo 'en_GB ISO-8859-1' >> /etc/locale.gen
locale-gen
## Setting the Language
echo 'LANG=en_GB.UTF-8' > /etc/locale.conf
## Setting the Keyboard Layout
echo 'KEYMAP=pt-latin1' > /etc/vconsole.conf
## Setting the Hostname
echo $HOSTNAME > /etc/hostname
## Setting the root password
echo root:$PASS_ROOT | chpasswd
## Enabling dhcp
systemctl enable dhcpcd
## Installing Grub
grub-install --target=i386-pc /dev/sda
echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
## Create User
useradd -mG wheel $USER
echo $USER:$PASS_USER | chpasswd
## Sudo config
echo '%wheel ALL=(ALL:ALL) ALL' >> /etc/sudoers
exit" >> temp.sh
## Send it to the new system
cp temp.sh /mnt/temp.sh
## Exec
arch-chroot /mnt ./temp.sh
# It enters chroot, and when it exits...
echo "All done, Cleaning up..."
sleep 3
rm temp.sh
rm /mnt/temp.sh
echo "Arch is now installed, you should be able to reboot.
If you want, make any changes you deem necessary."
sleep 3
echo "Exiting..."
exit
