#!/usr/bin/awk -f

function print_warning(message) {
    printf("%s:%s:0 warning: %s\n", FILENAME, FNR, message)
}


/^function / {
    print_warning("'!' missing in function definition")
}

/execute "normal / {
    print_warning("'!' missing in execute normal")
}

/^command / {
    print_warning("'!' missing in command definition")
}
