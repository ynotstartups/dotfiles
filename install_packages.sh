#!/bin/sh
set -o errexit -o nounset -o xtrace

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

# install python3
sudo apt-get install --yes python3
# symlink python to python3
sudo apt-get install --yes python-is-python3

# install shellcheck
sudo apt-get install --yes shellcheck

# use xbacklight -set 50, the range is 0 - 100
sudo apt-get install --yes xbacklight

# dictionary, for example `dict tiger`
sudo apt-get install --yes dict dictd dict-gcide

# automatically change display setting when connected to external monitor
sudo apt-get install --yes autorandr

# gh auth login --web --hostname abc.com
if ! command -v gh
then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt install gh
fi

# You might also want to install
# 1password - https://1password.com/downloads/linux/
# chrome - https://www.google.com/intl/en_uk/chrome/
# docker - https://docs.docker.com/engine/install/ubuntu/
# openvpn3 - https://docs.docker.com/engine/install/ubuntu/
# slack - sudo snap install slack --classic
# zoom - https://zoom.us/download
