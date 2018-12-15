# /bin/bash

sudo pacman -Sy playerctl

ln -sv ~/dotfiles/.bash_profile ~
ln -sv ~/dotfiles/i3 ~/.config
ln -sv ~/dotfiles/.xinitrc ~
ln -sv ~/dotfiles/.gtkrc-2.0 ~
ln -sv ~/dotfiles/gtk-2.0 ~/.config/gtk-2.0
ln -sv ~/dotfiles/gtk-3.0 ~/.config/gtk-3.0
ln -sv ~/dotfiles/fonts ~/.fonts

sudo chmod +x i3/blocks/rofi-calendar/rofi-calendar
