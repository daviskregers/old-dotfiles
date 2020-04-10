fdisk /dev/sdb
```
p -- print the partition table
d -- delete partitions
n -- create new
	p -- primary
	+512M
t -- change partition type
1 -- partition 1
ef -- select EFI system

n
p
2
<enter>
<enter>

w
```

mkfs.fat -F32 /dev/sdb1
mkfs.ext4 /dev/sdb2

pacman -Syy
pacman -S reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

mount /dev/sdb2 /mnt
pacstrap /mnt base linux linux-firmware vim git
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

timedatectl set-timezone Europe/Riga
timedatectl set-ntp true

locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

echo davis-arch > /etc/hostname
vim /etc/hosts

```
127.0.0.1	localhost
::1		localhost
127.0.0.1	davis-arch
```

passwd

pacman -S grub efibootmgr os-prober
mkdir /boot/efi
mount /dev/sdb1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

useradd -m -g users -G wheel,storage,power,audio -s /bin/bash davis
passwd davis

pacman -S sudo
visudo
-> %wheel ALL=(ALL) NOPASSWD: ALL

pacman -S networkmanager
systemctl enable NetworkManager

exit
reboot

git clone https://github.com/daviskregers/dotfiles.git .dotfiles
cd .dotfiles
git checkout v2
./apps.sh
