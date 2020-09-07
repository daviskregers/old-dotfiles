# Dotfiles

These dotfiles are being written for my archlinux and OSX setup.

[[ screenshot ]]

## Installation on arch

Make an installation usb, boot it. When the terminal appears, do this:

```
pacman -Sy git
git clone https://github.com/daviskregers/dotfiles.git
...
Create a device with 3 partitions - EFI (256M), BOOT (512M), SYSTEM
...
./install-arch.sh
... follow instructions for installing arch, once finished run
arch-chroot /mnt
cd root/dotfiles
./configure-arch.sh
exit
reboot
... log into your new user
cd .dotfiles
./configure-user.sh
reboot
```
