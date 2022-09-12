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
    git fetch --prune origin
    git fetch --prune upstream
    git rebase -i "upstream/$(g_get_main_branch_name)"
}


function gnew_branch_jira() {
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
function gnew_branch() {
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
alias gupdate_pr_description='git --no-pager log -1 --pretty=format:%b | gh pr edit --body-file -'

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

# find meeting today
alias a='automation --meetings'
alias aw='gcalcli calw'
alias am='gcalcli calm'

## Duck Duck Go
# q for query
alias q='ddgr --num 3 --noprompt --expand --reverse'
alias qo='ddgr --num 1 --ducky'

## Vim

alias v='vim'

alias vlast='vim $(ls -t -1 | head -n 1)'

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

alias n='newsboat --url-file ~/Documents/private_dotfiles/urls --cache-file ~/.newsboat/cache-work.db --refresh-on-start'
alias nw='newsboat --url-file ~/Documents/private_dotfiles/urls-work --cache-file ~/.newsboat/cache.db --refresh-on-start'

# download podcasts
# alias p='podboat'

alias restart_display_manager='sudo systemctl restart display-manager'
alias restart_network_manager='sudo service network-manager restart'

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

## turnoff
alias turnoff='poweroff'

## use qalc to calculate

alias calculate='qalc'

## dict

dict() {
    /usr/bin/dict "$1" | less
}

alias open-ports='sudo netstat --listening --programs --tcp --numeric-hosts --numeric-ports'

alias ,internet='ping 1.1.1.1'

# fzf
export FZF_DEFAULT_OPTS="--multi
    --bind 'ctrl-a:select-all' \
    --bind up:ignore \
    --bind down:ignore
"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

## python programmer alias for bash functions

# python "string"[0:] - bash slice 1-
alias slice='cut -c'


# python argcomplete
__python_argcomplete_expand_tilde_by_ref () {
    if [ "${!1:0:1}" = "~" ]; then
        if [ "${!1}" != "${!1//\/}" ]; then
            eval $1="${!1/%\/*}"/'${!1#*/}';
        else
            eval $1="${!1}";
        fi;
    fi
}

# Run something, muting output or redirecting it to the debug stream
# depending on the value of _ARC_DEBUG.
# If ARGCOMPLETE_USE_TEMPFILES is set, use tempfiles for IPC.
__python_argcomplete_run() {
    if [[ -z "${ARGCOMPLETE_USE_TEMPFILES-}" ]]; then
        __python_argcomplete_run_inner "$@"
        return
    fi
    local tmpfile="$(mktemp)"
    _ARGCOMPLETE_STDOUT_FILENAME="$tmpfile" __python_argcomplete_run_inner "$@"
    local code=$?
    cat "$tmpfile"
    rm "$tmpfile"
    return $code
}

__python_argcomplete_run_inner() {
    if [[ -z "${_ARC_DEBUG-}" ]]; then
        "$@" 8>&1 9>&2 1>/dev/null 2>&1
    else
        "$@" 8>&1 9>&2 1>&9 2>&1
    fi
}

# Scan the beginning of an executable file ($1) for a regexp ($2). By default,
# scan for the magic string indicating that the executable supports the
# argcomplete completion protocol. By default, scan the first kilobyte;
# if $3 is set to -n, scan until the first line break up to a kilobyte.
__python_argcomplete_scan_head() {
    read -s -r ${3:--N} 1024 < "$1"
    [[ "$REPLY" =~ ${2:-PYTHON_ARGCOMPLETE_OK} ]]
}

__python_argcomplete_scan_head_noerr() {
    __python_argcomplete_scan_head "$@" 2>/dev/null
}

_python_argcomplete_global() {
    local executable=$1
    __python_argcomplete_expand_tilde_by_ref executable

    local ARGCOMPLETE=0
    if [[ "$executable" == python* ]] || [[ "$executable" == pypy* ]]; then
        if [[ "${COMP_WORDS[1]}" == -m ]]; then
            if __python_argcomplete_run "$executable" -m argcomplete._check_module "${COMP_WORDS[2]}"; then
                ARGCOMPLETE=3
            else
                return
            fi
        elif [[ -f "${COMP_WORDS[1]}" ]] && __python_argcomplete_scan_head_noerr "${COMP_WORDS[1]}"; then
            local ARGCOMPLETE=2
        else
            return
        fi
    elif type -P "$executable" >/dev/null 2>&1; then
        local SCRIPT_NAME=$(type -P "$executable")
        if (type -t pyenv && [[ "$SCRIPT_NAME" = $(pyenv root)/shims/* ]]) >/dev/null 2>&1; then
            local SCRIPT_NAME=$(pyenv which "$executable")
        fi
        if __python_argcomplete_scan_head_noerr "$SCRIPT_NAME"; then
            local ARGCOMPLETE=1
        elif __python_argcomplete_scan_head_noerr "$SCRIPT_NAME" '^#!(.*)$' -n && [[ "${BASH_REMATCH[1]}" =~ ^.*(python|pypy)[0-9\.]*$ ]]; then
            local interpreter="$BASH_REMATCH"
            if (__python_argcomplete_scan_head_noerr "$SCRIPT_NAME" "(PBR Generated)|(EASY-INSTALL-(SCRIPT|ENTRY-SCRIPT|DEV-SCRIPT))" \
                && "$interpreter" "$(type -P python-argcomplete-check-easy-install-script)" "$SCRIPT_NAME") >/dev/null 2>&1; then
                local ARGCOMPLETE=1
            elif __python_argcomplete_run "$interpreter" -m argcomplete._check_console_script "$SCRIPT_NAME"; then
                local ARGCOMPLETE=1
            fi
        fi
    fi

    if [[ $ARGCOMPLETE != 0 ]]; then
        local IFS=$(echo -e '\v')
        COMPREPLY=( $(_ARGCOMPLETE_IFS="$IFS" \
            COMP_LINE="$COMP_LINE" \
            COMP_POINT="$COMP_POINT" \
            COMP_TYPE="$COMP_TYPE" \
            _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
            _ARGCOMPLETE=$ARGCOMPLETE \
            _ARGCOMPLETE_SUPPRESS_SPACE=1 \
            __python_argcomplete_run "$executable" "${COMP_WORDS[@]:1:ARGCOMPLETE-1}") )
        if [[ $? != 0 ]]; then
            unset COMPREPLY
        elif [[ "${COMPREPLY-}" =~ [=/:]$ ]]; then
            compopt -o nospace
        fi
    else
        type -t _completion_loader | grep -q 'function' && _completion_loader "$@"
    fi
}
complete -o default -o bashdefault -D -F _python_argcomplete_global
