#!/bin/bash
source .bash_helpers

PWD=$(pwd)

if [ $(uname -n ) != "archiso" ]; then
	echo -e "${BLINK}This isn't an arch installation, exiting...$END"
	exit 1;
fi

echo -e "${GREEN}Arch configuration $END"
echo -e $SEPARATOR

echo -e "Change root password"
passwd

echo -e "Set locale & timezone"

sed -i 's/#en_US.UTF-8/en-US.UTF-8/' /etc/locale.gen
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

echo "Set up grub"
read -p "On which device is the linux installed? (/dev/sdX) " devicepath

systempartition=${devicepath}3
bootparition=${devicepath}2
efipartition=${devicepath}1

sed -i "s#GRUB_CMDLINE_LINUX=[\"][\"]#GRUB_CMDLINE_LINUX=\"cryptdevice=$systempartition:system\"#g" /etc/default/grub
cat /etc/default/grub | grep GRUB_CMDLINE_LINUX

sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/g' /etc/mkinitcpio.conf
cat /etc/mkinitcpio.conf | grep "^HOOKS"

sudo pacman -S --noconfirm os-prober
os-prober
mkinitcpio -p linux
grub-install --boot-directory=/boot --efi-directory=/boot/efi $bootpartition
grub-mkconfig -o /boot/grub/grub.cfg
grub-mkconfig -o /boot/efi/EFI/arch/grub.cfg

echo -e "${RED}Generating new user$END"

read -p "Enter your user name: " username
useradd -m $username
passwd $username
usermod -a -G wheel $username
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
cat /etc/sudoers | grep wheel

echo -e "${RED}Setting up dotfiles for $username$END"

cp -r $PWD /home/$username/.dotfiles
chown -R $username /home/$username/.dotfiles

echo -e "${RED}Setting up NetworkManager$END"

pacman -S networkmanager
systemctl enable NetworkManager

echo -e "${RED}Syncing pacman mirrors$END"

pacman -S reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "LV" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

cat /etc/pacman.d/mirrorlist

echo -e "${GREEN}Everything should be done, you can exit and reboot now $END"
echo -e "${GREEN}Afterwards - log into $username, cd into \$HOME/.dotfiles and run the configure-user.sh file$END"
