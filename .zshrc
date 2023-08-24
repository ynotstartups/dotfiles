export PATH="/opt/homebrew/opt/node@16/bin:$PATH"

#########################
# Zsh and Powerlevel10k #
#########################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# enable vim mode
bindkey -v

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME='powerlevel10k/powerlevel10k'
plugins=(
    vi-mode
    colored-man-pages
)
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# use alt-h to get help for zsh commandrun-help prini

HELPDIR=/usr/share/zsh/5.9/help

unalias run-help
autoload run-help
# bindkey "^[h" run-help
alias help='run-help'

alias e='exit'

# autojump j setup
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

function _echo_green() { # usage: _echo_green foo bar baz message
    echo $fg_bold[green]$@$reset_color
}

function _echo_red() { # usage: _echo_red foo bar baz message
    echo $fg_bold[red]$@$reset_color
}
#################
# Standup Notes #
#################

# stand up notes related
function s() {
    cd ~/Documents/personal-notes/
    vim -p ./standup/$(ls -t -1 ~/Documents/personal-notes/standup | head -n 1) dev_notes.md glossary.md .bashrc ~/.vimrc ~/.zshrc
}
# sn for create a new standup note with name like year-month-day.md e.g. 23-07-28.md 
# and open it in vim
alias sn='cd ~/Documents/personal-notes/standup && ~/Documents/dotfiles/copy_last_to_today.py && s'

#######
# git #
#######

alias g="git"
alias gs="git status"

function ,gnew_branch() {
    git fetch origin "master:$1"
    git switch "$1"
}

# takes PR branch name, fetch reset and open vim with git diff
function ,pr_review(){
    local branch_name=$1

    # save local changes
    git stash

    # switch to branch and fetch latest changes
    git fetch
    git switch $branch_name
    git reset --hard origin/$branch_name

    # open git diff origin/master.. files in tab
    vim -c ':TGdot'
}


# delete every branches except main & master & current branch
alias ,gdelete_branches='git branch | grep -v "main" | grep -v "master" | grep -v "*" | xargs git branch -D'

##########
# Python #
##########

function ,virtualenv_setup() {
    _echo_green 'setting up virtualenv at .venv folder'
    python3 -m venv .venv
    _echo_green  'activating virtualenv'
    . .venv/bin/activate
    _echo_green 'upgrading pip'
    pip install --upgrade pip
    _echo_green 'pip installing essential libraries'
    pip install -r ~/Documents/dotfiles/requirements.txt
}

function ,activate() {
    if [ -d ".venv" ]; then
        . .venv/bin/activate
    elif [ -d "venv" ]; then
        . venv/bin/activate
    else {
        _echo_red 'No virtualenv found!'
        _echo_red 'Consider setup .venv with ,virtualenv_setup'
    }
    fi
}

function ,format_lint_test_python(){
    if [ $# -eq 0 ]; then
        echo "No arguments provided, please provide path to a python file"
        return 1
    fi

    local file_path=$1

    isort $file_path
    black $file_path
    # E501 ignoer line too long: Line too long (82 > 79 characters)
    # W503 conflict with black formatter
    flake8 --ignore=E501,W503 $file_path
    pytest $file_path
}
alias ,l=',format_lint_test_python'

# TODO: create my own cookie cutter to write new script or python testing codes?
function ,format_lint_test_all_python(){
    isort **/*.py
    black **/*.py
    # E501 ignoer line too long: Line too long (82 > 79 characters)
    # W503 conflict with black Formatter
    flake8 --ignore=E501,W503 **/*.py
    coverage run --source . -m pytest **/*.py
    coverage report --show-missing
}
alias ,la=',format_lint_test_all_python'

# run coverage with all python files and show missing lines
function ,coverage_run(){
    # added --source to ignore side-packages
    coverage run --source . -m pytest **/*.py
    coverage report --show-missing
}

#########
# pyenv #
#########

# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

#######
# fzf #
#######

export FZF_DEFAULT_COMMAND='fd --hidden --type f'
export FZF_DEFAULT_OPTS="--multi
    --bind 'ctrl-a:select-all'
"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# inspired by https://bluz71.github.io/2018/11/26/fuzzy-finding-in-bash-with-fzf.html
# use fzf to find a custom command
function ,fzf_find_command() {
    # get the list of function and alias names
    # find one using fzf
    local extracted_line=`
        ~/Documents/dotfiles/extract_aliases_functions_from_zshrc.py | \
        fzf --no-multi --ansi --height 15
    `

    local command_name=`echo $extracted_line | cut -d ' ' -f 1`
    # -n true if length of string is non-zero, from `man zshmisc` -> conditional expression
    if [[ -n $command_name ]]; then
        # print is a zsh buildin command, there is no `print --help`
        # see https://gist.github.com/YumaInaura/2a1a915b848728b34eacf4e674ca61eb
        # input $command_name as console input NOT as stdout
        # so that I can insert function argument for function that needs argument such as ,gnew_branch foo-bar
        print -z "$command_name "
    fi
}
alias c=',fzf_find_command'

#######
# vim #
#######

alias v='vim'
alias ,vim_git_diff='vim -c :TGd'
alias ,vgd='vim -c :TGd'
alias ,vim_git_diff_originmaster='vim -c :TGdo'
alias ,vgdo='vim -c :TGdo'

# quickly edit files in vim
alias ,ev='vim ~/.vimrc'
alias ,ez='vim ~/.zshrc'

########
# Tags #
########

alias ,ctags_generate_for_python='ctags **/*.py'
alias ,generate_ctags_for_python='ctags **/*.py'

##############
# Github CLI #
##############

# requires
# mkdir ~/.oh-my-zsh/completions
# gh cli autocomplete
# gh completion -s zsh > ~/.oh-my-zsh/completions/_gh
autoload -U compinit
compinit -i

# first part `git log ...` to print the body of last commit
# second part `gh pr ...` edit the PR body with string from stdin
alias ,gh_edit_pr_body='git log -1 --pretty=format:%b | gh pr edit --body-file -'

alias ,gh_pr_create='git push && gh pr create --draft --fill-first'
alias ,gh_pr_open='gh pr view --web'
alias ,gh_pr_actions_open='gh pr checks --web'
alias ,gh_pr_actions_watch='gh pr checks --watch'

################
# Work Related #
################

# alias eb instead of exporting the PATH suggested in https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install-osx.html
# because exporting the PATH pollutes it with unwanted executables within that virtualenv ! e.g. python, pip ...
alias eb='~/Documents/elastic-beanstalk-cli/.venv/bin/eb'

function ,docker_attach_oneview(){
    local CONTAINER_ID=$(docker container ls | grep oneview-django | cut -d ' ' -f 1)
    docker attach $CONTAINER_ID
}

function ,ssh(){
    ssh -i '~/.ssh/aws-eb' "ec2-user@$1"
}

function ,npm_run_frontend(){
    cd ~/Documents/oneview/reactapp
    npm start
}
alias ,fe=',npm_run_frontend'

# docker compose build oneview backend with dev dependencies and personal .bashrc
function ,docker_build_backend(){
    _echo_green '~~~~ cd into oneview ~~~~'
    cd ~/Documents/oneview

    _echo_green '~~~~ docker compose build and up backend detached ~~~~'
    docker compose -f docker-compose-dev.yml up --build --detach django postgres

    _echo_green '~~~~ poetry install dev ~~~~'
    docker exec --env -t oneview-django-1 poetry install --with dev

    _echo_green '~~~~ copy over bashrc ~~~~'
    docker compose cp ~/Documents/personal-notes/.bashrc django:/root/.bashrc

    _echo_green '~~~~ django logs ~~~~'
    docker compose -f docker-compose-dev.yml logs -f django
}
alias ,be=',docker_build_backend'

alias ,docker_cp_bashrc='docker compose cp ~/Documents/personal-notes/.bashrc django:/root/.bashrc'

alias ,mb='make bash'

#####################
# make autocomplete #
#####################

zstyle ':completion:*:*:make:*' tag-order 'targets'
autoload -Uz compinit && compinit

######
# ip #
######

# find the ip of a website ,ip_of https://google.com
function ,ip_of(){
    if [ $# -eq 0 ]; then
        _echo_red "No arguments provided, please provide a url"
        _echo_red "Get ip of a url, automatically strip http/https protocol prefix"
        _echo_red "Usage: ,ip_of https://www.google.com/"
        return 1
    fi

    domain=`echo "$1" | sed -e "s/^https:\/\///" -e "s/^http:\/\///" -e "s/\/.*$//"`

    _echo_green "nslookup $domain ..."
    nslookup $domain

    # $? is the exit code of nslookup, 0 means good, other means bad
    if [ $? -eq 0 ]; then
        _echo_green 'Query succeed.'
    else
        _echo_red   'Query failed.'
    fi
}


######
# rg #
######

export RIPGREP_CONFIG_PATH=$HOME/.rgrc

######################
# cheatsheet website #
######################

## get cheatsheet from cheat.sh e.g. cheatsheet sed
,cheatsheet() {
    curl cheat.sh/"$1" | less
}

#########
# MacOS #
#########

function ,copy_last_screenshot() {
   most_recent_screenshot_name=`ls -t -1 ~/Desktop/screenshots | head -1`
   apple_script="set the clipboard to (read (POSIX file \"/Users/yuhao.huang/Desktop/screenshots/$most_recent_screenshot_name\") as {«class PNGf»})"
   osascript -e $apple_script
}

# Tips: use `say 'hello world'` to use sound synthesizer 

########
# Misc #
########

alias ,a=''
alias ,s=''
alias ,d=''
alias ,f=''
