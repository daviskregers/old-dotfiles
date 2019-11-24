pacman -Syu
pacman -S --noconfirm --needed git

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# install i3wm
pacman -S --noconfirm i3-wm i3status i3blocks dmenu xorg xorg-xinit

echo "#! /bin/bash
exec i3
" >> ~/.xinitrc

echo "
# autostart systemd default session on tty1
if [[ \"\$(tty)\" == '/dev/tty1' ]]; then
		exec startx
fi
" >> /etc/profile

# install sound

pacman -S --noconfirm --needed alsa-utils alsamixer
yay -S asoundconf

# monitors
pacman -S --noconfirm --needed arandr

# zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
