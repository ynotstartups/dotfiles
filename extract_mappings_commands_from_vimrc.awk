#!/usr/bin/awk -f

# find commands, commands start with `command`
/^command/ {
    # remove '-bang -nargs=?' followed from command
    sub(/ -nargs=0/, "", $0)
    sub(/ -bang/, "", $0)
    sub(/ -range/, "", $0)

    start_index = 2
    print_with_format(start_index)
}

# remove comment and lines starts with let
/^[^#]?[^#]*(nmap|nnoremap|vmap|inoremap|map|cnoremap) / {
    # remove modifier tags e.g. "<expr>"
    sub(/<buffer>/, "", $0)
    sub(/<expr>/, "", $0)
    sub(/<silent>/, "", $0)

    if ($0 ~ /^autocmd/) {
        # for mappings starts with autocmd e.g. autocmd FileType gitcommit 
        # remove the "FileType gitcommit"
        start_index = 5
    } else {
        start_index = 2
    }

    print_with_format(start_index)
}

function print_with_format(start_index) {
    printf("%-30s ", $(start_index))
    printf("\033[33m") # yellow
    for (i = start_index + 1; i <= NF; i++)
        printf("%s ", $(i))
    print("\033[0m") # reset color
}
