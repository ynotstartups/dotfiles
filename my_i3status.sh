#!/bin/sh
# shell script to prepend i3status with more stuff

i3status | while :
do
    read line
    weather=`curl -s wttr.in/?format=3 | cut -d ":" -f 2`
    # weather='test'
    echo "$weather | $line" || exit 1
done
