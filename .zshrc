export PATH="/opt/homebrew/opt/node@16/bin:$PATH"

alias g="git"
alias e="exit"

alias ,ctags_generate_for_python='ctags **/*.py'
alias ,generate_ctags_for_python='ctags **/*.py'

gfro() {
    git fetch origin
    git rebase -i origin/master
}

# autojump j setup
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

export PATH="$HOME/Documents/dotfiles:$PATH"

# used in `sn` standup new
alias vlast='vim $(ls -t -1 | head -n 1)'

alias sn='cd ~/Documents/saltus-notes/standup && copy_last_to_today && vlast'

s() {
    vim ~/Documents/saltus-notes/standup/$(ls -t -1 ~/Documents/saltus-notes/standup | head -n 1)
}

alias ,activate='source .venv/bin/activate'
alias ,virtualenv_setup='python3 -m venv .venv'

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
