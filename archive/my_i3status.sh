#!/bin/bash
# shell script to prepend i3status with more stuff

i3status | while :
do
    read line

    # when a field is empty, i3status output 'BATTERY 99% |  | 10/26 09:19'
    # remove the unnecessary "|  |"
    formatted_line=`echo $line | sed 's/ |  | / | /' | sed 's/ | | / | /'`

    echo "$formatted_line"
done
