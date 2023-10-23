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

########
# Misc #
########

set PATH /opt/homebrew/bin /usr/local/bin /usr/sbin $PATH

# setup j which is autojump
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish

abbr --add fd_all_files fd --hidden --no-ignore

set --global --export EDITOR vim

#########
# Theme #
#########

set fish_color_normal F8F8F2 # the default color
set fish_color_command F92672 # the color for commands
set fish_color_quote E6DB74 # the color for quoted blocks of text
set fish_color_redirection AE81FF # the color for IO redirections
set fish_color_end F8F8F2 # the color for process separators like ';' and '&'
set fish_color_error F8F8F2 --background=F92672 # the color used to highlight potential errors
set fish_color_param A6E22E # the color for regular command parameters
set fish_color_comment 75715E # the color used for code comments
set fish_color_match F8F8F2 # the color used to highlight matching parenthesis
set fish_color_search_match --background=49483E # the color used to highlight history search matches
set fish_color_operator AE81FF # the color for parameter expansion operators like '*' and '~'
set fish_color_escape 66D9EF # the color used to highlight character escapes like '\n' and '\x70'
set fish_color_cwd 66D9EF # the color used for the current working directory in the default prompt

# Additionally, the following variables are available to change the highlighting in the completion pager:
set fish_pager_color_prefix F8F8F2 # the color of the prefix string, i.e. the string that is to be completed
set fish_pager_color_completion 75715E # the color of the completion itself
set fish_pager_color_description 49483E # the color of the completion description
set fish_pager_color_progress F8F8F2 # the color of the progress bar at the bottom left corner
set fish_pager_color_secondary F8F8F2 # the background color of the every second completion

set -g fish_key_bindings fish_hybrid_key_bindings

alias e='exit'

#################
# Standup Notes #
#################

set PERSONAL_NOTES "$HOME/Documents/personal-notes/"
set NOTES          "$HOME/Documents/notes/"
set DOTFILES       "$HOME/Documents/dotfiles/"

# stand up notes related
function s
    cd "$PERSONAL_NOTES"
    vim -p ./standup/$(ls -t -1 "$PERSONAL_NOTES"'standup' | head -n 1) work_notes.md dev_notes.md glossary.md .bashrc
end
# sn for create a new standup note with name like year-month-day.md e.g. 23-07-28.md 
# and open it in vim
alias sn='cd $PERSONAL_NOTES"standup" && $DOTFILES"copy_last_to_today.py" && s'

#######
# git #
#######

alias g='git'
alias gs='git status'

function ,g_s_notes;
    set directories personal-notes dotfiles notes docs

    for directory in $directories
        set_color --bold cyan; echo ===== $directory ===== \n; set_color normal;
        git -C "$HOME/Documents/$directory" status
        echo ""
    end
end


alias ,ed="cd $PERSONAL_NOTES && vim dev_notes.md"
alias ,ef="cd $DOTFILES       && vim config.fish"
alias ,ev="cd $DOTFILES       && vim .vimrc"
alias ,ew="cd $PERSONAL_NOTES && vim work_notes.md"
alias ,ez="cd $DOTFILES       && vim .zshrc"

#########
# MacOS #
#########

alias ,hardcopy='lpr -p -o EPIJ_Silt=1 -o Resolution=720x720dpi -o EPIJ_Qual=307'
alias ,hardcopy_normal_quality='lpr -p -o EPIJ_Silt=0 -o Resolution=360x360dpi -o EPIJ_Qual=303'
alias ,hardcopy_10_standup_template='\
    lpr -p -o EPIJ_Silt=0 -o scaling=110 -o Resolution=360x360dpi -o EPIJ_Qual=303 \
    -# 10 ~/Documents/personal-notes/standup_template.pdf'

# Cups link: http://localhost:631/
# logins with laptops's username and password
# /private/etc/cups/ppd

######
# rg #
######

set --global --export RIPGREP_CONFIG_PATH $HOME/.rgrc

############
# Man Page #
############

# forcing the manual page prints in 80 columns width
# makes printing hardcopy man page fits in one page
set --global --export MANWIDTH 80

# try out using vim as pager
set --global --export MANPAGER "vim +MANPAGER --not-a-term -"
