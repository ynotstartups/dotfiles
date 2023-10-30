if status is-interactive
    # Commands to run in interactive sessions can go here
end

# disable fish_greeting
set --global fish_greeting

# enable vi key bindings
function fish_hybrid_key_bindings --description \
"Vi-style bindings that inherit emacs-style bindings in all modes"
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    fish_vi_key_bindings --no-erase
end

##########
# Prompt #
##########

function fish_prompt --description 'Informative prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -g __fish_git_prompt_show_informative_status yes
    set -g __fish_git_prompt_showdirtystate yes
    set -g __fish_git_prompt_showupstream auto
    set -g __fish_git_prompt_showcolorhints yes

    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                         and set_color $fish_color_cwd_root
                                                         or set_color $fish_color_cwd) \
            (prompt_pwd) (set_color normal)
    else
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color --bold $fish_color_status)
        set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        printf '[%s] %s%s %s%s%s%s \n> ' \
            (date "+%H:%M:%S") \
            (set_color $fish_color_cwd) $PWD  \
            (set_color white) (fish_git_prompt) \
            $pipestatus_string \
            (set_color normal)
    end
end

set -g fish_key_bindings fish_hybrid_key_bindings

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


########
# Misc #
########

set PATH /opt/homebrew/bin /usr/local/bin /usr/sbin $PATH


# setup j which is autojump
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish

abbr --add fd_all_files fd --hidden --no-ignore

set --global --export EDITOR vim

alias ll='ls -lha'
alias e='exit'

####################
# Folder Variables #
####################

set PERSONAL_NOTES "$HOME/Documents/personal-notes/"
set NOTES          "$HOME/Documents/notes/"
set DOTFILES       "$HOME/Documents/dotfiles/"

#################
# Standup Notes #
#################

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

function ,gh_actions
    while true
        set_color --bold cyan
        echo "... Watching github action status for$(fish_git_prompt) ..."
        set_color normal
        echo ""
        gh pr checks
        sleep 5
    end
end

alias g='git'
alias gs='git status'

# delete every branches except main & master & current branch
alias ,gdelete_branches='git branch | grep -v "main" | grep -v "master" | grep -v "*" | xargs git branch -D'

alias ,g_template_disable='git config --local commit.template "/dev/null"'
alias ,g_template_enable='git config --local --unset commit.template'

function ,g_s_notes
    set directories personal-notes dotfiles notes docs

    for directory in $directories
        set_color --bold cyan; echo ===== $directory ===== \n; set_color normal;
        git -C "$HOME/Documents/$directory" status
        echo ""
    end
end

function ,gnew_branch
    # if [[ $# -eq 0 ]]; then
    #     _echo_red "Missing first argument"
    # fi

    # if [[ $# -eq 0 || "$1" = "-h" ]]; then
    #     echo "Switch to new branch & fetch origin"
    #     echo
    #     echo "Usage:"
    #     echo "    ,gnew_branch BRANCH_NAME"
    #     return 1
    # fi
    set new_branch_name $argv[1]

    git fetch origin master:$new_branch_name
    git switch $new_branch_name
end

#########
# MacOS #
#########

function ,convert_md_to_pdf
    # if [[ $# -eq 0 ]]; then
    #     _echo_red "Missing arguments"
    # fi

    # if [[ $# -eq 0 || "$1" = "-h" ]]; then
    #     echo "convert markdown to pdf"
    #     echo
    #     echo "Usage:"
    #     echo "    ,convert_md_to_pdf foo.md"
    #     echo "Output:"
    #     echo "    foo.pdf"
    #     return 1
    # fi

    set markdown_name $argv[1]
    set pdf_name $(echo $markdown_name | sed 's/.md$/.pdf/')
    echo "Converting from" $markdown_name "to" $pdf_name
    docker run --rm \
        -v "$(pwd):/data" \
        pandoc/extra \
        "$markdown_name" -o $pdf_name \
        --template eisvogel --listings \
        -V book --top-level-division chapter -V classoption=oneside
    and echo "Done, please see $pdf_name."
    or echo "Failed!"
end

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
#######
# fzf #
#######

set --global --export FZF_DEFAULT_COMMAND 'fd --hidden --type f'
set --global --export FZF_DEFAULT_OPTS "--multi
     --color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672
     --bind 'ctrl-a:select-all'
     --bind 'ctrl-/:toggle-preview'
"

set --global --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

# [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

#######
# vim #
#######

# In Mac, the Vim binary is installed/compiled via Homebrew i.e. `brew install vim`
# vim --version shows the following Compilation flags
# -L/opt/homebrew/opt/python@3.12/Frameworks/Python.framework/Versions/3.12/lib/python3.12/config-3.12-darwin
# -lpython3.12 
# so the python used in vim is homebrew's python3.12 
# this hack below is to force homebrew's python3.12 to search for library in PYTHONPATH
# installed python my "system python", which is python3.11 installed via pyenv `pyenv global`
# the library I need is `thefuzz` which is a dependency of my patched `~/Document/completor.vim`
set --global --export PYTHONPATH $HOME/.pyenv/versions/3.11.4/lib/python3.11/site-packages/

function vim
    # when count is 0 and readme exists open readme
    if test (count $argv) -eq 0; and test -f ./README.md
        command vim ./README.md
    else
        command vim $argv
    end
end

function ,vrg
    # fish doesn't have `<(foo)` syntax instead you can do (foo | psub)
    vim -q (rg --vimgrep $argv | psub) -c 'copen'
end

alias ,ed="cd $PERSONAL_NOTES && vim dev_notes.md"
alias ,ef="cd $DOTFILES       && vim config.fish"
alias ,ev="cd $DOTFILES       && vim .vimrc"
alias ,ew="cd $PERSONAL_NOTES && vim work_notes.md"
alias ,ez="cd $DOTFILES       && vim .zshrc"

########
# Tags #
########

# alias ,ctags_generate_for_python='ctags --python-kinds=-v **/*.py'
alias ,generate_ctags_for_python='ctags **/*.py'

#########
# Pyenv #
#########

set -Ux PYENV_ROOT $HOME/.pyenv
set PATH $PYENV_ROOT $PATH
pyenv init - | source

################
# Work Related #
################

alias ,dc_e2e='docker compose --file docker-compose-e2e.yml'
alias ,dc='docker compose --file docker-compose-dev.yml'

alias ,docker_logs_backend='docker logs --follow $(docker ps -a -q --filter="name=oneview-django-1")'

# docker compose build oneview backend with dev dependencies and personal .bashrc
function ,docker_build_backend
    echo '~~~~ cd into oneview ~~~~'
    cd ~/Documents/oneview

    echo '~~~~ generating ctags ~~~~'
    ctags **/*.py

    echo '~~~~ docker compose build and up backend detached ~~~~'
    docker compose -f docker-compose-dev.yml up --build --detach django postgres

    echo '~~~~ poetry install dev ~~~~'
    docker exec --env -t oneview-django-1 poetry install --with dev

    echo '~~~~ copy over bashrc ~~~~'
    docker compose cp "$PERSONAL_NOTES.bashrc" django:/root/.bashrc

    echo '~~~~ django logs ~~~~'
    docker compose -f docker-compose-dev.yml logs -f django
end
alias ,be=',docker_build_backend'

alias ,docker_cp_bashrc='cd ~/Documents/oneview && docker compose cp $PERSONAL_NOTES".bashrc" django:/root/.bashrc'
alias ,docker_logs_backend='docker logs --follow $(docker ps -a -q --filter="name=oneview-django-1")'
alias ,mb='make bash'

# alias eb instead of exporting the PATH suggested in https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install-osx.html
# because exporting the PATH pollutes it with unwanted executables within that virtualenv ! e.g. python, pip ...
alias eb='~/Documents/elastic-beanstalk-cli/.venv/bin/eb'

function ,docker_attach_oneview
    set CONTAINER_ID (docker container ls | grep oneview-django | cut -d ' ' -f 1)
    docker attach $CONTAINER_ID
end

function ,ssh_uat
    if not pgrep -q 'AWS VPN'
        set_color --bold red
        echo "Did you forget to turn on AWS VPN?"
        set_color normal
        return 1
    end

    set ip_address (aws ec2 describe-instances \
        --filters 'Name=tag:Name,Values=oneview-uat-leader' \
        --output text --query 'Reservations[*].Instances[*].PrivateIpAddress' \
    )

    ssh -o StrictHostKeyChecking=no -i '~/.ssh/aws-eb' "ec2-user@$ip_address"
end

function ,ssh_prod
    if not pgrep -q 'AWS VPN'
        set_color --bold red
        echo "Did you forget to turn on AWS VPN?"
        set_color normal
        return 1
    end

    set ip_address (aws ec2 describe-instances \
        --filters 'Name=tag:Name,Values=oneview-prod-leader' \
        --output text --query 'Reservations[*].Instances[*].PrivateIpAddress' \
    )

    ssh -o StrictHostKeyChecking=no -i '~/.ssh/aws-eb' "ec2-user@$ip_address"
end

function ,npm_run_frontend
    # stops the react container, not sure why it's started automatically
    docker stop $(docker ps -a -q --filter='name=oneview-react-1')
    cd ~/Documents/oneview/reactapp
    npm start
end

alias ,fe=',npm_run_frontend'
