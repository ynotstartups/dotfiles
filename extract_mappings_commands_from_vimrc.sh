#!/bin/sh
# parse and output mappings or commands from vimrc

function parse_mappings() {
    # remove comments or let ..
    grep -e '^"' -e '^let' -v |\
        # gives me lines with mapping keywords
        fgrep --word-regexp -e 'nmap' -e 'nnoremap' -e 'vmap' -e 'inoremap' -e 'map' |\
            # remove modifier tags e.g. remove "<expr>"
            sed -e 's/<buffer>//g' -e 's/<expr>//g' -e 's/<silent>//g' |\
                # remove anything up to the mapping, e.g. remove "autocmd FileType markdown"
                grep -o '\b[a-z]*map.*'
}

function parse_commands() {
    # find commands, commands always start with `command!`
    grep -e '^command' |\
        # remove '-bang -nargs=?' followed from command!
        sed -e 's/ -bang -nargs=?//g'
}

function sort_and_format_output() {
    # $1 is the mapping or command! keyword e.g. nnoremap
    # $2 is the actual mapping or command e.g. <leader>a
    sort -k 1,2b |\
        # the third variable definition reads all the rest of remaining arguments from this line
        while read type command definition
        do
            printf "%-15s %-24s \033[33m %s \033[0m\n" "$type"  "$command"  "$definition"
        done
}

cat ~/.vimrc |\
    parse_mappings |\
        sort_and_format_output

cat ~/.vimrc |\
    parse_commands |\
        sort_and_format_output
