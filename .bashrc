#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# case $- in
#     *i*) ;;
#       *) return;;
# esac

# disable C-s which freezes the terminal, C-s is used for search forward in histtory
stty -ixon

PATH=~/.bin:$PATH

export PATH="$HOME/.poetry/bin:$PATH"

# Add path for krew, kubectl plugin manager
export PATH="$PATH:$HOME/.krew/bin"

# Add path for .local bin
export PATH="$PATH:$HOME/.local/bin"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Turn off history expansion for using DuckDuckGo bang ! in terminal
# Example for history expansion
# !! expand to the last command
# !n expand the command with history number "n"
set +H

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

alias e='exit'

alias grep='grep --color=auto --ignore-case'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

if [ -f ~/.lyst_bashrc ]; then
    source ~/.lyst_bashrc
fi

# use vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# use vim mode keymapping in bash shell
set -o vi
# reset cursor to normal before other programs run
PS0="\e[2 q\2"

# ls aliases
# Add colors for filetype, human-readable sizes by default on 'ls', shows dot files
alias ls='ls --human-readable --color --classify --almost-all'
# directories first, with alphanumeric sorting
alias ll='ls --almost-all -l --group-directories-first'
alias lt='ls --almost-all -l --group-directories-first -t'

alias d='date'

# jq aliases

# color json output using jq with pager
alias jqless='jq -C | less -r'

# git aliases
alias g='git'
source /usr/share/bash-completion/completions/git 2>/dev/null
__git_complete g __git_main

function g_get_main_branch_name() {
    main_branch_name=$(git branch | grep --only-matching -e 'master' -e 'main')
    echo "$main_branch_name"
}

# I always mistype `g s` to `gs`, set `gs` to an alias too
alias gs="git status"

function gdu() {
    git diff "upstream/$(g_get_main_branch_name)"... "$@"
}

alias ,gdelete_branches='git branch | grep -v "main" | grep -v "master" | grep -v "*" | xargs git branch -D'

function gfru() {
    git fetch --prune origin
    git fetch --prune upstream
    git rebase -i "upstream/$(g_get_main_branch_name)"
}

function ,gconfig_personal() {
    git config --global user.email "ynotstartups@gmail.com"
    git config --global user.name "ynotstartups"
}

function ,gnew_branch_jira() {
    has_changes=$(git status --porcelain=v1 2>/dev/null | wc -l)
    if [ "$has_changes" == "1" ]; then
        echo "Current branch has changes. Stopping!"
        return
    fi
    new_branch_name=$(automation --tickets-branch-format | fzf --height 20 --header 'jira tickets')
    git fetch upstream "$(g_get_main_branch_name):$new_branch_name"
    git switch "$new_branch_name"
}

# todo if $1 is not provided use jira ticket instead
function ,gnew_branch() {
    has_changes=$(git status --porcelain=v1 2>/dev/null | wc -l)
    if [ "$has_changes" == "1" ]; then
        echo "Current branch has changes. Stopping!"
        return
    fi
    git fetch upstream "$(g_get_main_branch_name):$1"
    git switch "$1"
}

function groot() {
    cd "$(git rev-parse --show-toplevel)" || exit
}

function gswitch() {
    git switch $(git for-each-ref refs/heads/ --format='%(refname:short)' | fzf)
}

alias gcopy_log_body='git --no-pager log -1 --pretty=format:%b | copy'

## github alias

# `git --no-pager log -1 --pretty=format:%b` prints out commit message body of last commit
# `gh pr edit --body-file` takes string from stdin
alias ,gh_update_pr_description='git --no-pager log -1 --pretty=format:%b | gh pr edit --body-file -'
alias ,gh_create_pr='gh pr create -f'

# pinta
alias ,pinta_last='pinta "$(ls -t | head -n 1)"'

# source autojump, usage `j foo`
source /usr/share/autojump/autojump.sh

# xclip
alias ,copy='xclip -selection clipboard'
alias ,copy_png='xclip -selection clipboard -t image/png'
alias ,copy_last_png='xclip -selection clipboard -t image/png "$(ls -t *.png | head -n 1)"'

# vpn
alias ,vpn_connect='openvpn3 session-start --config ~/Documents/openvpn/client.ovpn'
alias ,vpn_disconnect='openvpn3 session-manage --disconnect --config ~/Documents/openvpn/client.ovpn'

# make all
alias ma='make format && make lint && make coverage-report-terminal; notify-send "make done"'


# o for open
alias o='xdg-open'

# shortcut to start venv
alias ,activate='source .venv/bin/activate'
alias ,virtualenv_setup='python3 -m venv .venv'

# find meeting today
alias a='automation --meetings'
alias aw='gcalcli calw'
alias am='gcalcli calm'


## Vim

# used in `sn` standup new
alias vlast='vim $(ls -t -1 | head -n 1)'

# open files
alias r='vim ~/Documents/notes/notes/reminders.md'
alias i='vim ~/Documents/notes/notes/ideas.md'

alias ,music_download='yt-dlp --extract-audio --audio-quality 0 --no-part --output "%(title)s.%(ext)s"'

## get weather
alias w='curl wttr.in/?0' # weather now
alias wa='curl wttr.in/' # weather today and forecast for next two days

## get local ip
alias ,ip_local='ifconfig -a | grep -A 1 wlan0'

## get cheatsheet from cheat.sh e.g. cheatsheet sed
function cheatsheet() {
    curl cheat.sh/"$1"
}

## newsboat

alias n='newsboat --url-file ~/Documents/private_dotfiles/urls --cache-file ~/.newsboat/cache-work.db --refresh-on-start'
alias nw='newsboat --url-file ~/Documents/private_dotfiles/urls-work --cache-file ~/.newsboat/cache.db --refresh-on-start'

alias ,restart_display_manager='sudo systemctl restart display-manager'

# restart network manager and disable ethernet
alias ,restart_network_manager='sudo service network-manager restart'
alias ,ethernet_disconnect='nmcli device disconnect enxacde48001122'

# kill zoom

alias ,killzoom='killall zoom'

## Notification

alias ,notification_disable='killall -SIGUSR1 dunst && touch /tmp/notification_disable && killall -SIGUSR1 i3status'
alias ,notification_enable='killall -SIGUSR2 dunst && rm /tmp/notification_disable && killall -SIGUSR1 i3status'

## Docker

# drop into bash within container with vi readline keymappings
function mb(){
    user_id=$(id -u)
    current_directory=$(pwd)
    base_directory=$(basename "$current_directory")

    docker-compose run --user "$user_id:$user_id" --rm "$base_directory" bash -o vi
}

alias ,linux_sandbox_root='docker run --rm --tty --interactive busybox'
alias ,linux_sandbox='docker run --rm --user nobody --tty --interactive busybox'

## manual pages

# open manual page in vim read only mode and set filetype to man
function man() {
    /usr/bin/man "$1" | vim -R '-c silent bufdo set filetype=man'  -
}

## Autocomplete

complete -C /usr/local/bin/terraform terraform

eval "$(gh completion -s bash)"

## Rg
export RIPGREP_CONFIG_PATH=~/Documents/dotfiles/.rgrc

## turnoff
alias ,turnoff='poweroff'

## dict

dict() {
    /usr/bin/dict "$1" | less
}

alias ,open_ports='sudo netstat --listening --programs --tcp --numeric-hosts --numeric-ports'

alias ,internet='ping 1.1.1.1'

# fzf
export FZF_DEFAULT_OPTS="--multi
    --bind 'ctrl-a:select-all'
"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/Documents/dotfiles/fzf-git.sh ] && source ~/Documents/dotfiles/fzf-git.sh

## python programmer alias for bash functions

# python "string"[0:] - bash slice 1-
alias ,slice='cut -c'

alias ,ctags_generate_for_python='ctags **/*.py'
alias ,generate_ctags_for_python='ctags **/*.py'

# python argcomplete bash completion
# https://kislyuk.github.io/argcomplete/#activating-global-completion
[ -f ~/Documents/dotfiles/python_argcomplete ] && source ~/Documents/dotfiles/python_argcomplete

# poetry bash completion
# https://kislyuk.github.io/argcomplete/#activating-global-completion
[ -f ~/Documents/dotfiles/poetry_bash_completion ] && source ~/Documents/dotfiles/poetry_bash_completion

alias ,poetry_update_dependencies='poetry update --lock'

alias ,top='bpytop'
alias ,performance='bpytop'

# ,brightness_set 0.5
# ,brightness_set 0.8
alias ,brightness_set='xrandr --output eDP-1 --brightness'

alias ,mouse_set_left_hand='xmodmap -e "pointer = 3 2 1"'
alias ,mouse_set_right_hand='xmodmap -e "pointer = 1 2 3"'

# stand up
alias sn='cd ~/Documents/private-docs/standup && copy_last_to_today && vlast'

s() {
    vim ~/Documents/private-docs/standup/$(ls -t -1 ~/Documents/private-docs/standup | head -n 1)
}

# fake simple fd
alias fd='find . | grep '

function ,c() {
    filename=${1::-2}
    gcc "$filename.c" -o "./out/$filename.out" && "./out/$filename.out"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
