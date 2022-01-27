#!/bin/bash
source "../../.bash_helpers"
source .install_helpers

PWD=$(pwd)
DOTFILES=$(dirname $(dirname $PWD))
[ -d /sys/firmware/efi ] && TPE="EFI" || TPE="BIOS"

if [ $(uname -n ) != "archiso" ]; then
	echo -e "${BLINK}This isn't an arch installation, exiting...$END"
	exit 1;
fi

echo -e "${GREEN}Arch configuration $END"
echo -e $SEPARATOR

echo -e "Change root password"
passwd

echo -e "Set locale & timezone"

sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
LOCALE=en_US.UTF-8
echo LANG=$LOCALE > /etc/locale.conf
export LANG=$LOCALE
locale-gen --purge $LOCALE

ln -sf /usr/share/zoneinfo/Europe/Riga /etc/localtime
hwclock --systohc --utc

read -p "What will your machine hostname be? " hostname
echo $hostname > /etc/hostname
cat /etc/hostname

echo "Set up hosts"
echo "127.0.0.1 	localhost	$hostname" >> /etc/hosts
echo "::1		localhost	$hostname" >> /etc/hosts
cat /etc/hosts

echo "Set up bootloader"
device=$(get_device)
prefix=$(partition_prefix $device)

systempartition=${device}${prefix}2
efipartition=${device}${prefix}1

if [ $TPE == "EFI" ]; then
echo "EFI bootloader"

pacman -S --noconfirm efibootmgr
sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/g' /etc/mkinitcpio.conf

mkinitcpio -P
systemd-machine-id-setup
bootctl --path=/boot install

uuid=$(blkid --match-tag UUID -o value $systempartition)
echo "GOT UUID: $uuid from $systempartition"
cat <<EOF >/boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options cryptdevice=UUID=${uuid}:system root=/dev/mapper/system
EOF

cat <<EOF >/boot/loader/loader.conf
default arch
timeout 3
EOF

else
echo "Installing GRUB"

pacman –S grub os-prober
grub-install /dev/${device}${prefix}
grub-mkconfig -o /boot/grub/grub.cfg

fi

echo -e "${RED}Generating new user$END"

read -p "Enter your user name: " username
useradd -m $username
passwd $username
usermod -a -G wheel $username
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
cat /etc/sudoers | grep wheel

echo -e "${RED}Setting up dotfiles for $username$END"

cp -r $DOTFILES /home/$username/.dotfiles
chown -R $username /home/$username/.dotfiles

echo -e "${RED}Setting up NetworkManager$END"

pacman -S networkmanager
systemctl enable NetworkManager

setup_mirrors

echo -e "${GREEN}Everything should be done, you can exit and reboot now $END"
echo -e "${GREEN}Afterwards - log into $username, cd into \$HOME/.dotfiles and run the configure-user.sh file$END"
