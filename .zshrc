export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export PATH="$HOME/Documents/dotfiles:$PATH"

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
bindkey "^[h" run-help
alias help='run-help'

alias e='exit'

# autojump j setup
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

function ,echo_green() { # usage: ,echo_green foo bar baz message
    echo $fg_bold[green]$@$reset_color
}

function ,echo_red() { # usage: ,echo_red foo bar baz message
    echo $fg_bold[red]$@$reset_color
}
#################
# Standup Notes #
#################

# stand up notes related
function s() {
    cd ~/Documents/saltus-notes/
    vim -p ./standup/$(ls -t -1 ~/Documents/saltus-notes/standup | head -n 1) dev_notes.md glossary.md .bashrc .docker-bashrc ~/.vimrc ~/.zshrc
}
# sn for create a new standup note with name like year-month-day.md e.g. 23-07-28.md 
# and open it in vim
alias sn='cd ~/Documents/saltus-notes/standup && copy_last_to_today && s'

#######
# git #
#######

alias g="git"

function ,gnew_branch() {
    git fetch origin "master:$1"
    git switch "$1"
}

function ,pr_review(){
    branch_name=$1

    # save local changes
    git stash

    # switch to branch and fetch latest changes
    git switch $branch_name
    git fetch origin
    git reset --hard origin/$branch_name

    # open git diff origin/master.. files in tab
    vim -c ':TGdot'
}

alias ,review-pr=',pr-review'

# delete every branches except main & master & current branch
alias ,gdelete_branches='git branch | grep -v "main" | grep -v "master" | grep -v "*" | xargs git branch -D'

##########
# Python #
##########

function ,virtualenv_setup() {
    ,echo_green 'setting up virtualenv at .venv folder'
    python3 -m venv .venv
    ,echo_green  'activating virtualenv'
    . .venv/bin/activate
    ,echo_green 'upgrading pip'
    pip install --upgrade pip
    ,echo_green 'pip installing essential libraries'
    pip install -r ~/Documents/dotfiles/requirements.txt
}

function ,activate() {
    if [ -d ".venv" ]; then
        . .venv/bin/activate
    elif [ -d "venv" ]; then
        . venv/bin/activate
    else {
        ,echo_red 'No virtualenv found!'
        ,echo_red 'Consider setup .venv with ,virtualenv_setup'
    }
    fi
}

# TODO: create my own cookie cutter to write new script or python testing codes?
function ,format_lint_test_python(){
    isort **/*.py
    black **/*.py
    # E501 ignoer line too long: Line too long (82 > 79 characters)
    # W503 conflict with black formatter
    flake8 --ignore=E501,W503 **/*.py
    pytest **/*.py
}
alias ,l=',format_lint_test_python'

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
        extract_aliases_functions_from_zshrc.py | \
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
alias ,vgd='vim -c :TGd'
alias ,vgdo='vim -c :TGdo'

########
# Tags #
########

alias ,ctags_generate_for_python='ctags **/*.py'
alias ,generate_ctags_for_python='ctags **/*.py'

##############
# Github CLI #
##############

# first part `git log ...` to print the body of last commit
# second part `gh pr ...` edit the PR body with string from stdin
alias ,gh_edit_pr_body='git log -1 --pretty=format:%b | gh pr edit --body-file -'

alias ,gh_pr_create='git push && gh pr create --draft --fill-first'
alias ,gh_create_pr=',gh_pr_create'
alias ,gh_pr_open='gh pr view --web'
alias ,gh_pr_open_actions='gh pr checks --web'
alias ,gh_pr_checks_watch='gh pr checks --watch'

################
# Work Related #
################

source ~/Documents/saltus-notes/.bashrc

# alias eb instead of exporting the PATH suggested in https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install-osx.html
# because exporting the PATH pollutes it with unwanted executables within that virtualenv ! e.g. python, pip ...
alias eb='~/Documents/elastic-beanstalk-cli/.venv/bin/eb'

function ,docker_attach_oneview(){
    CONTAINER_ID=$(docker container ls | grep oneview-django | cut -d ' ' -f 1)
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
    ,echo_green '~~~~ cd into oneview ~~~~'
    cd ~/Documents/oneview

    ,echo_green '~~~~ docker compose build and up backend detached ~~~~'
    docker compose -f docker-compose-dev.yml up --build --detach django postgres

    ,echo_green '~~~~ poetry install dev ~~~~'
    docker exec --env -t oneview-django-1 poetry install --with dev

    ,echo_green '~~~~ copy over bashrc ~~~~'
    docker compose cp ~/Documents/saltus-notes/.docker-bashrc django:/root/.bashrc

    ,echo_green '~~~~ django logs ~~~~'
    docker compose -f docker-compose-dev.yml logs -f django
}
alias ,be=',docker_build_backend'

alias ,docker-cp-docker-bashrc='docker compose cp ~/Documents/saltus-notes/.docker-bashrc django:/root/.bashrc'

alias ,mb='make bash'

########
# Misc #
########

alias ,a=''
alias ,s=''
alias ,d=''
alias ,f=''
