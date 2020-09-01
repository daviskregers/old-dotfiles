#!/bin/bash
source .bash_helpers

PWD=$(pwd)
SEPARATOR="------------------------------------------"

if [ $(uname -n ) != "archiso" ]; then
	echo -e "${BLINK}This isn't an arch installation, exiting...$END"
	exit 1;
fi

echo -e "${GREEN}Arch installation $END"
echo -e $SEPARATOR

echo -e "${RED} Before starting - create 3 partitions. EFI (256M), BOOT (512M), SYSTEM $END"
echo -e "You can use cfdisk, fdisk or cgdisk to do that."
PREPPED=$(confirmation)

if [[ $PREPPED != 1 ]]; then
	exit 1;
fi

echo -e "
Devices available:
"
lsblk
echo -e $SEPARATOR
echo -e "${RED}Select prepared device. $END
${GREEN}Format: /dev/sdX$END
"

read -p "Device name: " device

efipartition=${device}1
bootpartition=${device}2
systempartition=${device}3
luks_root=system
luks_path=/dev/mapper/$luks_root

function cleanup() {
	sleep 1
	umount /mnt/boot/efi
	umount /mnt/boot
	umount /mnt
	cryptsetup close $luks_root
	exit 1;
}

function cleanup_inside() {
	exit;
	cleanup
}

echo $SEPARATOR
echo -e "${RED}Formatting drives$END"

modprobe dm-crypt || exit 1;
modprobe dm-mod || exit 1;
cryptsetup luksFormat -v -s 512 -h sha512 $systempartition || exit 1;
cryptsetup open $systempartition $luks_root || exit 1;

mkfs.vfat -n "EFI System Partition" $efiparition
mkfs.ext4 -L boot $bootpartition
mkfs.ext4 -L root $luks_path

echo -e "${RED}Installing arch$END"


echo "mount system - $systempartition / $luks_path"
mount $luks_path /mnt || cleanup;

echo "make & mount boot directory - $bootpartition"
mkdir /mnt/boot || cleanup;
mount $bootpartition /mnt/boot || cleanup;

echo "make & mount efi directory - $efiparition"
mkdir /mnt/boot/efi || cleanup;
mount $efipartition /mnt/boot/efi || cleanup;

echo "install arch base"
pacstrap -i /mnt base base-devel efibootmgr grub || cleanup;

echo $SEPARATOR
echo -e "${RED}Generating FSTAB$END"
genfstab -U /mnt > /mnt/etc/fstab || clearnup;
cat /mnt/etc/fstab

echo -e "${GREEN}Next step - system configuration. Run 'arch-chroot /mnt' and run the configuration script from the /root/dotfiles directory."
cp -r $PWD /mnt/root/dotfiles
