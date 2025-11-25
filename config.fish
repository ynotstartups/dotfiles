##############
# Fish Shell #
##############

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
set -g fish_key_bindings fish_hybrid_key_bindings

function fish_prompt --description 'Informative prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set --global __fish_git_prompt_show_informative_status yes
    set --global __fish_git_prompt_showdirtystate yes
    set --global __fish_git_prompt_showupstream auto
    set --global __fish_git_prompt_showcolorhints yes

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

set PATH /opt/homebrew/bin /usr/local/bin /usr/sbin $PATH

abbr e 'exit'
# long list with time format like 2024-03-14 11:58:06
abbr ll 'ls -lha -D "%Y-%m-%d %H:%M:%S"'
# sort by time with time format like 2024-03-14 11:58:06
abbr lt 'ls -lhat -D "%Y-%m-%d %H:%M:%S"'

##############
# Fish Theme #
##############

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

############
# Autojump #
############

# setup j which is autojump
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish

######
# fd #
######

abbr fd_all_files 'fd --hidden --no-ignore'

####################
# Folder Variables #
####################

set PERSONAL_NOTES "$HOME/Documents/personal-notes/"
set NOTES          "$HOME/Documents/notes/"
set DOTFILES       "$HOME/Documents/dotfiles/"

#######
# git #
#######

abbr ,gh_pr_view 'gh pr view --web'
function ,gh_pr_create 
    gh pr create --base development --draft --fill-verbose --body-file ~/Documents/personal-notes/pull_request_template.md 
end
function ,gh_ci_backend_open_in_browser
    set link $(gh pr checks --json 'workflow' --json 'link' | jq '.' | grep 'backend' -C 1 | grep 'link' | grep -o 'http[^"]*')
    open $link
end

abbr g 'git'
abbr gs 'git status'
abbr gd 'git diff'

# `-e "*"` means ignore current branch
# a space is added to the rest of the patterns to avoid branch names like `merge-prep-uat-into-developement`
# Example output for git branch, note the spaces before the branch names
#> git branch
#  development
#  env/prod
#  env/test
#  env/uat
#  merge-prep-prod-into-development-24-feb-2025
#  prep/prod
#  prep/uat
#* ON-5561-add-test-for-get_aws_credentials
abbr ,gdelete_branches 'git branch | grep -v -e "*" -e " main" -e " development" -e " master" -e " env/" -e " prep/" | xargs git branch -D'

abbr ,gdisable_hooks 'git config core.hooksPath /dev/null'

abbr ,g_template_disable 'git config --local commit.template "/dev/null"'
abbr ,g_template_enable 'git config --local --unset commit.template'

function ,gs_notes
    set directories personal-notes dotfiles notes menu

    for directory in $directories
        set_color --bold cyan; echo ===== $directory =====; set_color normal;
        git -C "$HOME/Documents/$directory" status
        echo ""
    end
end

#########
# MacOS #
#########

abbr ,hardcopy 'lpr -o Resolution=720x720dpi'
abbr ,hardcopy_normal_quality 'lpr -o Resolution=360x360dpi'
abbr ,hardcopy_10_graph_papers 'lpr -o Resolution=360x360dpi -# 10 ~/Documents/dotfiles/a4-graph.pdf'
abbr ,hardcopy_10_standup_papers 'lpr -o Resolution=360x360dpi -# 10 ~/Documents/dotfiles/a4-graph-standup-hardcopy.pdf'


######
# rg #
######

set --global --export RIPGREP_CONFIG_PATH $HOME/.rgrc

abbr rg_python_ignore_tests 'rg -t py -g "!**/tests/**"'

abbr rg_js_ignore_tests 'rg -g "!**/*test.ts" -g "!**/*.snap"'

########
# Node #
########

set PATH /opt/homebrew/opt/node@20/bin $PATH

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
"

set --global --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

#######
# vim #
#######

set --global --export EDITOR vim

# In Mac, the Vim binary is installed/compiled via Homebrew i.e. `brew install vim`
# vim --version shows the following Compilation flags
# -L/opt/homebrew/opt/python@3.12/Frameworks/Python.framework/Versions/3.12/lib/python3.12/config-3.12-darwin
# -lpython3.12 
# so the python used in vim is homebrew's python3.12 
# this hack below is to force homebrew's python3.12 to search for library in PYTHONPATH
# installed python my "system python", which is python3.11 installed via pyenv `pyenv global`
# the library I need is `thefuzz` which is a dependency of my patched `~/Document/completor.vim`
# set --global --export PYTHONPATH $HOME/.pyenv/versions/3.11.4/lib/python3.11/site-packages/

function vim
    # when count is 0 and readme exists open readme
    # uses test to ignore the output from count
    if test (count $argv) -eq 0; and test -f ./README.md
        command vim ./README.md
    else
        command vim $argv
    end
end

abbr ,eb "vim $PERSONAL_NOTES/.bashrc"
abbr ,ed "vim $PERSONAL_NOTES/dev_notes.md"
abbr ,ef "vim $DOTFILES/config.fish"
abbr ,eg "vim $DOTFILES/.gitconfig"
abbr ,ek "vim $DOTFILES/kitty.conf"
abbr ,em "vim ~/Documents/menu/app.py"
abbr ,ep "vim $DOTFILES/language-reminders/python.md"
abbr ,ev "vim $DOTFILES/.vimrc"

########
# Tags #
########

abbr ,generate_ctags_for_python 'ctags **/*.py'

##########
# Python #
##########

function ,virtualenv_setup
    echo 'setting up virtualenv at .venv folder'
    python3 -m venv .venv
    echo  'activating virtualenv'
    source .venv/bin/activate.fish
    echo 'upgrading pip'
    pip install --upgrade pip
    echo 'pip installing essential libraries'
    pip install -r requirements.txt
end

function ,activate
    if test -d ".venv"
        source .venv/bin/activate.fish
    else if test -d "venv"
        source venv/bin/activate.fish
    else
        echo 'No virtualenv found!'
        echo 'Consider setup .venv with ,virtualenv_setup'
    end
end

abbr pytest_useful "pytest -rA --lf -x --show-capture no -vv"

#######
# PWD #
#######

function set_git_base_branch
    set repo_with_development_as_base_branch "$HOME/Documents/oneview"

    set -Ux GIT_BASE_BRANCH "main"

    if contains $PWD $repo_with_development_as_base_branch
        set -Ux GIT_BASE_BRANCH "development"
    end
end

# run when a shell spawns
set_git_base_branch

# run when the current directory is changed
function react_to_pwd --on-variable PWD
    set_git_base_branch
end

################
# Work Related #
################

function ,docker_setup_backend_utils
    echo '~~~~ cd into oneview ~~~~'
    cd ~/Documents/oneview

    echo '~~~~ poetry install dev dependencies ~~~~'
    docker exec --env -t oneview-django-1 poetry install --with dev

    echo '~~~~ copy over bashrc ~~~~'
    docker compose cp "$PERSONAL_NOTES.bashrc" django:/root/.bashrc

    echo '~~~~ copy ipython config ~~~~'
    docker exec --env -t oneview-django-1 poetry run ipython profile create
    docker compose cp $PERSONAL_NOTES"ipython_config.py" django:/root/.ipython/profile_default/ipython_config.py
end
abbr ,be ',docker_setup_backend_utils'

abbr ,docker_cp_bashrc 'cd ~/Documents/oneview && docker compose cp $PERSONAL_NOTES".bashrc" django:/root/.bashrc'

abbr ,docker_attach_oneview "docker attach $(docker container ls | grep oneview-django | cut -d ' ' -f 1)"

abbr mb "cd ~/Documents/oneview && make bash"
abbr ms "cd ~/Documents/oneview && make shell"
abbr mp "cd ~/Documents/oneview && docker compose --file docker-compose-dev.yml exec postgres psql --username postgres --dbname oneview"

# Usage
# cat foo.sql | ,ovpsql
# cat foo.py  | ,ovpython
alias ,ovpsql   "docker compose --file ~/Documents/oneview/docker-compose-dev.yml exec --no-TTY postgres psql --username postgres oneview" 
alias ,ovpython "docker compose --file ~/Documents/oneview/docker-compose-dev.yml exec --no-TTY django poetry run python manage.py shell" 

# abbr eb instead of exporting the PATH suggested in https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install-osx.html
# because exporting the PATH pollutes it with unwanted executables within that virtualenv ! e.g. python, pip ...
abbr eb '~/Documents/elastic-beanstalk-cli/.venv/bin/eb'

function ,pnpm_run_frontend
    cd ~/Documents/oneview/reactapp
    pnpm start
end
abbr ,fe ',pnpm_run_frontend'

##################
# docker compose #
##################

abbr ,dc_logs_django "docker compose --file docker-compose-dev.yml logs --follow --timestamps django"
abbr ,dc 'docker compose --file docker-compose-dev.yml'
abbr ,dc_e2e 'docker compose --file docker-compose-e2e.yml'
abbr ,dc_logs "docker compose --file docker-compose-dev.yml logs --follow --timestamps" 

###########
# aws cli #
###########

# completion
function __fish_complete_aws
    env COMP_LINE=(commandline -pc) aws_completer | tr -d ' '
end
complete -c aws -f -a "(__fish_complete_aws)"

abbr ,aws_space 'AWS_PROFILE=space aws'
abbr ,aws_work 'aws'
abbr ,aws_personal 'AWS_PROFILE=personal aws'

###########
# scripts #
###########

alias ,jira "$DOTFILES/.venv/bin/python3 $DOTFILES/jira.py" 
alias ,curo "$DOTFILES/.venv/bin/python3 $DOTFILES/curo.py" 
alias ,ssh "TERM=xterm-256color $DOTFILES/.venv/bin/python3 $DOTFILES/ssh.py" 
alias ,autogui "$DOTFILES/.venv/bin/python3 $DOTFILES/autogui.py"
alias ,ai "$DOTFILES/.venv/bin/python3 $DOTFILES/ai.py"
alias ,deployment "$DOTFILES/.venv/bin/python3 $DOTFILES/deployment.py"
alias ,pydoc "python3 -m pydoc"
alias ,json "python3 -m json"
alias ,calendar "python3 -m calendar"
alias ,oneview_pydoc_server "docker run --rm -it -p 40423:40423 oneview-django poetry run python -m pydoc -b -p 40423 -n 0.0.0.0"

function ,doc --argument-names query
    open "https://devdocs.io/?q=$query"
end
alias ,d ",doc"

#########
# tfenv #
#########

# set PATH $HOME/.tfenv/bin $PATH

# pnpm
set -gx PNPM_HOME "/Users/yuhao.huang/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

alias npm 'pnpm'
# pnpm end
