#!/usr/bin/awk -f

BEGIN {
    CYAN = "\033[36m";
    RESET = "\033[0m";
}

function print_warning(message) {
    printf("%s:%s:0 warning: %s\n", message)
}


/TODO/ {
    sub(/^\+[ ]*/,"",$0)
    printf("%s:0:0 ", filename)
    printf("%sRemaining TODO:%s %s\n", CYAN, RESET, $0)
}

/breakpoint/ {
    sub(/^\+[ ]*/,"",$0)
    printf("%s:0:0 ", filename)
    printf("%sRemaining breakpoint:%s %s\n", CYAN, RESET, $0)
}

/except:/ {
    print($0)
    print("Don't think you want a bare except")
}

/except Exception:/ {
    print($0)
    print("Are you sure you want except Exception?")
    print("If so, check if you log the traceback, this makes sure user will be aware that an error has occurred.")
}

/try:/ {
    print($0)
    print("limit try: to absolute minimal amount of code")
}

/^[+][+][+]/ {
    # find filename from git diff message
    filename = $2
}
