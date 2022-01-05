#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# disable C-s which freezes the terminal, C-s is used for search forward in histtory
stty -ixon

# `.profile` sets PATH
source $HOME/.profile

PATH=~/.bin:$PATH

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set the title to just `dir$`
PS1='\[\033[01;34m\]\w\[\033[00m\]\$ ' # this is used

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f ~/.lyst_bashrc ]; then
    . ~/.lyst_bashrc
fi

# use vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# use vim mode keymapping in bash shell
set -o vi

# ls aliases
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls --human-readable --color --classify'
# directories first, with alphanumeric sorting
alias ll='ls --all -l --group-directories-first'
alias la='ls --almost-all' # Show hidden files but not . and ..

# git aliases
function g_get_main_branch_name() {
    main_branch_name=$(git branch | grep --only-matching -e 'master' -e 'main')
    echo "$main_branch_name"
}
alias ga='git add'
alias gb='git branch'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gs='git status'

alias gd='git diff'
alias gdc='git diff --cached'
alias gdw='git diff --word-diff=color'
function gdu() {
    git diff "upstream/$(g_get_main_branch_name)"...
}
function gduw() {
    git diff --word-diff=color "upstream/$(g_get_main_branch_name)"...
}

alias gg='git grep'

alias g_delete_branches='git branch | grep -v "main" | grep -v "master" | grep -v "*" | xargs git branch -D'

alias gfu='git fetch upstream'
function gfru() {
    git fetch upstream
    git rebase -i "upstream/$(g_get_main_branch_name)"
}

alias g_set_no_push='git remote set-url --push upstream nopush'


function g_new_branch() {
    has_changes=$(git status --porcelain=v1 2>/dev/null | wc -l)
    if [ "$has_changes" == "1" ]; then
        echo "Current branch has changes. Stopping!"
        return
    fi
    git fetch upstream "$(g_get_main_branch_name):$1"
    git switch "$1"
}

alias gl='git log'

# pinta
alias pinta_last='pinta "$(ls -t | head -n 1)"'

# use bluetoothctl to connect to bluetooth devices
function btspeaker() {
    bluetooth_sink_index=$(pactl list short sinks | grep blue | grep -o "^[1-9]*")
   pactl set-default-sink "$bluetooth_sink_index"
}

# disable dunst notification service temporarily
# https://wiki.archlinux.org/title/Dunst
# add file for exsitence check in i3 status bar
# Update i3 status
alias notification_disable='killall -SIGUSR1 dunst && touch /tmp/notification_disable && killall -SIGUSR1 i3status'
alias notification_enable='killall -SIGUSR2 dunst && rm /tmp/notification_disable && killall -SIGUSR1 i3status'

# source autojump, usage `j foo`
. /usr/share/autojump/autojump.sh

# xclip
alias xclip='xclip -selection clipboard'
alias xclip_png='xclip -selection clipboard -t image/png'
alias xclip_last_png='xclip -selection clipboard -t image/png "$(ls -t *.png | head -n 1)"'

# vpn
alias vpn_connect='openvpn3 session-start --config ~/Documents/openvpn/client.ovpn'
alias vpn_disconnect='openvpn3 session-manage --disconnect --config ~/Documents/openvpn/client.ovpn'

# gh
alias mypr='gh api -X GET search/issues -f q="author:tigerhuang state:open type:pr" | jq ".items[].title"'

# make alias
alias mfl='make format && make lint'
# make all
alias ma='make format && make lint && make pytest'
# make pytest last failed
alias mpf='make pytest TEST_ARGS="-vvv --last-failed"'

# shortcut to start venv
alias activate='source .venv/bin/activate'

export PATH="$HOME/.poetry/bin:$PATH"

# open todo system
alias todo='ranger ~/Documents/private-docs/todos-system/todo'

# find meeting today
alias agenda='date && gcalcli agenda 09:00 18:00 --nostarted --nodeclined'

complete -C /usr/local/bin/terraform terraform

