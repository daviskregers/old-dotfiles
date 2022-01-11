# Dotfiles

** This is no longer maintained. I found that I was trying to do things that ansible does better. Probably once I'll have a proper setup there I'll publish the actual dotfiles here. **

## Useful to remember

- You can use the `install/` scripts when doing a clean install.
- When runing the `update.sh`, make sure to copy the `.overrides.example` to `.overrides` and set the desired configuration.
- wallpapers can be seet with launching `nitrogen`

### Dualbooting systemd-boot

If you want to dualboot into windows using systemd-boot, you can use these steps:

```
lsblk -- find the windows EFI partition (should be 100MB size)
sudo mount /dev/sdc2 /mnt
cd /mnt/EFI
sudo cp -ax Microsoft /boot/EFI
```

https://github.com/spxak1/weywot/blob/main/Pop_OS_Dual_Boot.md#22-how-to-add-an-option-for-windows-in-pop_os-boot-menu
