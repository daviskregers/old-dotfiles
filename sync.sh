# /bin/bash

ln -sv ~/dotfiles/.bash_profile ~
ln -sv ~/dotfiles/config ~/.config
ln -sv ~/dotfiles/.xinitrc ~
ln -sv ~/dotfiles/.gtkrc-2.0 ~
ln -sv ~/dotfiles/gtk-2.0 ~/.config/gtk-2.0
ln -sv ~/dotfiles/gtk-3.0 ~/.config/gtk-3.0
ln -sv ~/dotfiles/fonts ~/.fonts
ln -sv ~/dotfiles/.zshrc ~
ln -sv ~/dotfiles/.oh-my-zsh ~
ln -sv ~/dotfiles/.yaourtrc ~

sudo chmod +x ~/.config/i3/conky.sh 
