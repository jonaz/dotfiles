#!/bin/bash
set -e

# before chroot
echo "setting keymaps for installation"
loadkeys sv-latin1

echo "setting time from NTP"
timedatectl set-ntp true

echo "creating partitions" # partition here first /boot on 1 and luksdev on 2
parted -s /dev/nvme0n1 mklabel gpt
parted -s -a optimal /dev/nvme0n1 mkpart '"EFI system partition"' fat32 1MiB 512MiB
parted /dev/nvme0n1 set 1 boot on
parted /dev/nvme0n1 set 1 esp on
parted -s -a optimal /dev/nvme0n1 mkpart '"encrypted partition"' 512MiB 100%

echo "encrypting disk"
cryptsetup luksFormat /dev/nvme0n1p2
echo "opening encrypted disk"
cryptsetup open /dev/nvme0n1p2 cryptlvm

echo "creating LVM on encrypted disk"
pvcreate /dev/mapper/cryptlvm
vgcreate RootVolGroup /dev/mapper/cryptlvm
lvcreate -L 5G RootVolGroup -n swap
lvcreate -l 100%FREE RootVolGroup -n root
lvreduce -y -q -L -256M RootVolGroup/root #If a logical volume will be formatted with ext4, leave at least 256 MiB free space in the volume group to allow using e2scrub(8).

echo "formatting volumes"
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/RootVolGroup/root
mkswap /dev/RootVolGroup/swap

echo "mounting volumes"
mount /dev/RootVolGroup/root /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot
swapon /dev/RootVolGroup/swap

# install base
echo "installing base system"
pacstrap -K /mnt base linux linux-firmware amd-ucode lvm2 base-devel sudo
genfstab -U /mnt >> /mnt/etc/fstab

echo "type desired hostname:"
read newhostname
echo "$newhostname" > /mnt/etc/hostname 

cp ./after_chroot.sh /mnt/after_chroot.sh
arch-chroot /mnt /after_chroot.sh
rm /mnt/after_chroot.sh

echo "Congratulations! Installation finished, rebooting now!"
reboot
