XDG_CONFIG_HOME="$HOME/.config"

echo soft linking i3 config
mkdir -p $XDG_CONFIG_HOME/i3
ln -sf $PWD/i3-config $XDG_CONFIG_HOME/i3/config

echo soft linking i3status config
mkdir -p $XDG_CONFIG_HOME/i3status
ln -sf $PWD/i3status-config $XDG_CONFIG_HOME/i3status/config

echo install vim configs
ln -sf $PWD/.vimrc $HOME/.vimrc

echo install bash profile
ln -sf $PWD/.bash_profile $HOME/.bash_profile
