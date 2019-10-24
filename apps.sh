#! /bin/bash

gpg --recv-keys 0FC3042E345AD05D
gpg --recv-keys A2C794A986419D8A

sudo pacman -Syu
sudo pacman -S --noconfirm --needed ttf-dejavu redshift thunar zip unzip \
lxappearance xdg-utils playerctl openssh gedit xarchiver ntp conky \
conky-manager zsh pambase xclip wine docker docker-compose muparser numlockx \
filezilla the_silver_searcher ranger xdotool pulseaudio lib32-libpulse lib32-alsa-plugins \
pulseaudio-alsa pavucontrol ctags xcompmgr libreoffice aws-cli wireshark-qt jdk-openjdk gnutls \
lib32-gnutls jupyter-notebook terminator tmux libjsoncpp-dev dunst libnotify terminator \
nvidia bbswitch wifi-radar bluez bluez-utils 

sudo systemctl enable ntpd.service
sudo systemctl start ntpd.service
sudo systemctl enable docker
sudo systemctl restart docker

if [ ! -n "$ZSH_NAME" ] ;then
    echo Already running as zsh, no action needed;
else
    curl -L http://install.ohmyz.sh | sh
    usermod --shell /bin/zsh $USER
fi

yaourt -Syu
yaourt -S --noconfirm --needed google-chrome ttf-ms-fonts spotify playerctl \
betterlockscreen feh discord slack-desktop postman-bin shutter perl-goo-canvas \
heidisql xkb-switch powerline-fonts albert yad paswitch speedcrunch \
compton-conf shantz-xwinwrap-bzr pgadmin3 stacer visual-studio-code-bin \
polybar todoist-electron vi-vim-symlink google-calendar-nativefier rescuetime2 \
google-keep-nativefier pulseaudio nvidia-xrun

# vim-youcompleteme-git 

systemctl --user enable pulseaudio
chmod +x ~/.dotfiles/scripts/*

# sudo usermod -aG wireshark $USER
