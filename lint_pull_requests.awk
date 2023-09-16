#!/usr/bin/awk -f


BEGIN {
    CYAN = "\033[36m";
    RESET = "\033[31m";
}

function print_warning(message) {
    printf("%s:%s:0 warning: %s\n", FILENAME, FNR, message)
}


/TODO/ {
    printf("%s Remaining TODO:%s %s \n", CYAN, RESET, $0)
}
