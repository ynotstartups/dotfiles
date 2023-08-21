#!/bin/sh
# 

# 
# grep:  remove comments or let ..
# fgrep: gives me lines with mapping keywords
# sed:   remove modifier tags e.g. remove "<expr>"
# grep:  remove anything up to the mapping, e.g. remove "autocmd FileType markdown"
# sort:  sort by mapping keyword, then mapping
# awk:   final format
# 
cat ~/.vimrc |\
  grep -e '^"' -e '^let' -v |\
    fgrep --word-regexp -e 'nmap' -e 'nnoremap' -e 'vmap' -e 'inoremap' -e 'map' |\
      sed -e 's/<buffer>//g' -e 's/<expr>//g' -e 's/<silent>//g' |\
          grep -o '\b[a-z]*map.*' |\
            sort -k 1,2 |\
              awk '{
                # $1 is the mapping keyword e.g. nnoremap
                # $2 is the mapping e.g. <leader>a
                printf("%-15s %-20s", $1, $2);
                for(i=3; i<=NF; ++i) printf("%s ", $i); printf("\n"); # print from the 3rd arguments to the last
              }'

cat ~/.vimrc |\
  grep '^command' |\
    sed -e 's/ -bang -nargs=?//g' |\
      sed -e 's/command!/command/g' |\
        sort -k 1,2 |\
          awk '{
            # $1 is the mapping keyword e.g. nnoremap
            # $2 is the mapping e.g. <leader>a
            printf("%-15s %-20s", $1, $2);
            for(i=3; i<=NF; ++i) printf("%s ", $i); printf("\n"); # print from the 3rd arguments to the last
          }'
