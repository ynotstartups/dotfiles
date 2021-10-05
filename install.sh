#!/bin/sh
set -o errexit -o nounset -o xtrace

XDG_CONFIG_HOME="$HOME/.config"

echo soft linking i3 config
mkdir -p $XDG_CONFIG_HOME/i3
ln -sf $PWD/i3-config $XDG_CONFIG_HOME/i3/config

echo soft linking i3status config
mkdir -p $XDG_CONFIG_HOME/i3status
ln -sf $PWD/i3status-config $XDG_CONFIG_HOME/i3status/config

echo install ctags configs
mkdir -p $XDG_CONFIG_HOME/git
ln -sf $PWD/.gitignore $XDG_CONFIG_HOME/git/ignore

echo install vim configs
ln -sf $PWD/.vimrc $HOME/.vimrc

echo install inputrc
ln -sf $PWD/.inputrc $HOME/.inputrc

echo install bash profile
ln -sf $PWD/.bash_profile $HOME/.bash_profile

echo install bashrc
ln -sf $PWD/.bashrc $HOME/.bashrc
. $HOME/.bashrc

echo install ctags configs
ln -sf $PWD/.ctags $HOME/.ctags

# the dpi settings will be likely wrong in other laptops
# you can tweak it and git ignore locally this files
echo install X Window System files
ln -sf $PWD/.xinitrc $HOME/.xinitrc
ln -sf $PWD/.Xresources $HOME/.Xresources

echo install custom scripts
mkdir -p $HOME/.bin
ln -sf $PWD/toggle_monitor $HOME/.bin/toggle_monitor
ln -sf $PWD/toggle_sound $HOME/.bin/toggle_sound

# https://askubuntu.com/questions/362914/how-to-prevent-the-power-button-to-shutdown-directly-the-system
echo avoid power button shutting down computer
filename=/etc/systemd/logind.conf
# https://stackoverflow.com/questions/4749330/how-to-test-if-string-exists-in-file-with-bash
if ! grep -Fxq 'HandlePowerKey=ignore' $filename
then
    echo 'HandlePowerKey=ignore' | sudo tee -a $filename > /dev/null
fi 
