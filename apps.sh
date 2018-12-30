sudo pacman -Syu
sudo pacman -S --noconfirm ttf-dejavu
sudo pacman -S --noconfirm redshift
sudo pacman -S --noconfirm thunar
sudo pacman -S --noconfirm zip unzip
sudo pacman -S --noconfirm lxappearance
sudo pacman -S --noconfirm termite
sudo pacman -S --noconfirm xdg-utils
sudo pacman -S --noconfirm playerctl
sudo pacman -S --noconfirm openssh
sudo pacman -S --noconfirm gedit
sudo pacman -S --noconfirm xarchiver
sudo pacman -S --noconfirm ntp
sudo pacman -S --noconfirm conky
sudo pacman -S --noconfirm conky-manager

sudo systemctl enable ntpd.service
sudo systemctl start ntpd.service

sudo pacman -S --noconfirm zsh
usermod --shell /bin/zsh davis
grep davis /etc/passwd

sudo pacman -S --noconfirm pambase
sudo pacman -S --noconfirm xclip
sudo pacman -S --noconfirm wine
sudo pacman -S --noconfirm docker
sudo pacman -S --noconfirm docker-compose

sudo systemctl enable docker
sudo systemctl restart docker

curl -L http://install.ohmyz.sh | sh
gpg --recv-keys 0FC3042E345AD05D
gpg --recv-keys A2C794A986419D8A

yaourt -Syu
yaourt -S ttf-ms-fonts
yaourt -S spotify
yaourt -S playerctl
yaourt -S betterlockscreen
yaourt -S feh
yaourt -S snapd
yaourt -S discord
yaourt -S slack-desktop
yaourt -S telegram-desktop
yaourt -S postman-bin
yaourt -S shutter
yaourt -S perl-goo-canvas
yaourt -S wine
yaourt -S heidisql
yaourt -S xkb-switch
yaourt -S powerline-fonts
yaourt -S google-chrome
yaourt -S gitkraken

sudo systemctl enable --now apparmor.service
sudo systemctl enable --now snapd.apparmor.service
sudo systemctl enable --now snapd
sudo systemctl restart snapd

sudo chmod +x /etc/profile.d/snapd.sh 
cd /etc/profile.d/ && ./snapd.sh

sudo ln -s /var/lib/snapd/snap /snap
sudo snap install vscode --classic

sudo ln -s /var/lib/snapd/snap/bin/gitkraken /usr/bin/
sudo ln -s /var/lib/snapd/snap/bin/code /var/lib/snapd/snap/code
