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

source ~/Documents/saltus-notes/.bashrc

alias e="exit"

# autojump j setup
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh


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

function ,pr-review(){
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

###############
# Virtual Env #
###############

alias ,virtualenv_setup='python3 -m venv .venv'

function ,activate() {
    if [ -d ".venv" ]; then
        . .venv/bin/activate
    elif [ -d "venv" ]; then
        . venv/bin/activate
    else {
        echo "No virtualenv found!";
        echo "Consider setup .venv with ,virtualenv_setup";
    }
    fi
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


# TODO: ,gh_pr_create # create draft PR with correct message and body
#
# TODO: make gh PR title to be git commit subject too?
# first part `git log ...` to print the body of last commit
# second part `gh pr ...` edit the PR body with string from stdin
alias ,gh_edit_pr_body='git log -1 --pretty=format:%b | gh pr edit --body-file -'

alias ,gh_pr_create='git push && gh pr create --draft --fill-first'
alias ,gh_create_pr=',gh_pr_create'
alias ,gh_pr_open='gh pr view --web'
alias ,gh_pr_open_actions='gh pr checks --web'
alias ,gh_pr_checks_watch='gh pr checks --watch'

########
# Misc #
########
