#!/bin/bash
# TODO: find a way to deal with images
# TODO: change I change the format of date so that the default sort order follows date order

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

PATH_TO_DEV_NOTES="$HOME/Documents/personal-notes/dev_notes.md"

# --fields=+ne adds extra field line: and end: to denote the start line and end
# line of the title "# FOO BAR"
ctags -f - --fields=+ne "$PATH_TO_DEV_NOTES" |\
    grep '^TIL' |\
    while read -r line
    do 
        # example line after `cut -f 1`
        # TIL - vim man page search for short option                         - 27/Aug/23
        til_title=$( echo "$line" | cut -f 1 |\
            # output example after next line: vim man page search for short option
            cut -d '-' -f 2 |\
            # remove all spaces on left and right
            sed -E 's/^[ ]*//g' | sed 's/[ ]*$//g' |\
            # change space in title to -
            sed 's/ /-/g'
        ) 
        til_date=$(  echo "$line" | cut -f 1 | cut -d '-' -f 3 |\
            # input example for grep: 27/Aug/23
            # grep here is just to remove spaces
            grep -o '\d\d/.../\d\d' | sed 's:/:-:g'
        )
        start_line=$(echo "$line" | cut -f 5 | sed 's/line://g')
        end_line=$(  echo "$line" | cut -f 6 | sed 's/end://g')

        sed_command=$(printf "%s,%sp" $((start_line-1)) $((end_line-1)))
        til_document_name="$HOME/Documents/notes/notes/TIL/$til_date-$til_title.md"

        printf "creating %s\n" "$til_document_name"
        sed -n "$sed_command" $PATH_TO_DEV_NOTES > "$til_document_name" 
    done
