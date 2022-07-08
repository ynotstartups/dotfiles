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
# alias fgrep='fgrep --color=auto'
# alias egrep='egrep --color=auto'


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
    git diff "upstream/$(g_get_main_branch_name)"...
}

alias gdelete_branches='git branch | grep -v "main" | grep -v "master" | grep -v "*" | xargs git branch -D'

function gfru() {
    git fetch upstream
    git rebase -i "upstream/$(g_get_main_branch_name)"
}


function gnew_branch() {
    has_changes=$(git status --porcelain=v1 2>/dev/null | wc -l)
    if [ "$has_changes" == "1" ]; then
        echo "Current branch has changes. Stopping!"
        return
    fi
    git fetch upstream "$(g_get_main_branch_name):$1"
    git switch "$1"
}

function g_root() {
    cd "$(git rev-parse --show-toplevel)" || exit
}

alias g_copy_log_body='git --no-pager log -1 --pretty=format:%b | copy'

# pinta
alias pinta_last='pinta "$(ls -t | head -n 1)"'

# source autojump, usage `j foo`
. /usr/share/autojump/autojump.sh

# xclip
alias copy='xclip -selection clipboard'
alias copy_png='xclip -selection clipboard -t image/png'
alias copy_last_png='xclip -selection clipboard -t image/png "$(ls -t *.png | head -n 1)"'

# vpn
alias vpn_connect='openvpn3 session-start --config ~/Documents/openvpn/client.ovpn'
alias vpn_disconnect='openvpn3 session-manage --disconnect --config ~/Documents/openvpn/client.ovpn'

# make all
alias ma='make format && make lint && make coverage-report-terminal'

# shortcut to start venv
alias activate='source .venv/bin/activate'

# open todo system
alias todo='~/Documents/private-docs/todos-system/bin/todo.py ~/Documents/private-docs/todos-system'
alias todow='~/Documents/private-docs/todos-system/bin/todo.py ~/Documents/personal-docs/todos-system'

# find meeting today

function agenda() {
    date
    gcalcli agenda 09:00 18:00 --tsv --details conference --details location --nodeclined
}

# export it for usage in vim
export -f agenda

alias a='agenda'
alias aw='gcalcli calw'
alias am='gcalcli calm'

## Duck Duck Go
# q for query
alias q='ddgr --num 5 --noprompt --expand --reverse'
alias qo='ddgr --num 1 --ducky'

## Vim

alias v='vim'

alias vlast='vim $(ls -t -1 | head -n 1)'

# type vn to autocomplete notes
NOTES_DIR="$HOME/Documents/notes/notes/"
alias vn="cd $NOTES_DIR && vim"

_notes () {
    IFS=$'\n' tmp=( $(compgen -W "$(ls "$NOTES_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -F _notes vn

WORK_NOTES_DIR="$HOME/Documents/personal-docs/"
alias vp="cd $WORK_NOTES_DIR && vim"
_work_notes () {
    IFS=$'\n' tmp=( $(compgen -W "$(ls "$WORK_NOTES_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -F _work_notes vp

DOTFILES_DIR="$HOME/Documents/dotfiles/"
alias vd="cd $DOTFILES_DIR && vim"
_dotfiles () {
    IFS=$'\n' tmp=( $(compgen -W "$(ls "$DOTFILES_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -F _dotfiles vd
## ----

## Bookmarks

# open bookmarks
alias bm='vim ~/Documents/notes/notes/bookmarks.md'

# open work related bookmarks
alias bmw='vim ~/Documents/personal-docs/bookmarks.md'
## ----

## Reminders

# open files
alias r='vim ~/Documents/notes/notes/reminders.md'
alias i='vim ~/Documents/notes/notes/ideas.md'
## ----

alias music-dl='youtube-dl --extract-audio --audio-quality 0 --no-part --output "%(title)s.%(ext)s"'

alias crawl-tiles='crawl-tiles -rc ~/Documents/dotfiles/.crawlrc'

## get weather
alias w='curl wttr.in/?0' # weather now
alias wa='curl wttr.in/' # weather today and forecast for next two days

## get local ip
alias ip-local='ifconfig -a | grep -A 1 wlan0'

## get cheatsheet from cheat.sh e.g. cheatsheet sed
function cheatsheet() {
    curl cheat.sh/"$1"
}

## image viewer

alias image='eog'

## newsboat

alias n='newsboat -u ~/Documents/private_dotfiles/urls'
alias nw='newsboat -u ~/Documents/private_dotfiles/urls-work'

# download podcasts
# alias p='podboat'

alias restart_display_manager='sudo systemctl restart display-manager'

## alarm with sound

function speaker() {
   internal_sound_card='alsa_card.pci-0000_02_00.3'

   readarray -t other_card_indexs < <(pactl list cards short | grep -v "$internal_sound_card" | grep --only-matching ^[1-9]*)

   # turn off non internal sound card, could be HDMI, ps controller ...
   for card_index in "${other_card_indexs[@]}"
   do
       pactl set-card-profile $card_index off
   done

    # set internal sound card to use speaker
    pactl set-card-profile "$internal_sound_card" output:builtin-speaker+input:builtin-mic
}

# music is not played if I close the terminal window with command+shift+q
# but using exit is okay
# exit is used to avoid me using command+shift+q

# e.g. alarm 1m meeting planning in 5 minutes
function alarm() {
    if [[ $# -eq 1 ]] ;
    then
        echo 'Missing notification message!'
        echo "e.g. alarm $1 FOO"
    else
        subject=$2
        message=$(printf '%s ' "${@:3}")

        nohup sleep "$1" && notify-send $subject "$message" &
        # nohup sleep "$1" && speaker && notify-send $subject "$message" && vlc ~/Music/Franz\ Liszt\ -\ Liebestraum\ -\ Love\ Dream.m4a &
        exit
    fi
}

# e.g. alarm 14:55 meeting planning in 5 minutes
function alarm_at() {
    subject=$2
    message=$(printf '%s ' "${@:3}")

    current_epoch=$(date +%s) # +%s is required for the sleep second calculation
    target_epoch=$(date -d "$1" +%s)
    sleep_seconds=$(( $target_epoch - $current_epoch ))

    nohup sleep "$sleep_seconds" && speaker && notify-send $subject "$message" && vlc ~/Music/Franz\ Liszt\ -\ Liebestraum\ -\ Love\ Dream.m4a &

    exit
}

## Notification

alias notification_disable='killall -SIGUSR1 dunst && touch /tmp/notification_disable && killall -SIGUSR1 i3status'
alias notification_enable='killall -SIGUSR2 dunst && rm /tmp/notification_disable && killall -SIGUSR1 i3status'


## Docker

# drop into bash within container with vi readline keymappings
function mb(){
    user_id=$(id -u)
    current_directory=$(pwd)
    base_directory=$(basename "$current_directory")

    docker-compose run --user "$user_id:$user_id" --rm "$base_directory" bash -o vi
}

alias linux_sandbox_root='docker run --rm --tty --interactive busybox'
alias linux_sandbox='docker run --rm --user nobody --tty --interactive busybox'

## manual pages

# open manual page in vim read only mode and set filetype to man
function man() {
    /usr/bin/man "$1" | vim -R '-c silent bufdo set filetype=man'  -
}

## Github

# My Open PRs
alias p="gh api -X GET search/issues -f q='is:open state:open author:tigerhuang' | jq '.items[] | {title, html_url}'"

# Open PRs Waiting For My Review
alias pw="gh api -X GET search/issues -f q='is:open review:none review-requested:tigerhuang' | jq '.items[] | {title, html_url}'"

## Autocomplete

complete -C /usr/local/bin/terraform terraform

eval "$(gh completion -s bash)"

## Rg
export RIPGREP_CONFIG_PATH=~/Documents/dotfiles/.rgrc

## nvm - node version manager

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## i3
alias lock='i3lock'

## turnoff
alias turnoff='poweroff'
