#!/bin/sh

function parse_mappings() {
    grep -e '^"' -e '^let' -v |\
        fgrep --word-regexp -e 'nmap' -e 'nnoremap' -e 'vmap' -e 'inoremap' -e 'map' |\
            sed -e 's/<buffer>//g' -e 's/<expr>//g' -e 's/<silent>//g' |\
                grep -o '\b[a-z]*map.*'
}

function parse_commands() {
    grep -e '^command' |\
        sed -e 's/ -bang -nargs=?//g'
}

function sort_and_format_output() {
    # $1 is the mapping keyword e.g. nnoremap
    # $2 is the mapping e.g. <leader>a
    sort -k 1,2b |\
        awk '{
            printf("%-15s %-24s", $1, $2);
            printf("\033[33m") # color yellow
            for(i=3; i<=NF; ++i) printf("%s ", $i);
                printf("\033[0m") # reset
                printf("\n"); # print from the 3rd arguments to the last
            }'
}

cat ~/.vimrc |\
    parse_mappings |\
        sort_and_format_output

cat ~/.vimrc |\
    parse_commands |\
        sort_and_format_output
