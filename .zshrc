##########
# Python #
##########

function ,virtualenv_setup() {
    _echo_green 'setting up virtualenv at .venv folder'
    python3 -m venv .venv
    _echo_green  'activating virtualenv'
    . .venv/bin/activate
    _echo_green 'upgrading pip'
    pip install --upgrade pip
    _echo_green 'pip installing essential libraries'
    pip install -r "$DOTFILES'requirements.txt'"
}

function ,activate() {
    if [[ -d ".venv" ]]; then
        . .venv/bin/activate
    elif [[ -d "venv" ]]; then
        . venv/bin/activate
    else {
        _echo_red 'No virtualenv found!'
        _echo_red 'Consider setup .venv with ,virtualenv_setup'
    }
    fi
}

alias ,python3_8_in_docker='docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3.8 python'
alias ,python3_9_in_docker='docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3.9 python'
alias ,python3_10_in_docker='docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3.10 python'
alias ,python3_11_in_docker='docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3.11 python'

#######
# fzf #
#######

# inspired by https://bluz71.github.io/2018/11/26/fuzzy-finding-in-bash-with-fzf.html
# use fzf to find a custom command
function ,fzf_find_command() {
    # get the list of function and alias names
    # find one using fzf
    local extracted_line=$(
        $DOTFILES'extract_aliases_functions_from_zshrc.awk' < $DOTFILES'.zshrc' | \
        fzf --no-multi --ansi --height 15
    )

    local command_name=$(echo $extracted_line | cut -d ' ' -f 1)
    # -n true if length of string is non-zero, from `man zshmisc` -> conditional expression
    if [[ -n $command_name ]]; then
        # print is a zsh buildin command, there is no `print --help`
        # see https://gist.github.com/YumaInaura/2a1a915b848728b34eacf4e674ca61eb
        # input $command_name as console input NOT as stdout
        # so that I can insert function argument for function that needs argument such as ,gnew_branch foo-bar
        print -z "$command_name "
    fi
}
alias c=',fzf_find_command'

######
# ip #
######

# find the ip of a website ,ip_of https://google.com
function ,ip_of(){
    if [[ $# -eq 0 ]]; then
        _echo_red "Missing first argument"
    fi

    if [[ $# -eq 0 || "$1" = "-h" ]]; then
        echo "Find the ip of a website"
        echo
        echo "Usage:"
        echo "    ,ip_of https://google.com"
        return 1
    fi

    local domain=$(echo "$1" | sed -e "s/^https:\/\///" -e "s/^http:\/\///" -e "s/\/.*$//")

    _echo_green "nslookup $domain ..."
    nslookup $domain

    # $? is the exit code of nslookup, 0 means good, other means bad
    if [[ $? -eq 0 ]]; then
        _echo_green 'Query succeed.'
    else
        _echo_red   'Query failed.'
    fi
}


#########
# MacOS #
#########

function ,copy_last_screenshot() {
   local most_recent_screenshot_name=$(ls -t -1 ~/Desktop/screenshots | head -1)
   local apple_script="set the clipboard to (read (POSIX file \"/Users/yuhao.huang/Desktop/screenshots/$most_recent_screenshot_name\") as {«class PNGf»})"
   osascript -e $apple_script
}

# Tips: use `say 'hello world'` to use sound synthesizer 

alias ,cancel_print_jobs='sudo cancel -a -x'

# ,pandoc_in_docker example.md -o example.pdf --template eisvogel --listings
alias ,pandoc_in_docker='docker run --rm -v "$(pwd):/data" -u $(id -u):$(id -g) pandoc/extra'
