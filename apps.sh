pacman -S redshift thunar zip unzip lxappearance termite xdg-utils playerctl openssh
yaourt -S spotify playerctl betterlockscreen feh snapd
systemctl enable --now apparmor.service
systemctl enable --now snapd.apparmor.service
systemctl restart snapd
sudo snap install gitkraken

sudo chmod +x /etc/profile.d/snapd.sh 
cd /etc/profile.d/ && ./snapd.sh

sudo ln -s /var/lib/snapd/snap /snap
sudo snap install vscode --classic

sudo ln -s /var/lib/snapd/snap/bin/gitkraken /usr/bin/
sudo ln -s /var/lib/snapd/snap/bin/code /var/lib/snapd/snap/code