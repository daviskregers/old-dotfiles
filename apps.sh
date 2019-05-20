#! /bin/bash

sudo pacman -Syu
sudo pacman -S --noconfirm --needed ttf-dejavu redshift thunar zip unzip \
lxappearance termite xdg-utils playerctl openssh gedit xarchiver ntp conky \
conky-manager zsh pambase xclip wine docker docker-compose muparser numlockx \
filezilla the_silver_searcher ranger xdotool pulseaudio lib32-libpulse lib32-alsa-plugins pulseaudio-alsa pavucontrol

sudo systemctl enable ntpd.service
sudo systemctl start ntpd.service
sudo systemctl enable docker
sudo systemctl restart docker
usermod --shell /bin/zsh davis
grep davis /etc/passwd

curl -L http://install.ohmyz.sh | sh

gpg --recv-keys 0FC3042E345AD05D
gpg --recv-keys A2C794A986419D8A

yaourt -Syu
yaourt -S --noconfirm --needed google-chrome ttf-ms-fonts spotify playerctl \
betterlockscreen feh discord slack-desktop postman-bin shutter perl-goo-canvas \
heidisql xkb-switch powerline-fonts albert nixnote2-git yad paswitch speedcrunch vim-youcompleteme-git

yaourt -S --needed vi-vim-symlink

systemctl --user enable pulseaudio
chmod +x ~/.dotfiles/scripts/*
