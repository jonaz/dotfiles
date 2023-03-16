#!/bin/bash
set -e

ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

echo "setting up keymaps"
echo "KEYMAP=sv-latin1" > /etc/vconsole.conf
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo -e "en_US.UTF-8 UTF-8\nsv_SE.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

# doing this manually because localectl set-keymap sv-latin1 does not work before systemd runs as PID1
mkdir -p /etc/X11/xorg.conf.d
cat <<EOT >> /etc/X11/xorg.conf.d/00-keyboard.conf
# Written by systemd-localed(8), read by systemd-localed and Xorg. It's
# probably wise not to edit this file manually. Use localectl(1) to
# instruct systemd-localed to update it.
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "se"
        Option "XkbModel" "pc105"
        Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection
EOT

echo "configuring mkinitcpio"
HOOKS="HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)"
sed -i "s/^HOOKS=.*/$HOOKS/" /etc/mkinitcpio.conf
mkinitcpio -P

echo "installing i3 and lightdm"
pacman --noconfirm -S lightdm lightdm-gtk-greeter i3-wm i3status i3lock rofi git
echo "installing network tools"
pacman --noconfirm -S iw wpa_supplicant dialog netctl
echo "installing stuff"
pacman --noconfirm -S alacritty bash-completion man-db man-pages texinfo

systemctl enable lightdm
systemctl enable fstrim.timer

echo "setup bootloader systemd-boot"
bootctl install
echo -e "default arch.conf\ntimeout 4\nconsole-mode max\neditor no" > /boot/loader/loader.conf
cat <<EOT >> /boot/loader/entries/arch.conf
title Arch Linux Encrypted
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=%%UUID%%:cryptlvm:allow-discards root=/dev/RootVolGroup/root quiet rw
EOT

DISKUUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
sed -i "s/%%UUID%%/$DISKUUID/" /boot/loader/entries/arch.conf


echo "type new root password"
passwd

echo "type disired username:"
read newusername
useradd -m -G wheel "$newusername"
echo "type new password for $newusername"
passwd "$newusername"
