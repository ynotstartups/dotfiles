if status is-interactive
    # Commands to run in interactive sessions can go here
end

# enable vi key bindings
function fish_hybrid_key_bindings --description \
"Vi-style bindings that inherit emacs-style bindings in all modes"
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    fish_vi_key_bindings --no-erase
end

set -g fish_key_bindings fish_hybrid_key_bindings

alias e='exit'

#######
# git #
#######

alias g='git'
alias gs='git status'


set PERSONAL_NOTES "$HOME/Documents/personal-notes/"
set NOTES          "$HOME/Documents/notes/"
set DOTFILES       "$HOME/Documents/dotfiles/"

alias ,ed="cd $PERSONAL_NOTES && vim dev_notes.md"
alias ,ef="cd $DOTFILES       && vim config.fish"
alias ,ev="cd $DOTFILES       && vim .vimrc"
alias ,ew="cd $PERSONAL_NOTES && vim work_notes.md"
alias ,ez="cd $DOTFILES       && vim .zshrc"
