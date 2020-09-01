#!/bin/bash
source .bash_helpers

if [ $(uname -n ) != "archiso" ]; then
	echo -e "${BLINK}This isn't an arch installation, exiting...$END"
	exit 1;
fi

echo -e "${GREEN}Arch configuration $END"
echo -e $SEPARATOR

echo -e "Change root password"
passwd

echo -e "Set locale & timezone"

LOCALE=en_US.UTF-8

locale-gen --purge $LOCALE
echo LANG=$LOCALE > /etc/locale.conf
export LANG=$LOCALE
ln -sf /usr/share/zoneinfo/Europe/Riga /etc/localtime
hwclock --systohc --utc

read -p "What will your machine hostname be? " hostname
echo $hostname > /etc/hostname
cat /etc/hostname

echo "Set up hosts"
echo "127.0.0.1 	localhost	$hostname" >> /etc/hosts
echo "::1		localhost	$hostname" >> /etc/hosts
cat /etc/hosts

echo "Set up grub"
read -p "On which device is the linux installed? (/dev/sdX3) " systempartition
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"cryptdevice=$systempartition:system\"/" /etc/default/grub
cat /etc/default/grub | grep GRUB_CMDLINE_LINUX
