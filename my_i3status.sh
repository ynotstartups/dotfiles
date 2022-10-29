#!/bin/bash
# shell script to prepend i3status with more stuff

i3status | while :
do
    read line

    # when a field is empty, i3status output 'BATTERY 99% |  | 10/26 09:19'
    # remove the unnecessary "|  |"
    formatted_line=`echo $line | sed 's/ |  | / | /' | sed 's/ | | / | /'`

    # sed to change +19 to 19 and tr to change to uppercase
    weather=`curl -s wttr.in/?format=%C%t | sed 's/\+/ /' | tr a-z A-Z`

    # echo "$weather | $formatted_line" || exit 1
    # don't ever exit with 1, always keep going
    echo "$weather | $formatted_line"
done
