#!/bin/bash
fn=tempfile
printenv -0 > "$fn" 
emacsclient -t -n -q -e '(my-update-env "'"$fn"'")' 
