pacman -S redshift thunar zip unzip lxappearance termite xdg-utils playerctl openssh zsh pambase # docker
curl -L http://install.ohmyz.sh | sh
#sudo groupadd docker
#sudo usermod -aG docker $USER
gpg --recv-keys 0FC3042E345AD05D
yaourt -S spotify playerctl betterlockscreen feh snapd discord slack-desktop telegram-desktop postman shutter perl-goo-canvas heidisql xkb-switch powerline-fonts
sudo systemctl enable --now apparmor.service
sudo systemctl enable --now snapd.apparmor.service
sudo systemctl restart snapd
sudo snap install gitkraken

sudo chmod +x /etc/profile.d/snapd.sh 
cd /etc/profile.d/ && ./snapd.sh

sudo ln -s /var/lib/snapd/snap /snap
sudo snap install vscode --classic

sudo ln -s /var/lib/snapd/snap/bin/gitkraken /usr/bin/
sudo ln -s /var/lib/snapd/snap/bin/code /var/lib/snapd/snap/code
