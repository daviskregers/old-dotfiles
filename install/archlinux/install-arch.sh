#!/bin/bash
set -euxo pipefail

source "../../.bash_helpers"
source .install_helpers

pacman -Sy --noconfirm dialog
setup_mirrors

PWD=$(pwd)
DOTFILES=$(dirname $(dirname $PWD))
BACKTITLE_PARTITION="Paritioning"
DESCRIPTION_PARTITIONS="Have you created paritions? \nEFI(512M), SYSTEM. \nUse cfdisk, fdisk or cgdisk."
DIALOG_CANCEL=1
DIALOG_ESC=255
SEPARATOR="------------------------------------------"
TITLE_DEVICE_SELECT="Choose device"
TITLE_FORMAT="Confirm formatting"
TITLE_PARTITION_CHECK="Partitions in place?"

if [ $(uname -n ) != "archiso" ]; then
	echo -e "${BLINK}This isn't an arch installation, exiting...$END"
	exit 1;
fi

# check whether all partitions created beforehand
dialog --backtitle "$BACKTITLE_PARTITION" --title "$TITLE_PARTITION_CHECK" --yesno "$DESCRIPTION_PARTITIONS" 10 40
exit_on_esc_or_cancel $?

device=$(get_device)
prefix=$(partition_prefix $device)

echo "DEVICE $device, prefix: $prefix"

efipartition=${device}${prefix}1
systempartition=${device}${prefix}2
luks_root=system
luks_path=/dev/mapper/$luks_root

DESCRIPTION_FORMAT="This will format the $device drive, partitions $efipartition, $systempartition"

echo "Boot partition: $efipartition"
echo "System partition: $systempartition"

dialog --backtitle "$BACKTITLE_PARTITION" --title "$TITLE_FORMAT" --yesno "$DESCRIPTION_FORMAT" 10 40
exit_on_esc_or_cancel $?

echo $SEPARATOR
echo -e "${RED}Formatting drives$END"

modprobe dm-crypt;
modprobe dm-mod;
cryptsetup luksFormat -v -s 512 -h sha512 $systempartition;
cryptsetup open $systempartition $luks_root;

echo "Formatting efi parition: $efipartition"
mkfs.fat -F32 $efipartition
echo "Formatting System partition: $luks_path"
mkfs.ext4 -L root $luks_path

sleep 10

echo -e "${RED}Installing arch$END"

echo "mount system - $systempartition / $luks_path"
mount -v $luks_path /mnt || cleanup;
ls /mnt

echo "make & mount boot directory - $efipartition"
mkdir -p /mnt/boot || cleanup;
mount -v $efipartition /mnt/boot || cleanup;

echo "install arch base"
pacstrap -i /mnt base base-devel efibootmgr grub vim neovim mkinitcpio linux linux-firmware os-prober dialog || cleanup;

echo -e "${RED}Generating FSTAB$END"
genfstab -U /mnt > /mnt/etc/fstab || clearnup;
cat /mnt/etc/fstab

echo -e "${GREEN}Next step - system configuration. Run 'arch-chroot /mnt' and run the configuration script from the /root/dotfiles directory."
cp -r $DOTFILES /mnt/root/dotfiles
