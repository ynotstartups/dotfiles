#!/bin/sh
# parse and output mappings or commands from vimrc

# grep:  remove comments or let ..
# fgrep: gives me lines with mapping keywords
# sed:   remove modifier tags e.g. remove "<expr>"
# grep:  remove anything up to the mapping, e.g. remove "autocmd FileType markdown"
function parse_mappings() {
    grep -e '^"' -e '^let' -v |\
        fgrep --word-regexp -e 'nmap' -e 'nnoremap' -e 'vmap' -e 'inoremap' -e 'map' |\
            sed -e 's/<buffer>//g' -e 's/<expr>//g' -e 's/<silent>//g' |\
                grep -o '\b[a-z]*map.*'
}

# grep:  find commands, commands always start with `command!`
# sed:   remove '-bang -nargs=?' followed from command!
function parse_commands() {
    grep -e '^command' |\
        sed -e 's/ -bang -nargs=?//g'
}

function sort_and_format_output() {
    # $1 is the mapping or command! keyword e.g. nnoremap
    # $2 is the actual mapping or command e.g. <leader>a
    sort -k 1,2b |\
        while read type command definition
        do
            printf "%-15s %-24s \033[33m %s \033[0m\n" "$type"  "$command"  "$definition"
        done
}

# cat .vimrc twice are much faster compared to using if statements 
cat ~/.vimrc |\
    parse_mappings |\
        sort_and_format_output

cat ~/.vimrc |\
    parse_commands |\
        sort_and_format_output
