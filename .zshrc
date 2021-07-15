# open zsh with tmux
if [ "$TMUX" = "" ]; then tmux; fi

alias emp-celery='EMPIRE_API_URL="https://celery-empire.lystit.com" emp'
alias emp-microservices='EMPIRE_API_URL="https://microservices-empire.lystit.com" emp'
alias emp-previews='EMPIRE_API_URL="https://previews-empire.lystit.com" emp'
alias emp-website='EMPIRE_API_URL="https://website-empire.lystit.com" emp'

alias vim='nvim'

# set default editor in terminal
export EDITOR='nvim'
export VISUAL='nvim'

export PATH="$HOME/.poetry/bin:$PATH"

# ctrl-r not working in Mac Terminal, this makes it work
bindkey '^R' history-incremental-search-backward

# pyenv
eval "$(pyenv init -)"
