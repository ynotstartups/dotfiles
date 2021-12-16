#!/bin/sh
set -o errexit -o nounset -o xtrace

XDG_CONFIG_HOME="$HOME/.config"

echo soft linking i3 config
mkdir -p "$XDG_CONFIG_HOME"/i3
ln -sf "$PWD"/i3-config "$XDG_CONFIG_HOME"/i3/config

echo soft linking i3status config
mkdir -p "$XDG_CONFIG_HOME"/i3status
ln -sf "$PWD"/i3status-config "$XDG_CONFIG_HOME"/i3status/config

echo install ctags configs
mkdir -p "$XDG_CONFIG_HOME"/git
ln -sf "$PWD"/.gitignore "$XDG_CONFIG_HOME"/git/ignore

echo install vim configs
ln -sf "$PWD"/.vimrc "$HOME"/.vimrc

echo install inputrc
ln -sf "$PWD"/.inputrc "$HOME"/.inputrc

echo install bash profile
ln -sf "$PWD"/.bash_profile "$HOME"/.bash_profile

echo install bashrc
ln -sf "$PWD"/.bashrc "$HOME"/.bashrc
# shellcheck source=.bashrc
. "$HOME"/.bashrc

echo install ctags configs
ln -sf "$PWD"/.ctags "$HOME"/.ctags

# the dpi settings will be likely wrong in other laptops
# you can tweak it and git ignore locally this files
echo install X Window System files
ln -sf "$PWD"/.xinitrc "$HOME"/.xinitrc
ln -sf "$PWD"/.Xresources "$HOME"/.Xresources

echo install custom scripts
mkdir -p "$HOME"/.bin
ln -sf "$PWD"/toggle_monitor "$HOME"/.bin/
ln -sf "$PWD"/toggle_sound "$HOME"/.bin/
ln -sf "$PWD"/copy_last_to_today.py "$HOME"/.bin/copy_last_to_today
ln -sf "$PWD"/music_mode "$HOME"/.bin/
ln -sf "$PWD"/video_mode "$HOME"/.bin/

# https://askubuntu.com/questions/362914/how-to-prevent-the-power-button-to-shutdown-directly-the-system
echo avoid power button shutting down computer
logind_config=/etc/systemd/logind.conf
# https://stackoverflow.com/questions/4749330/how-to-test-if-string-exists-in-file-with-bash
if ! grep -Fxq 'HandlePowerKey=ignore' "$logind_config"
then
    echo 'HandlePowerKey=ignore' | sudo tee -a "$logind_config" > /dev/null
fi 

echo enable DNS over TLS
resolved_config=/etc/systemd/resolved.conf
if ! grep -Fxq 'DNSOverTLS=yes' "$resolved_config"
then
    echo 'DNSOverTLS=yes' | sudo tee -a "$resolved_config" > /dev/null
fi
# set Blank Screen as never, never turn off screen
gsettings set org.gnome.desktop.session idle-delay 0
