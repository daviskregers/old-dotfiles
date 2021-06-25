# Dotfiles

TODO: descipriton


## Useful to rembmer

### Dualbooting systemd

If you want to dualboot into windows using systemd-boot, you can use these steps:

```
lsblk -- find the windows EFI partition (should be 100MB size)
sudo mount /dev/sdc2 /mnt
cd /mnt/EFI
sudo cp -ax Microsoft /boot/EFI
```

https://github.com/spxak1/weywot/blob/main/Pop_OS_Dual_Boot.md#22-how-to-add-an-option-for-windows-in-pop_os-boot-menu

