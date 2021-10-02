set -euxo pipefail

sudo apt-get update

sudo apt-get install --yes git

# a window manager
sudo apt-get install --yes i3

# formats json string from standard input
sudo apt-get install --yes jq

# Vim with clipboard support
sudo apt-get install --yes vim-gtk3

# ctags
sudo apt-get install --yes exuberant-ctags

# media player
sudo apt-get install --yes vlc

# system monitor
sudo apt-get install --yes htop

# ssh server to allow ssh access from other computers
sudo apt-get install --yes openssh-server

# You might also want to install
# 1password, chrome
