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

########
# TODO #
########

/TODO/ {
    column_number = match($0, "TODO")
    sub(/^\+[ ]*/,"",$0)
    print_vim_quickfix(column_number)
    printf("%sRemaining TODO:%s %s\n", CYAN, RESET, $0)
}

##########
# Python #
##########

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

/\.error\(/ {
    print_vim_quickfix()
    print("use logger.exception if it's in an Exception")

    # print("`logger.exception` is equivalent to `logger.error(\"msg\", exc_info=True)`,
    # logger.error(\"msg\") doesn't include the error stacktrace. 
    # > Exception info is added to the logging message. This function should only be called from an exception handler.
    # https://docs.python.org/3/library/logging.html#logging.exception
    # ")
}


##################
# Oneview Django #
##################


/unittest.*TestCase/ {
    print("WRONG! from django.test import TestCase instead")
}

/class.*[^E][^n][^u][^m](\(Enum|\(TextChoice)/ {
    print_vim_quickfix()
    print("consider adding Enum postfix to this name")
}

##########
# Celery #
##########

/app[.]task/ {
    print_vim_quickfix()
    print("makes sure a unique name is defined.")
}

#######
# Git #
#######

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
