#! /bin/bash

echo "[APPS] Update pacman"
sudo pacman -Syu

if ! [ -x "$(command -v yay)" ]; then
    echo 'Warning: yay not installed, downloading it...' >&2
    cd /tmp 
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
fi

echo "[APPS] Update AUR"
yay -Syu --noconfirm

echo "[APPS] Install official packages"
sudo pacman -S --noconfirm --needed ttf-dejavu redshift thunar zip unzip \
lxappearance xdg-utils playerctl openssh gedit xarchiver ntp conky \
conky-manager zsh pambase xclip wine docker docker-compose muparser numlockx \
filezilla ranger xdotool pulseaudio lib32-libpulse lib32-alsa-plugins \
pulseaudio-alsa pavucontrol ctags xcompmgr libreoffice aws-cli jdk-openjdk gnutls \
lib32-gnutls terminator tmux dunst libnotify terminator \
nvidia bbswitch wifi-radar bluez bluez-utils tmux cmake \
libsecret gnome-keyring git ctags ncurses curl \
elixir nodejs npm gvim

echo "[APPS] Install packages from AUR"
yay -S --noconfirm --needed google-chrome ttf-ms-fonts spotify playerctl \
betterlockscreen feh discord slack-desktop postman-bin shutter perl-goo-canvas \
heidisql xkb-switch albert yad paswitch deepin-calculator \
compton-conf shantz-xwinwrap-bzr stacer visual-studio-code-bin rescuetime2 \
polybar todoist-electron vi-vim-symlink google-calendar-nativefier \
nvidia-xrun mailspring the_silver_searcher powerline-fonts-git \
php-codesniffer

echo "[APPS] Install python modules for vim"
pip install flake8 jedi --user
pip3 install flake8 jedi --user
pip3.8 install flake8 jedi --user
if [ -f $HOME/.vim/plugged/youcompleteme/.is-installed ]
then
    echo "[APPS] youcompleteme is already installed, skipping..."
else
    cd $HOME/.vim/plugged/youcompleteme && git clean -f && git pull && git submodule update --recursive --init && ./install.py --clang-completer
    $HOME/.vim/plugged/youcompleteme/.is-installed
fi

echo "[APPS] Clean unneeded dependencies"
yay -Yc --noconfirm

echo "[APPS] Upgrade NPM"
sudo npm install -g npm eslint instant-markdown-d

echo "[APPS] Setup tmux plugins"
if [ -f $HOME/.tmux/plugins/tpm ]
then
    echo "[APPS] tmux plugin system already installed, skipping."
else
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

echo "[APPS] Setup ZSH"
if [ ! -n "$ZSH_NAME" ] ;then
    echo Already running as zsh, no action needed;
else
    curl -L http://install.ohmyz.sh | sh
    usermod --shell /bin/zsh $USER
fi

echo "[APPS] Enable services"
sudo systemctl enable ntpd.service
sudo systemctl start ntpd.service
sudo systemctl enable docker
sudo systemctl restart docker
systemctl --user enable pulseaudio

echo "[APPS] Setup permissions"
sudo chmod +x ~/.dotfiles/scripts/*
sudo usermod -a -G rfkill $USER
