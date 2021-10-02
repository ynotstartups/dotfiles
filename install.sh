set -euxo pipefail

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

echo install bash profile
ln -sf $PWD/.bash_profile $HOME/.bash_profile

echo install ctags configs
ln -sf $PWD/.ctags $HOME/.ctags

echo install X Window System files
ln -sf $PWD/.xinitrc $HOME/.xinitrc
ln -sf $PWD/.Xresources $HOME/.Xresources
