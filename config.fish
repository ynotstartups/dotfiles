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

alias e='exit'
alias h='help'
alias ll='ls -lha'
alias m='man'

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

alias fd_all_files='fd --hidden --no-ignore'

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
    cd $PERSONAL_NOTES
    vim -p standup_notes.md dev_notes.md .bashrc
end

#######
# git #
#######

function ,pr_checkout --argument-names branch_name
    # TODO: stops if there are local changes save local changes
    git stash

    # switch to branch and fetch latest changes
    git fetch
    git switch $branch_name
    git reset --hard origin/$branch_name
end

function ,g_lint
    git diff --color=never -U0 --no-prefix --raw origin/master... | ~/Documents/dotfiles/lint_pull_requests.py
    git diff --color=never -U0 --no-prefix --raw --cached | ~/Documents/dotfiles/lint_pull_requests.py
    git diff --color=never -U0 --no-prefix --raw | ~/Documents/dotfiles/lint_pull_requests.py
end

alias ,pr_lint=',g_lint'

function ,gh_actions_watch
    while true
        set_color --bold cyan
        echo "... Watching github action status for$(fish_git_prompt) ..."
        set_color normal
        echo ""
        gh pr checks
        sleep 5
    end
end

abbr ,gh_pr 'gh pr view --web'
abbr ,gh_s 'gh pr checks'
abbr ,gh_d 'gh pr diff | delta'

alias g='git'
alias gs='git status'

# delete every branches except main & master & current branch
alias ,gdelete_branches='git branch | grep -v "main" | grep -v "development" | grep -v "master" | grep -v "prod" | grep -v "uat" | grep -v "*" | xargs git branch -D'

alias ,g_template_disable='git config --local commit.template "/dev/null"'
alias ,g_template_enable='git config --local --unset commit.template'

function ,gs_notes
    set directories personal-notes dotfiles notes docs

    for directory in $directories
        set_color --bold cyan; echo ===== $directory =====; set_color normal;
        git -C "$HOME/Documents/$directory" status
        echo ""
    end
end

function ,gnew_branch --argument-names new_branch_name
    git fetch origin $GIT_BASE_BRANCH:$new_branch_name
    git switch $new_branch_name
end

#########
# MacOS #
#########

alias ,make_temp_folder='cd $(mktemp -d -t "tigertmp")'

function ,convert_md_to_pdf --argument-names markdown_name pdf_name
    if not test (set --query pdf_name)
        set pdf_name "pdfs/$(echo $markdown_name | sed 's/.md$/.pdf/')"
    end

    set_color --bold green
    echo "Converting from" $markdown_name "to" $pdf_name
    set_color normal

    docker run --rm \
        -v "$(pwd):/data" \
        pandoc/extra \
        "$markdown_name" -o $pdf_name \
        --template eisvogel --listings \
        -V book --top-level-division chapter -V classoption=oneside
    and echo "Done, please see $pdf_name."
    or echo "Failed!"
end

alias ,hardcopy='lpr -o Resolution=720x720dpi'
alias ,hardcopy_A5='lpr -o media=A5 -o Resolution=720x720dpi'
alias ,hardcopy_normal_quality='lpr -o Resolution=360x360dpi'
alias ,hardcopy_5_standup_template='\
    lpr -o scaling=110 -o Resolution=360x360dpi \
    -# 5 ~/Documents/personal-notes/pdfs/standup_template.pdf'
alias ,hardcopy_5_solo_rpg_template='\
    lpr -o scaling=110 -o Resolution=360x360dpi \
    -# 5 ~/Documents/personal-notes/pdfs/solo_rpg_template.pdf'


# Cups link: http://localhost:631/
# logins with laptops's username and password
# /private/etc/cups/ppd

######
# rg #
######

set --global --export RIPGREP_CONFIG_PATH $HOME/.rgrc

########
# Node #
########

set PATH /opt/homebrew/opt/node@16/bin $PATH

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
set --global --export PYTHONPATH $HOME/.pyenv/versions/3.11.4/lib/python3.11/site-packages/

function vim
    # when count is 0 and readme exists open readme
    # uses test to ignore the output from count
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

function ,vfd
    # fish doesn't have `<(foo)` syntax instead you can do (foo | psub)
    vim $(fd $argv) -c 'args'
end

abbr ,ed "cd $PERSONAL_NOTES && vim dev_notes.md"
abbr ,ef "cd $DOTFILES       && vim config.fish"
abbr ,ev "cd $DOTFILES       && vim .vimrc"
abbr ,eg "cd $DOTFILES       && vim .gitconfig"

alias ,vgd='  vim -c ":Git difftool"'
alias ,vgds=' vim -c ":Git difftool --staged"'
alias ,vgdo=' vim -c ":Git difftool origin/master..."'
# open in tabs
alias ,vgdot='vim -c ":Git difftool -y origin/master..."'

########
# Tags #
########

# alias ,ctags_generate_for_python='ctags --python-kinds=-v **/*.py'
alias ,generate_ctags_for_python='ctags **/*.py'

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

alias ,python3_8_in_docker='docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3.8 python'
alias ,python3_9_in_docker='docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3.9 python'
alias ,python3_10_in_docker='docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3.10 python'
alias ,python3_11_in_docker='docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3.11 python'

#########
# Pyenv #
#########

set -Ux PYENV_ROOT $HOME/.pyenv
set PATH $PYENV_ROOT $PATH
pyenv init - | source

############
# Postgres #
############

set PATH /Applications/Postgres.app/Contents/Versions/latest/bin $PATH

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

alias ,dc_e2e='docker compose --file docker-compose-e2e.yml'
alias ,dc='docker compose --file docker-compose-dev.yml'

function ,docker_remove_db_volume
    docker stop oneview-postgres-1
    # remove the postgres container
    docker rm oneview-postgres-1
    # drops the volume 
    docker volume rm oneview_pgdata
end


# docker compose build oneview backend with dev dependencies and personal .bashrc
function ,docker_build_backend
    echo '~~~~ cd into oneview ~~~~'
    cd ~/Documents/oneview

    echo '~~~~ generating ctags ~~~~'
    ctags **/*.py

    echo '~~~~ docker compose build and up backend detached ~~~~'
    docker compose -f docker-compose-dev.yml up --build --detach django

    echo '~~~~ poetry install dev ~~~~'
    docker exec --env -t oneview-django-1 poetry install --with dev

    echo '~~~~ copy over bashrc ~~~~'
    docker compose cp "$PERSONAL_NOTES.bashrc" django:/root/.bashrc

    echo '~~~~ copy ipython config ~~~~'
    docker exec --env -t oneview-django-1 poetry run ipython profile create
    docker compose cp $DOTFILES"ipython_config.py" django:/root/.ipython/profile_default/ipython_config.py

    echo '~~~~ django logs ~~~~'
    docker compose -f docker-compose-dev.yml logs -f django
end
alias ,be=',docker_build_backend'

alias ,docker_cp_bashrc='cd ~/Documents/oneview && docker compose cp $PERSONAL_NOTES".bashrc" django:/root/.bashrc'
function ,docker_attach_oneview
    set CONTAINER_ID (docker container ls | grep oneview-django | cut -d ' ' -f 1)
    docker attach $CONTAINER_ID
end

abbr mb "make bash" 
abbr ms "make shell" 
abbr ml "make lint" 
abbr mt "make test" 

# alias eb instead of exporting the PATH suggested in https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install-osx.html
# because exporting the PATH pollutes it with unwanted executables within that virtualenv ! e.g. python, pip ...
alias eb='~/Documents/elastic-beanstalk-cli/.venv/bin/eb'


function ,_ssh_oneview --argument-names env_name 
    if not pgrep -q 'AWS VPN'
        set_color --bold red
        echo "Did you forget to turn on AWS VPN?"
        set_color normal
        return 1
    end

    # TODO: raise error if env_name is not `env` or `prod`

    if not string match --quiet 'uat' $env_name && not string match --quiet 'prod' $env_name
        set_color --bold red
        echo "Only supports env 'uat' or 'prod', env '$env_name' is not supported"
        set_color normal
        return 1
    end

    set ip_address (aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=oneview-$env_name-leader" \
        --output text --query 'Reservations[*].Instances[*].PrivateIpAddress' \
    )

    # don't do StrictHostKeyChecking as we are using VPC, virtual private
    # network
    # reduces the default ConnectTimeout to avoid hanging
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i '~/.ssh/aws-eb' "ec2-user@$ip_address"
end

function ,ssh_uat
    ,_ssh_oneview 'uat'
end

function ,ssh_prod
    ,_ssh_oneview 'prod'
end

function ,ssh --argument-names ip_address
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i '~/.ssh/aws-eb' "ec2-user@$ip_address"
end

function ,npm_run_frontend
    cd ~/Documents/oneview/reactapp
    npm start
end

alias ,fe=',npm_run_frontend'

function commit_diff_two_branches --argument-names first_branch second_branch
    set BOLD_WHITE "\033[1;37m"
    set RESET "\033[0m"

    set number_of_new_commits  (\
        git log --oneline $first_branch..$second_branch |\
          wc -l |\
            # wc starts with tab, remove it, extract the number of lines only
            grep -o '\d*' \
    )

   if test $number_of_new_commits -gt 0  
       printf "$BOLD_WHITE$second_branch$RESET are ahead of $BOLD_WHITE$first_branch$RESET by $BOLD_WHITE$number_of_new_commits$RESET commits\n"
       echo "...ordered from old commits to new commits"
       echo

       # change the format to hash, commit date, commit message
       git --no-pager log $first_branch..$second_branch \
           --reverse \
           --pretty=format:"%C(yellow)%h %Creset%C(cyan)%C(bold)%<(18)%ad %Creset%C(green)%C(bold)%<(20)%an %Creset%s" \
           --date human
       echo
   else
       printf "$BOLD_WHITE$second_branch$RESET are $BOLD_WHITE" 
       printf "NOT"
       printf "$RESET ahead of $BOLD_WHITE$first_branch$RESET\n"
   end

   echo
   printf "Lastest commit of $BOLD_WHITE$second_branch$RESET is\n"
   git --no-pager log $second_branch \
       -1 \
       --pretty=format:"%C(yellow)%h %Creset%C(cyan)%C(bold)%<(18)%ad %Creset%C(green)%C(bold)%<(20)%an %Creset%s" \
       --date human
   echo
end

function ,g_branch_diff --argument-names branch_name
    # get the latest changes
    git fetch --quiet

    set origin_branch_name "origin/$branch_name"
    set origin_master "origin/master"

    echo
    commit_diff_two_branches $origin_branch_name $origin_master

    echo
    git diff --exit-code --quiet $origin_branch_name saltus/oneview/migrations

    if test $status -eq 1
        set_color --bold red
        echo 'There are new migrations! ONLY DEPLOY AT NIGHT!'
        set_color normal
        git --no-pager diff --stat $origin_branch_name...$origin_master saltus/oneview/migrations
    else
        set_color --bold green
        echo 'There is NO new migrations! OK to deploy anytime.'
        set_color normal
    end

    echo
    commit_diff_two_branches $origin_master $origin_branch_name
end

function ,branch_diff --argument-names branch
    cd /Users/yuhao.huang/Documents/oneview
    ,g_branch_diff $branch
end

function ,uat_diff
    cd /Users/yuhao.huang/Documents/oneview
    ,g_branch_diff env/uat
end

function ,prod_diff
    cd /Users/yuhao.huang/Documents/oneview
    ,g_branch_diff env/prod
end

function ,uat_deploy_safe
    cd /Users/yuhao.huang/Documents/oneview

    # print each command on
    set fish_trace on

    git stash
    git switch env/uat
    git fetch origin
    git merge --ff-only origin/master
    git push 

    # print each command off
    set -e fish_trace
end



set --global curo_entity_names "t4a_feeprofile" "t4a_incomeprofile" "account" "t4a_curoholding"

function ,curo_prod_open_entity_name_with_id --argument-names entity_name record_id

    if not contains $entity_name $curo_entity_names 
        printf "please add to the function for future reference"
    end
    # open "https://saltus.curo3.net/main.aspx?etn=$entity_name&pagetype=entityrecord&id=%7B$record_id%7D"
    open "https://saltus.curo3.net/main.aspx?etn=$entity_name&pagetype=entityrecord&id=%7B$record_id%7D"
end

function ,curo_uat_open_entity_name_with_id --argument-names entity_name record_id

    if not contains $entity_name $curo_entity_names 
        printf "please add to the function for future reference"
    end
    # open "https://saltus.curo3.net/main.aspx?etn=$entity_name&pagetype=entityrecord&id=%7B$record_id%7D"
    open "https://saltus.curo3uat.net/main.aspx?etn=$entity_name&pagetype=entityrecord&id=%7B$record_id%7D"
end

abbr pytest_useful "pytest -rA --lf -x --show-capture no -vv"
