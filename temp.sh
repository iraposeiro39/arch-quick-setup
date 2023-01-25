#!/bin/bash
######### Arch-chroot (part 2) #########
cp arch-quick-setup-2.sh /mnt/script.sh
arch-chroot /mnt ./script.sh
# It enters chroot, and when it exits...
echo "Cleaning up..."
rm /mnt/script.sh
echo "Arch is now installed, you should be able to reboot.
If you want, make any changes you deem necessary."
sleep 2
echo "Exiting..."
exit