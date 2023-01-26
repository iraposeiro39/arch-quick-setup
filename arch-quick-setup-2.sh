##
## Arch quick install part 2
##
######### Arch-chroot #########
## Setting the timezone
ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
hwclock -w
## Setting the locales
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_GB ISO-8859-1" >> /etc/locale.gen
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
grub-install --target=i386-pc /dev/sda
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
## Create User
useradd -mG wheel $USER
echo $USER:$PASS_USER | chpasswd
## Sudo config
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
exit
