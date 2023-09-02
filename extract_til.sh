#!/bin/bash
cat $HOME/Documents/personal-notes/tags |\
    grep '^TIL' |\
    while read -r line
    do 
        title=$(echo "$line" | cut -d '-' -f 2 | sed -E 's/^[ ]*//g' | sed 's/[ ]*$//g' | sed 's/ /-/g')
        til_date=$(echo "$line" | cut -d '-' -f 3 | grep -o '\d\d/.../\d\d' | sed 's:/:-:g' )
        start_line=$(echo "$line" | grep -Eo 'line:\d+' | sed 's/line://g')
        end_line=$(echo "$line" | grep -Eo 'end:\d+' | sed 's/end://g')

        sed_command=$(printf "%s,%sp" $((start_line-1)) $((end_line-1)))
        til_document_name="$HOME/Documents/notes/notes/TIL/$til_date-$title.md"

        printf "creating %s\n" "$til_document_name"
        sed -n "$sed_command" $HOME/Documents/personal-notes/dev_notes.md > "$til_document_name" 
    done
