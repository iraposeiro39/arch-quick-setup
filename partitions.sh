#!/bin/bash
######### Create partitions #########
## Setting the partition table
echo "Setting the partition table (MBR)..."
sleep 1
echo "label: dos" | sfdisk /dev/sda
## Making the Swap partition, formatting and mounting it
echo "Making the Swap partition..."
sleep 1
echo "size:"$SWAP"G" | sfdisk /dev/sda -N 1
echo "type: S" | sfdisk /dev/sda -N 1
mkswap /dev/sda1
swapon /dev/sda1
## Making the Standard partition, formatting and mounting it
echo "Making the Standard partition..."
sleep 1
echo "size:" "" | sfdisk /dev/sda -N 2
echo "type: L" | sfdisk /dev/sda -N 2
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
## Lsblk to check the results
echo "lsblk output:"
lsblk
sleep 3