#!/usr/bin/awk -f
/^function [^_]/ {
    # remove everything after e.g. ',s(){' becomes ,s'
    sub(/[(].*/, "", $2)
    function_name=$2

    if (last_line ~ /^#.*/) {
        # last_line is comment for this function
        comment=last_line
    } else {
        comment=""
    }

    printf("%-30s \033[33m %s \033[0m\n", function_name, comment)
}

{ last_line = $0 }

/^alias [^_]/ {
    # split whole line "alias v='vim'" by =
    # so the second element will be alias definition e.g. "vim"
    alias_definition = substr($0, index($0, "=") + 1)
    # remove ' and " at the beginning or the end
    gsub(/^'|^"|"$|'$/, "", alias_definition)

    # split "v='vim'" by =
    # so the first element will be alias name e.g. "v"
    split($2, alias_name_list, "=")
    alias_name = alias_name_list[1]

    printf("%-30s \033[33m %s \033[0m\n", alias_name, alias_definition)
}
