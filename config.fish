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

function __fish_print_pipestatus_tiger --description "Print pipestatus for prompt"
    # Tiger changes
    # show status 0 too
    # different to https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_print_pipestatus.fish
    set -l last_status
    if set -q __fish_last_status
        set last_status $__fish_last_status
    else
        set last_status $argv[-1] # default to $pipestatus[-1]
    end
    set -l left_brace $argv[1]
    set -l right_brace $argv[2]
    set -l separator $argv[3]
    set -l brace_sep_color $argv[4]
    set -l status_color $argv[5]

    set -e argv[1 2 3 4 5]

    if not set -q argv[1]
        echo error: missing argument >&2
        status print-stack-trace >&2
        return 1
    end

    # Only print status codes if the job failed.
    # SIGPIPE (141 = 128 + 13) is usually not a failure, see #6375.
    if not contains $last_status 141
        set -l sep $brace_sep_color$separator$status_color
        set -l last_pipestatus_string (fish_status_to_signal $argv | string join "$sep")
        set -l last_status_string ""
        if test "$last_status" -ne "$argv[-1]"
            set last_status_string " "$status_color$last_status
        end
        set -l normal (set_color normal)
        # The "normal"s are to reset modifiers like bold - see #7771.
        printf "%s" $normal $brace_sep_color $left_brace \
            $status_color $last_pipestatus_string \
            $normal $brace_sep_color $right_brace $normal $last_status_string $normal
    end
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
        set -l pipestatus_string (__fish_print_pipestatus_tiger " Return Code [" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        jobs >/dev/null 2>&1 ; set jobs_return_code $status
        if test $jobs_return_code -eq 0
            set jobs_status '(has background job)'
        else
            set jobs_status ''
        end

        printf '[%s] %s%s %s%s%s%s%s\n> ' \
            (date "+%H:%M:%S") \
            (set_color $fish_color_cwd) $PWD  \
            (set_color white) (fish_git_prompt) \
            $pipestatus_string \
            $jobs_status \
            (set_color normal)
    end
end

set -g fish_key_bindings fish_hybrid_key_bindings

set PATH /opt/homebrew/bin /usr/local/bin /usr/sbin $HOME/.local/bin $PATH

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
set ONEVIEW        "$HOME/Documents/oneview/"

#######
# git #
#######

abbr ,gh_pr_view 'gh pr view --web'
function ,gh_pr_create 
    gh pr create --base development --draft --fill-verbose 
end
function ,gh_ci_backend_open_in_browser
    set link $(gh pr checks --json 'workflow' --json 'link' | jq '.' | grep 'backend' -C 1 | grep 'link' | grep -o 'http[^"]*')
    open $link
end
function ,gh_pr_description_update_with_commit_message --description "Push last commit message to current GitHub PR description"
    git log -1 --pretty=%B | gh pr edit --body-file -
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
abbr ,g_delete_branches 'git branch | grep -v -e "*" -e " main" -e " development" -e " master" -e " env/" -e " prep/" | xargs git branch -D'

function ,g_new_branch --argument-names branch_name
    git switch $GIT_BASE_BRANCH
    git pull
    git switch -c "$branch_name"
end

abbr ,g_disable_hooks 'git config core.hooksPath /dev/null'

abbr ,g_template_disable 'git config --local commit.template "/dev/null"'
abbr ,g_template_enable 'git config --local --unset commit.template'

function ,gs_notes
    set directories personal-notes dotfiles notes
    for directory in $directories
        set_color --bold cyan; echo ===== $directory =====; set_color normal;
        git -C "$HOME/Documents/$directory" status
        echo ""
    end
end

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

abbr ,ed "vim $PERSONAL_NOTES/dev_notes.md"
abbr ,ef "vim $DOTFILES/config.fish"
abbr ,eg "vim $DOTFILES/.gitconfig"
abbr ,ek "vim $DOTFILES/kitty.conf"
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

    echo '~~~~ copy ipython config ~~~~'
    docker compose --env django poetry run ipython profile create
    docker compose --file docker-compose-dev.yml cp $PERSONAL_NOTES"ipython_config.py" django:/home/oneview/.ipython/profile_default/ipython_config.py

    echo '~~~~ set django bash to have vim key binding  ~~~~'
    docker compose --file docker-compose-dev.yml cp $PERSONAL_NOTES".inputrc" django:/home/oneview/.inputrc

    echo '~~~~ set postgres `psql` to have vim key binding  ~~~~'
    docker compose --file docker-compose-dev.yml cp $PERSONAL_NOTES".inputrc" postgres:/root/.inputrc
end
abbr ,be ',docker_setup_backend_utils'

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
function ,pnpm_run_lint
    cd ~/Documents/oneview/reactapp
    pnpm run lint
end
function ,pnpm_run_test
    cd ~/Documents/oneview/reactapp
    pnpm run test
end
abbr ,fe ',pnpm_run_frontend'

##################
# docker compose #
##################

abbr ,dc_logs_django "docker compose logs --follow django"
abbr ,dc_logs_celery "docker compose logs --follow celery_worker"
abbr ,dc_logs_postgres "docker compose logs --follow postgres"
abbr ,dc_root_bash_django "docker compose exec --user root django /bin/bash"
abbr ,dc_root_bash_postgres "docker compose exec --user root postgres /bin/bash"
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

abbr ,aws_sso_login_restart_containers "aws sso login && docker restart oneview-django-1 && docker restart oneview-celery-1"

###########
# scripts #
###########

alias ,ssh "TERM=xterm-256color python3 $ONEVIEW/scripts/ssh.py" 
alias ,jira "$DOTFILES/.venv/bin/python3 $DOTFILES/jira.py" 
alias ,curo "$DOTFILES/.venv/bin/python3 $DOTFILES/curo.py" 
alias ,autogui "$DOTFILES/.venv/bin/python3 $DOTFILES/autogui.py"
alias ,deployment "$DOTFILES/.venv/bin/python3 $DOTFILES/deployment.py"

function ,doc --argument-names query
    open "https://devdocs.io/?q=$query"
end

########
# pnpm #
########
set -gx PNPM_HOME "/Users/yuhao.huang/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

alias npm 'pnpm'

##########
# saltus #
##########

set POETRY_RUN_PREFIX "docker compose exec -e PYTHONWARNINGS=ignore -e DISABLE_LOGS=1 -e IS_RUNNING_UNITTEST=1 django poetry run"

alias django-admin "$POETRY_RUN_PREFIX python manage.py"
alias django-admin-showmigrations "$POETRY_RUN_PREFIX python manage.py showmigrations"
alias django-admin-migrate-oneview "$POETRY_RUN_PREFIX python manage.py migrate oneview"

alias t_pdb "python3 $DOTFILES/test.py --pdb"
alias t_no_keep_db "python3 $DOTFILES/test.py --no-keep-db"

function t
    python3 $DOTFILES/test.py $argv | tee /tmp/test_data.txt
    cat /tmp/test_data.txt | python3 $DOTFILES/python_unittest_output_parser.py

    if test $pipestatus[1] -eq 0
        kitten notify "✅ Tests pass"
    else
        kitten notify "❌ Tests fail"
    end
end

function ta
    python3 $DOTFILES/test.py | tee /tmp/test_data.txt
    cat /tmp/test_data.txt | python3 $DOTFILES/python_unittest_output_parser.py

    if test $pipestatus[1] -eq 0
        kitten notify "✅ Tests pass"
    else
        kitten notify "❌ Tests fail"
    end
end

function ta_no_keep_db
    python3 $DOTFILES/test.py --no-keep-db | tee /tmp/test_data.txt
    cat /tmp/test_data.txt | python3 $DOTFILES/python_unittest_output_parser.py

    if test $pipestatus[1] -eq 0
        kitten notify "✅ Tests pass"
    else
        kitten notify "❌ Tests fail"
    end

    # run a fake test just to set up database with --keepdb
    python3 $DOTFILES/test.py >/dev/null 2>&1 &
end

function la 
    python3 $DOTFILES/lint.py

    if test $status -eq 0
        kitten notify "✅ Lint pass"
    else
        kitten notify "❌ Lint fail"
    end
end

#######
# gpg #
#######

set -gx GPG_TTY (tty)

##########
# claude #
##########

alias ,c "claude --add-dir '/Users/yuhao.huang/Documents/personal-notes' --add-dir '/Users/yuhao.huang/Documents/dotfiles'"
alias ,claude "claude --add-dir '/Users/yuhao.huang/Documents/personal-notes' --add-dir '/Users/yuhao.huang/Documents/dotfiles'"
function ,c_quick_review_changes
    claude --print 'Please QUICKLY tell me what is wrong with the code changes from git diff, if there is no diff, review last commit' > /tmp/c_quick_review_changes.md
    bat --language md --terminal-width 80 --style plain --pager '/usr/bin/less' /tmp/c_quick_review_changes.md
end

function ,c_print_bat
    claude --print $argv > test.md
    bat --language md --terminal-width 80 --style plain --pager '/usr/bin/less' test.md
end

#########
# kitty #
#########

alias icat "kitten icat"


#ce6a6b, #f07173 (muted red)
#ebaca2, #ffc9c2 (light peach)
#bed3c3, #d9efe0 (soft green)
#4a919e, #6fc2d0 (cyan)
#212e53, #3a4f85 (dark navy)

function ,setup_vim_tab
    kitten @ set-tab-title vim
    # cyan
    kitten @ set-tab-color inactive_bg=#4a919e active_bg=#6fc2d0
end

function ,setup_lint_test_tab
    # Sets up two horizonal tabs
    # Top tab: run lint on watch python file changes
    # Bottom tab
    #   - tab with title runtest, in vim use <leader>u to trigger tests to run
    cd $ONEVIEW
    kitten @ set-tab-title lint_test
    # light peach
    kitten @ set-tab-color inactive_bg=#ebaca2 active_bg=#ffc9c2
    kitten @ resize-window --self --axis vertical --increment -8

    kitten @ launch --type=window --title runtest --keep-focus --cwd current
    kitten @ create-marker --match 'title:runtest' regex 3 \\bERROR\\b 3 \\bFAIL\\b

    # watchexec --exts py --quiet -- 'fd .py | ctags -f /tmp/tags_temp -L - && mv /tmp/tags_temp tags' &
    # lint with autofix
    # --postpone: Wait until first change before running command
    # --restart: Restart the process if it's still running
    # --interactive: Respond to keypresses to quit (q), restart (r), or pause (p)
    watchexec --exts py --quiet --postpone --restart --interactive -- python3 "$DOTFILES/lint.py"
end

function ,kitty_detach_window
    kitten @ detach-window --target-tab new
end
