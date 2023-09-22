#!/usr/bin/awk -f

BEGIN {
    CYAN = "\033[36m";
    RESET = "\033[0m";
}

function print_warning(message) {
    printf("%s:%s:0 warning: %s\n", message)
}

function print_vim_quickfix(column_number) {
    if (!column_number) {
        column_number = 0
    } else {
        column_number -= 1
    }
    printf("%s:%s:%s: ", filename, addition_starting_line_number - 1, column_number)
}


# this one needs to at the top so that the starting line number is calculated
# first 
/^[+]/ {
    # find filename from git diff message
    addition_starting_line_number += 1
}


/TODO/ {
    column_number = match($0, "TODO")
    sub(/^\+[ ]*/,"",$0)
    print_vim_quickfix(column_number)
    printf("%sRemaining TODO:%s %s\n", CYAN, RESET, $0)
}

/breakpoint/ {
    sub(/^\+[ ]*/,"",$0)
    print_vim_quickfix()
    printf("%sRemaining breakpoint:%s %s\n", CYAN, RESET, $0)
}

/except:/ {
    print_vim_quickfix()
    print("Don't think you want a bare except")
}

/except Exception:/ {
    print_vim_quickfix()
    print("Are you sure you want except Exception?")
    print("If so, check if you log the traceback, this makes sure user will be aware that an error has occurred.")
}

/try:/ {
    print_vim_quickfix()
    print("limit try: to absolute minimal amount of code")
}

/^[+][+][+]/ {
    # find filename from git diff message
    filename = $2
}

/@@ -[0-9]+,[0-9]+ \+[0-9]+,[0-9]+ @@/ {
    # The array indices below are according to the parenthetical group number in the regex
    # above; see: 
    # https://www.gnu.org/software/gawk/manual/html_node/String-Functions.html#index-match_0028_0029-function
    # left_num = array[4]  # left (deletion) starting line number
    # right_num = array[5] # right (addition) starting line number
    sub(/^[+]/, "", $3)
    sub(/[,].*$/, "", $3)
    addition_starting_line_number = $3
}
