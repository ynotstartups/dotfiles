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

function ,gnew_branch --argument-names new_branch_name
    # create a new branch on top of the base branch (e.g. main or development)
    git fetch origin $GIT_BASE_BRANCH:$new_branch_name

    # switch to this new branch
    git switch $new_branch_name
end

abbr ,g_apply_patch_faster_python_unittest 'git apply ~/Documents/personal-notes/faster_python_unittest.patch'

#########
# MacOS #
#########

abbr m 'make'

function ,convert_md_to_pdf --argument-names markdown_name pdf_name
    if not test (set --query pdf_name)
        set pdf_name "pdfs/$(echo $markdown_name | sed 's/.md$/.pdf/')"
    end

    set_color --bold green
    echo "Converting from" $markdown_name "to" $pdf_name
    set_color normal

    # pin `pandoc/extra` to tag `3.1` because latest tag `latest`
    # has this issue https://github.com/Wandmalfarbe/pandoc-latex-template/pull/392
    # that makes this ,convert_md_to_pdf unable to produce pdf
    docker run --rm \
        -v "$(pwd):/data" \
        pandoc/extra:3.1 \
        "$markdown_name" -o $pdf_name \
        --template eisvogel --listings \
        -V book --top-level-division chapter -V classoption=oneside
    and echo "Done, please see $pdf_name."
    or echo "Failed!"
end

abbr ,hardcopy 'lpr -o Resolution=720x720dpi'
abbr ,hardcopy_normal_quality 'lpr -o Resolution=360x360dpi'
abbr ,hardcopy_10_graph_papers 'lpr -o Resolution=360x360dpi -# 10 ~/Documents/dotfiles/a4-graph.pdf'
abbr ,hardcopy_10_standup_papers 'lpr -o Resolution=360x360dpi -# 10 ~/Documents/dotfiles/a4-graph-standup-hardcopy.pdf'

abbr ,autogui '~/Documents/autogui/.venv/bin/python ~/Documents/autogui/autogui.py'

######
# rg #
######

set --global --export RIPGREP_CONFIG_PATH $HOME/.rgrc

abbr rg_python_ignore_tests 'rg -t py -g "!**/tests/**"'

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

abbr ,ed "vim $PERSONAL_NOTES/dev_notes.md"
abbr ,eb "vim $PERSONAL_NOTES/.bashrc"
abbr ,ef "vim $DOTFILES/config.fish"
abbr ,ev "vim $DOTFILES/.vimrc"
abbr ,eg "vim $DOTFILES/.gitconfig"
abbr ,ek "vim $DOTFILES/kitty.conf"
abbr ,em "vim ~/Documents/menu/app.py"

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

function ,_ssh_oneview --argument-names ec2_name command
    if not pgrep -q 'AWS VPN'
        set_color --bold red
        echo "Did you forget to turn on AWS VPN?"
        set_color normal
        return 1
    end

    set ip_address (aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=$ec2_name" \
        --output text --query 'Reservations[*].Instances[*].PrivateIpAddress' \
    )

    # 1. don't do StrictHostKeyChecking as ip always changes in virtual private
    # cloud (VPC)
    # 2. reduces the default ConnectTimeout to avoid hanging
    # 3. `-i identity_file`, selects a file from which the identity (private key)
    # for public key authentication is read.
    ssh -t -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i '~/.ssh/ssh-private-key' "ec2-user@$ip_address" "$command"
end

function ,ssh_test
    ,_ssh_oneview 'oneview-test-leader'
end

function ,ssh_test2
    ,_ssh_oneview 'OneView-test2-leader'
end

function ,ssh_test3
    ,_ssh_oneview 'OneView-test3-leader'
end

function ,ssh_uat
    ,_ssh_oneview 'oneview-uat-leader'
end

function ,ssh_prod
    ,_ssh_oneview 'oneview-prod-leader'
end


function ,ssh_test_python
    ,_ssh_oneview 'oneview-test-leader' "sudo docker exec -it oneview-django poetry run python manage.py shell" 
end

function ,ssh_test2_python
    ,_ssh_oneview 'OneView-test2-leader' "sudo docker exec -it oneview-django poetry run python manage.py shell" 
end

function ,ssh_test3_python
    ,_ssh_oneview 'OneView-test3-leader' "sudo docker exec -it oneview-django poetry run python manage.py shell" 
end

function ,ssh_uat_python
    ,_ssh_oneview 'oneview-uat-leader' "sudo docker exec -it oneview-django poetry run python manage.py shell" 
end

function ,ssh_prod_python
    ,_ssh_oneview 'oneview-prod-leader' "sudo docker exec -it oneview-django poetry run python manage.py shell" 
end


function ,ssh_test_bash
    ,_ssh_oneview 'oneview-test-leader' "sudo docker exec -it oneview-django bash" 
end

function ,ssh_test2_bash
    ,_ssh_oneview 'OneView-test2-leader' "sudo docker exec -it oneview-django bash" 
end

function ,ssh_test3_bash
    ,_ssh_oneview 'OneView-test3-leader' "sudo docker exec -it oneview-django bash" 
end

function ,ssh_uat_bash
    ,_ssh_oneview 'oneview-uat-leader' "sudo docker exec -it oneview-django bash" 
end

function ,ssh_prod_bash
    ,_ssh_oneview 'oneview-prod-leader' "sudo docker exec -it oneview-django bash" 
end


function ,npm_run_frontend
    cd ~/Documents/oneview/reactapp
    npm start
end
abbr ,fe ',npm_run_frontend'

function ,deployments --argument-names environments
    # Usage: `,deployments uat` or `,deployments`

    # if variable $environments is not set, 
    # set environments to a list of environments
    if not test -n "$environments"
      set environments 'test' 'test2' 'test3' 'uat' 'prod'
    end

    for env in $environments
        set_color --bold
        echo "In environment $env..."
        set_color normal

        set_color cyan
        echo "FE Deployment..."
        set_color normal
        set oneview_app_id 'dfgwx0v13a7s4'
        aws amplify list-jobs --app-id "$oneview_app_id" --branch-name "env/$env" |\
            jq '.jobSummaries[0] | {"status": .status, "job id": .jobId, "deployment time": .endTime, "commit message": .commitMessage}'

        set_color cyan
        echo "BE Deployment..."
        set_color normal
        aws codepipeline get-pipeline-state --name "oneview-$env" |\
            jq '.stageStates[] | {"stage": .stageName, "status": .latestExecution.status, "last status changed time": .actionStates[0].latestExecution.lastStatusChange}'
    end
end

function _curo_help
    argparse h/help -- $argv
    if set -ql _flag_help
        echo "Entity Names: t4a_curoholding, t4a_review, account"
        return 0
    else
        return 1
    end
end

function ,curo_prod_open_entity_name_with_id --argument-names entity_name record_id
    if _curo_help $argv
        return 0
    end
    set url "https://saltus.curo3.net/main.aspx?etn=$entity_name&pagetype=entityrecord&id=%7B$record_id%7D"
    echo $url 
    open $url
end

function ,curo_uat_open_entity_name_with_id --argument-names entity_name record_id
    if _curo_help $argv
        return 0
    end
    set url "https://saltus.curo3uat.net/main.aspx?etn=$entity_name&pagetype=entityrecord&id=%7B$record_id%7D"
    echo $url
    open $url
end

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

########
# jira #
########

function ,jira --argument-names ticket_number
    set ticket_number (string replace -r '^ON-' '' $ticket_number)
    open "https://saltus.atlassian.net/browse/ON-$ticket_number"
end

# put jira ticket link to clipboard
function ,jira! --argument-names ticket_number
    set ticket_number (string replace -r '^ON-' '' $ticket_number)
    printf "https://saltus.atlassian.net/browse/ON-$ticket_number" | pbcopy
end

#########
# tfenv #
#########

# set PATH $HOME/.tfenv/bin $PATH
