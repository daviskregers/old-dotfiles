#! /bin/bash

# TODO:
# - Multi monitors

echo "[APPS] Enable pacman colors"
grep "Color" /etc/pacman.conf && \
sudo sed -i -e 's/#Color/Color/g' /etc/pacman.conf && \
grep "Color" /etc/pacman.conf

echo "Sync directories"
ln -sf ~/.dotfiles/.config ~
ln -sf ~/.dotfiles/.bash_profile ~
ln -sf ~/.dotfiles/.bashrc ~
ln -sf ~/.dotfiles/.bashrc ~
ln -sf ~/.dotfiles/.zshrc ~
ln -sf ~/.dotfiles/.Xauthority ~
ln -sf ~/.dotfiles/.dmrc ~
ln -sf ~/.dotfiles/.albertignore ~
ln -sf ~/.dotfiles/.tmux.conf ~
ln -sf ~/.dotfiles/.variables ~
ln -sf ~/.dotfiles/.functions ~
ln -sf $WALLPAPER ~/.wallpaper.jpg
ln -sf $SCREENLAYOUT ~/.screenlayout.sh
ln -sf $DOTFILES/configurations/$(hostname)/alacritty.yml $DOTFILES/.config/alacritty


echo "[APPS] Update pacman"
sudo pacman -Syu --noconfirm

if ! [ -x "$(command -v yay)" ]; then
	echo "[APPS] yay not installed, downloading it..."
	cd /tmp
	rm -rf yay
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm

	# optimize system for faster compilation of the source based packages
	# -T represents num of cores, get it with `lscpu | grep "CPU(s):" | grep -v NUMA`
	grep "COMPRESSXZ=(xz" /etc/makepkg.conf && \
	grep "#MAKEFLAGS=\"-j" /etc/makepkg.conf && \
	sudo sed -i ' s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 8 -z -)/g' /etc/makepkg.conf && \
	sudo sed -i ' s/#MAKEFLAGS="-j2"/MAKEFLAGS="-j7"/g' /etc/makepkg.conf
	grep "COMPERSSXZ=(xz" /etc/makepkg.conf && \
	grep "#MAKEFLAGS=\"-j" /etc/makepkg.conf
fi

echo "[APPS] Update AUR"
yay -Syu --noconfirm

# Force python 3.7 for AWS EB-CLI
sudo pacman -Rdd python
yay -S python37

echo "[APPS] Install official packages"
# Note: nvidia non open source drivers may conflict with nouveau OS drivers
# and in below case to make drivers work in needed to blacklist nouveau drivers
# > cat /usr/lib/modprobe.d/nvidia.conf
# > blacklist nouveau
sudo pacman -S --needed \
	xorg-server xorg-apps xorg-xinit i3-wm numlockx \
	lightdm lightdm-gtk-greeter \
	noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont ttf-liberation ttf-droid ttf-inconsolata ttf-roboto terminus-font ttf-font-awesome \
	alsa-utils alsa-plugins alsa-lib pavucontrol \
	rxvt-unicode ranger rofi conky dmenu urxvt-perls perl-anyevent-i3 perl-json-xs \
	atool highlight elinks mediainfo w3m ffmpegthumbnailer mupdf playerctl \
	chromium firefox vlc \
	zsh terminator tmux \
	bluez bluez-utils blueberry \
	zip unzip muparser redshift thunar libsecret gnome-keyring \
	docker docker-compose lxappearance neovim xarchiver arandr bumblebee \
	linux-headers gcc make git python-gnupg python-pip aws-cli nodejs npm php composer ctags elixir \
	python-pylint python-pillow acpi powertop python-six libreoffice-still gnutls gnome-disk-utility \
	obs-studio dunst xdotool yad peek mono dotnet-host dotnet-runtime dotnet-sdk inotify-tools code coreutils \
    ttf-nerd-fonts-symbols nvidia nvidia-libgl nvidia-settings mesa ttf-hack ttf-anonymous-pro ttf-dejavu ttf-freefont ttf-liberation screenfetch unclutter

echo "[APPS] Install packages for development"
pip install awsebcli --upgrade --user
composer global require phpdocumentor/phpdocumentor phpmd/phpmd squizlabs/php_codesniffer
sudo npm i -g eslint lynt pug-lint-vue instant-markdown-d

echo "[APPS] Install community packages"
yay -S --needed urxvt-font-size-git python-pdftotext spotify google-chrome polybar albert shutter \
	postman-bin perl-goo-canvas mailspring \
	betterlockscreen feh the_silver_searcher \
	jmeter mariadb-jdbc \
	noto-fonts-emoji ttf-twemoji-color todoist-linux-bin \
    joplin cherrytomato compton alacritty monodevelop-bin i3-agenda-git plymouth
#	i3lock heidisql

echo "[APPS] Link xinitrc"
#ln -sf ~/.dotfiles/.xinitrc ~

echo "[APPS] Link profile"
sudo ln -sf ~/.dotfiles/profile /etc/profile
sudo chown root /etc/profile

echo "[APPS] Configure lightdm"
grep ' autologin-user=\|autologin-session=\|greeter-session='  /etc/lightdm/lightdm.conf && \
sudo sed -i 's/#autologin-user=/autologin-user=$USER/g' /etc/lightdm/lightdm.conf && \
sudo sed -i 's/#autologin-session=/autologin-session=i3/g' /etc/lightdm/lightdm.conf && \
sudo sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/g' /etc/lightdm/lightdm.conf && \
grep ' autologin-user=\|autologin-session=\|greeter-session='  /etc/lightdm/lightdm.conf

echo "[APPS] Configure bluetooth"
sudo sed -i 's/#AutoEnable=false/AutoEnable=true/g' /etc/bluetooth/main.conf

echo "[APPS] Setup oh-my-zsh"
if [ ! -d "~/.oh-my-zsh" ]; then
	curl -L http://install.ohmyz.sh | sh
fi

echo "[APPS] Setup video"
#sudo ln -sf ~/.dotfiles/20-intel.conf /etc/X11/xorg.conf.d/
#sudo ln -sf ~/.dotfiles/xorg.conf.nvidia /etc/bumblebee/

echo "[APPS] Switch user to ZSH"
chsh -s /usr/bin/zsh

echo "[APPS] Edit user groups & permissions"
sudo usermod -a -G rfkill $USER
sudo usermod -a -G docker $USER
sudo usermod -a -G bumblebee $USER

echo "%wheel ALL=(root) NOPASSWD: /home/$USER/.dotfiles/scripts/brightness_controll" | sudo EDITOR='tee -a' visudo

echo "[APPS] enable services"
#sudo systemctl enable lightdm
sudo systemctl enable bluetooth
sudo systemctl enable docker
#sudo systemctl enable tlp
sudo systemctl enable bumblebeed.service
# sudo systemctl enable powertop

sudo pip install todoist-python
