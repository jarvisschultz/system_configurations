#!/usr/bin/env bash
if [ $# -eq 0 ]; then
  xdg-open . &> /dev/null
else
  for file in "$@"; do
    xdg-open "$file" &> /dev/null
  done
fi

# #!/bin/bash
# set -euo pipefail; shopt -s failglob # bash strict mode

# max=${max:-10} # Set default maximum if $max is not set
# [[ ${all:-} ]] && max=$# # Set max to all files if $all is non-null

# for file in "${@:1:$max}"; do
#   xdg-open "$file"
# done &>>~/.xsession-errors
