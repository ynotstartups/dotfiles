set -o errexit -o nounset -o xtrace -o pipefail

sudo apt-get update

sudo apt-get install --yes git
# also remember to add ssh key to github

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

# gimp image editor tool
sudo apt-get install --yes gimp

# You might also want to install
# 1password - https://1password.com/downloads/linux/
# chrome - https://www.google.com/intl/en_uk/chrome/
# docker - https://docs.docker.com/engine/install/ubuntu/
# openvpn3 - https://docs.docker.com/engine/install/ubuntu/
# slack - sudo snap install slack --classic
# zoom - https://zoom.us/download
