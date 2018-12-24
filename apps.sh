#pacman -Sy redshift thunar zip unzip lxappearance termite xdg-utils playerctl openssh zsh pambase # docker
sudo pacman -Sy --noconfirm redshift
sudo pacman -Sy --noconfirm thunar
sudo pacman -Sy --noconfirm zip unzip
sudo pacman -Sy --noconfirm lxappearance
sudo pacman -Sy --noconfirm termite
sudo pacman -Sy --noconfirm xdg-utils
sudo pacman -Sy --noconfirm playerctl
sudo pacman -Sy --noconfirm openssh
sudo pacman -Sy --noconfirm zsh
sudo pacman -Sy --noconfirm pambase
sudo pacman -Sy --noconfirm xclip

curl -L http://install.ohmyz.sh | sh
#sudo groupadd docker
#sudo usermod -aG docker $USER
gpg --recv-keys 0FC3042E345AD05D
gpg --recv-keys A2C794A986419D8A

#yaourt -Sy spotify playerctl betterlockscreen feh snapd discord slack-desktop telegram-desktop postman shutter perl-goo-canvas wine heidisql xkb-switch powerline-fonts
yaourt -Sy spotify
yaourt -Sy playerctl
yaourt -Sy betterlockscreen
yaourt -Sy feh
yaourt -Sy snapd
yaourt -Sy discord
yaourt -Sy slack-desktop
yaourt -Sy telegram-desktop
yaourt -Sy postman
yaourt -Sy shutter
yaourt -Sy perl-goo-canvas
yaourt -Sy wine
yaourt -Sy heidisql
yaourt -Sy xkb-switch
yaourt -Sy powerline-fonts
yaourt -Sy google-chrome

sudo systemctl enable --now apparmor.service
sudo systemctl enable --now snapd.apparmor.service
sudo systemctl enable --now snapd
sudo systemctl restart snapd
sudo snap install gitkraken

sudo chmod +x /etc/profile.d/snapd.sh 
cd /etc/profile.d/ && ./snapd.sh

sudo ln -s /var/lib/snapd/snap /snap
sudo snap install vscode --classic

sudo ln -s /var/lib/snapd/snap/bin/gitkraken /usr/bin/
sudo ln -s /var/lib/snapd/snap/bin/code /var/lib/snapd/snap/code
