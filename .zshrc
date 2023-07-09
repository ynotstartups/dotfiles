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

alias sn='cd ~/Documents/notes/standup && copy_last_to_today && vlast'

s() {
    vim ~/Documents/notes/standup/$(ls -t -1 ~/Documents/notes/standup | head -n 1)
}
