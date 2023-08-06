#!/bin/bash
# https://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac


