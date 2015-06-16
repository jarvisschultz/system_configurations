#!/bin/bash
fn=${HOME}/.environment_dump.txt
printenv -0 > "$fn"
emacsclient -t -n -q -e '(my-update-env "'"$fn"'")' 
# -t ~ override the -c that I have already passed via an alias
# -n ~ don't wait for completion... prevents me from having to close frame that is opened
# -q ~ quiet
# -e ~ eval
