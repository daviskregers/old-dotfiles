#! /bin/bash

#sudo pacman -Sc
#sudo pip3.7 uninstall markupsafe Jinja2
sudo pacman -Syu
sudo pacman -S --noconfirm --needed ttf-dejavu redshift thunar zip unzip \
lxappearance termite xdg-utils playerctl openssh gedit xarchiver ntp conky \
conky-manager zsh pambase xclip wine docker docker-compose muparser numlockx \
filezilla the_silver_searcher ranger xdotool pulseaudio lib32-libpulse lib32-alsa-plugins \
pulseaudio-alsa pavucontrol ctags xcompmgr libreoffice aws-cli wireshark-qt jdk-openjdk gnutls lib32-gnutls telegram-desktop jupyter-notebook terminator thunderbird

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

# https://www.ostechnix.com/solve-perl-5-26-dependency-error-failed-prepare-transaction-not-satisfy-dependencies-arch-linux/

yaourt -S --noconfirm --needed google-chrome ttf-ms-fonts spotify playerctl \
betterlockscreen feh discord slack-desktop postman-bin shutter perl-goo-canvas \
heidisql xkb-switch powerline-fonts albert nixnote2-git yad paswitch speedcrunch \
vim-youcompleteme-git compton-conf shantz-xwinwrap-bzr pgadmin3 stacer visual-studio-code-bin \
polybar

yaourt -S --needed vi-vim-symlink

systemctl --user enable pulseaudio
chmod +x ~/.dotfiles/scripts/*

sudo usermod -aG wireshark $USER
groups

cd ~/.dotfiles/evernote6 && makepkg -si --noconfirm --needed
