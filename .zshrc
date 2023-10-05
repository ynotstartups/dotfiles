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

# edit command line in vim
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

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

####################
# Folder Variables #
####################

local PERSONAL_NOTES="$HOME/Documents/personal-notes/"
local NOTES="$HOME/Documents/notes/"
local DOTFILES="$HOME/Documents/dotfiles/"

#################
# Standup Notes #
#################

# stand up notes related
function s() {
    cd "$PERSONAL_NOTES"
    vim -p ./standup/$(ls -t -1 "$PERSONAL_NOTES"'standup' | head -n 1) work_notes.md dev_notes.md glossary.md .bashrc
}
# sn for create a new standup note with name like year-month-day.md e.g. 23-07-28.md 
# and open it in vim
alias sn='cd $PERSONAL_NOTES"standup" && $DOTFILES"copy_last_to_today.py" && s'

#######
# git #
#######

alias g='git'
alias gs='git status'

function ,gnew_branch() {
    if [ $# -eq 0 ]; then
        _echo_red "Missing first argument"
    fi

    if [ $# -eq 0 ] || [ "$1" = "-h" ]; then
        echo "Switch to new branch & fetch origin"
        echo
        echo "Usage:"
        echo "    ,gnew_branch BRANCH_NAME"
        return 1
    fi

    git fetch origin "master:$1"
    git switch "$1"
}

function ,uat_diff(){
    # get the latest changes
    git fetch --quiet

    number_of_new_commits=$(\
        git log --oneline origin/env/uat...origin/master |\
          wc -l |\
            # wc starts with tab, remove it, extract the number of lines only
            grep -o '\d*' \
    )
    _echo_green "There are" $number_of_new_commits "new commits."
   print "...ordered from old commits to new commits\n"

    # change the format to hash, commit date, commit message
    git --no-pager log origin/env/uat...origin/master --reverse --pretty=format:"%C(yellow)%h %Creset%C(cyan)%C(bold)%<(18)%ad %Creset%C(green)%C(bold)%<(20)%an %Creset%s" --date human

    printf "\n\n" 

    git diff --exit-code --quiet origin/env/uat...origin/master saltus/oneview/migrations
    if [ $? -eq 1 ]; then
        _echo_red 'There are new migrations! ONLY DEPLOY AT NIGHT!\n'
        git --no-pager diff --stat origin/env/uat...origin/master saltus/oneview/migrations
    else
        _echo_green 'There is NO new migrations! OK to deploy anytime.\n'
    fi
}


# delete every branches except main & master & current branch
alias ,gdelete_branches='git branch | grep -v "main" | grep -v "master" | grep -v "*" | xargs git branch -D'

alias ,g_template_disable='git config --local commit.template "/dev/null"'
alias ,g_template_enable='git config --local --unset commit.template'

function ,g_lint() {
    git diff --color=never -U0 --no-prefix --raw origin/master... | ~/Documents/dotfiles/lint_pull_requests.awk
    git diff --color=never -U0 --no-prefix --raw --cached | ~/Documents/dotfiles/lint_pull_requests.awk
    git diff --color=never -U0 --no-prefix --raw | ~/Documents/dotfiles/lint_pull_requests.awk
}
function ,g_lint_vim() {
    git diff --color=never -U0 --no-prefix --raw origin/master... | ~/Documents/dotfiles/lint_pull_requests.awk > quickfix.vim
    git diff --color=never -U0 --no-prefix --raw --cached | ~/Documents/dotfiles/lint_pull_requests.awk >> quickfix.vim
    git diff --color=never -U0 --no-prefix --raw | ~/Documents/dotfiles/lint_pull_requests.awk >> quickfix.vim
    vim -q quickfix.vim
}


#################
# Pull Requests #
#################

function ,pr_checkout(){

    if [ $# -eq 0 ]; then
        _echo_red "Missing first argument"
    fi

    if [ $# -eq 0 ] || [ "$1" = "-h" ]; then
        echo "Takes PR branch name, fetch reset and open vim with git diff"
        echo
        echo "Usage:"
        echo "    ,pr_review BRANCH_NAME"
        echo "    ,pr_review -h"
        return 1
    fi

    local branch_name=$1

    # TODO: stops if there are local changes
    # save local changes
    git stash

    # switch to branch and fetch latest changes
    git fetch
    git switch $branch_name
    git reset --hard origin/$branch_name
}

alias ,pr_lint=',g_lint'

# takes PR branch name, fetch reset and open vim with git diff
function ,pr_review(){

    if [ $# -eq 0 ]; then
        _echo_red "Missing first argument"
    fi

    if [ $# -eq 0 ] || [ "$1" = "-h" ]; then
        echo "Takes PR branch name, fetch reset and open vim with git diff"
        echo
        echo "Usage:"
        echo "    ,pr_review BRANCH_NAME"
        echo "    ,pr_review -h"
        return 1
    fi

    local branch_name=$1

    # TODO: stops if there are local changes
    # save local changes
    git stash

    # switch to branch and fetch latest changes
    git fetch
    git switch $branch_name
    git reset --hard origin/$branch_name

    # open git diff origin/master.. files in tab
    vim -c ':Git difftool -y origin/master...'
}


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
    pip install -r "$DOTFILES'requirements.txt'"
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

#######
# fzf #
#######

export FZF_DEFAULT_COMMAND='fd --hidden --type f'
export FZF_DEFAULT_OPTS="--multi
    --color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672
    --bind 'ctrl-a:select-all'
    --bind 'ctrl-/:toggle-preview'
"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# inspired by https://bluz71.github.io/2018/11/26/fuzzy-finding-in-bash-with-fzf.html
# use fzf to find a custom command
function ,fzf_find_command() {
    # get the list of function and alias names
    # find one using fzf
    local extracted_line=$(
        $DOTFILES'extract_aliases_functions_from_zshrc.awk' < $DOTFILES'.zshrc' | \
        fzf --no-multi --ansi --height 15
    )

    local command_name=$(echo $extracted_line | cut -d ' ' -f 1)
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

alias v='     vim'
alias ,vgd='  vim -c ":Git difftool"'
alias ,vgds=' vim -c ":Git difftool --staged"'
alias ,vgdo=' vim -c ":Git difftool origin/master..."'
alias ,vgdot='vim -c ":Git difftool -y origin/master..."'

function ,vrg() {
    vim -q <(rg --vimgrep "$@")
}
alias vrg=',vrg'

# quickly edit files in vim
alias ,ev='cd $DOTFILES       && vim .vimrc'
alias ,ez='cd $DOTFILES       && vim .zshrc'
alias ,ed='cd $PERSONAL_NOTES && vim dev_notes.md'
alias ,ew='cd $PERSONAL_NOTES && vim work_notes.md'

########
# Tags #
########

# alias ,ctags_generate_for_python='ctags --python-kinds=-v **/*.py'
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
    if [ $# -eq 0 ]; then
        _echo_red "Missing first argument"
    fi
    
    if [ $# -eq 0 ] || [ "$1" = "-h" ]; then
        echo "ssh into oneview's elastic beanstalk"
        echo
        echo "Usage:"
        echo "    ,ssh IP_ADDRESS"
        return 1
    fi

    ssh -o StrictHostKeyChecking=no -i '~/.ssh/aws-eb' "ec2-user@$1"
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

    _echo_green '~~~~ generating ctags ~~~~'
    ctags **/*.py

    _echo_green '~~~~ docker compose build and up backend detached ~~~~'
    docker compose -f docker-compose-dev.yml up --build --detach django postgres

    _echo_green '~~~~ poetry install dev ~~~~'
    docker exec --env -t oneview-django-1 poetry install --with dev

    _echo_green '~~~~ copy over bashrc ~~~~'
    docker compose cp "$PERSONAL_NOTES.bashrc" django:/root/.bashrc

    _echo_green '~~~~ django logs ~~~~'
    docker compose -f docker-compose-dev.yml logs -f django
}
alias ,be=',docker_build_backend'

alias ,docker_cp_bashrc='cd ~/Documents/oneview && docker compose cp $PERSONAL_NOTES".bashrc" django:/root/.bashrc'

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
        _echo_red "Missing first argument"
    fi

    if [ $# -eq 0 ] || [ "$1" = "-h" ]; then
        echo "Find the ip of a website"
        echo
        echo "Usage:"
        echo "    ,ip_of https://google.com"
        return 1
    fi

    local domain=$(echo "$1" | sed -e "s/^https:\/\///" -e "s/^http:\/\///" -e "s/\/.*$//")

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

#########
# MacOS #
#########

function ,copy_last_screenshot() {
   local most_recent_screenshot_name=$(ls -t -1 ~/Desktop/screenshots | head -1)
   local apple_script="set the clipboard to (read (POSIX file \"/Users/yuhao.huang/Desktop/screenshots/$most_recent_screenshot_name\") as {«class PNGf»})"
   osascript -e $apple_script
}

# make and cd into a temporary folder with prefix "tigertmp"
alias ,make_temp_folder='cd $(mktemp -d -t "tigertmp")'

# Tips: use `say 'hello world'` to use sound synthesizer 

alias ,cancel_print_jobs='sudo cancel -a -x'

function ,convert_md_to_pdf() {
    if [ $# -eq 0 ]; then
        _echo_red "Missing arguments"
    fi

    if [ $# -eq 0 ] || [ "$1" = "-h" ]; then
        echo "convert markdown to pdf"
        echo
        echo "Usage:"
        echo "    ,convert_md_to_pdf foo.md"
        echo "Output:"
        echo "    foo.pdf"
        return 1
    fi

    pdf_name="$(echo $1 | sed 's/.md$/.pdf/')"
    echo "Converting from" $1 "to" $pdf_name
    docker run --rm \
        -v "$(pwd):/data" \
        pandoc/extra \
        "$1" -o $pdf_name \
        --template eisvogel --listings \
        -V book --top-level-division chapter -V classoption=oneside

    _echo_green "Done, please see $pdf_name."
}

# ,pandoc_in_docker example.md -o example.pdf --template eisvogel --listings
alias ,pandoc_in_docker='docker run --rm -v "$(pwd):/data" -u $(id -u):$(id -g) pandoc/extra'

function ,cheatsheet() {
    # TODO: handle typo or when there is no existing cheatsheet

    if [ $# -eq 0 ]; then
        _echo_red "Missing first argument"
    fi

    if [ $# -eq 0 ] || [ "$1" = "-h" ]; then
        echo "open cheatsheet in dev_notes.md"
        echo
        echo "Usage:"
        echo "    ,cheatsheet awk"
        return 1
    fi

    cd ~/Documents/personal-notes/

    vim -q <(rg --vimgrep -i "# cheatsheet.*$1" ./dev_notes.md)
}

alias ,hardcopy='lpr -p -o EPIJ_Silt=1 -o Resolution=720x720dpi -o EPIJ_Qual=307'
alias ,hardcopy_normal_quality='lpr -p -o EPIJ_Silt=0 -o Resolution=360x360dpi -o EPIJ_Qual=303'
alias ,hardcopy_10_standup='\
    lpr -p -o EPIJ_Silt=0 -o Resolution=360x360dpi -o EPIJ_Qual=303 \
    -# 10 ~/Documents/personal-notes/standup_template.pdf'

########
# less #
########

# makes less support mouse scroll
export LESS='--mouse --wheel-lines=3'

############
# Man Page #
############

# forcing the manual page prints in 80 columns width
# makes printing hardcopy man page fits in one page
export MANWIDTH=80

# try out using vim as pager
export MANPAGER="vim +MANPAGER --not-a-term -"
