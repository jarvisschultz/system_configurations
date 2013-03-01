#!/bin/bash

# is extra monitor connected?
MonitorStatus
status=$?
if [[ $status -eq 0 ]] 
then
    exit 0
fi

# define monitor resolutions:
# Left 
resolutions=$(xrandr --current |grep -A 4 LVDS |grep \* |grep -o [0-9].*x[0-9].*\ )
lw=$(echo $resolutions |cut -d'x' -f1)
lh=$(echo $resolutions |cut -d'x' -f2)
# Right 
resolutions=$(xrandr --current |grep -A 4 CRT |grep \* |grep -o [0-9].*x[0-9].*\ )
rw=$(echo $resolutions |cut -d'x' -f1)
rh=$(echo $resolutions |cut -d'x' -f2)

# echo $lw, $lh, $rw, $rh
# figure out where the window is:
xval=$(xwininfo -id $(xdpyinfo | grep focus | \
    grep -E -o 0x[0-9a-f]+) | grep Abs.*X: |grep -o -e "  [0-9].*")
# echo $xval

# are we on the right monitor?
if [ $(($xval)) -ge $(($rw-2)) ] 
then
    # then let's push to left edge, and maximize height, and set width to be 1/2
    # the monitor width
    # echo "On Right Monitor"
    wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
    wmctrl -r :ACTIVE: -e 0,$rw,0,$(($rw/2)),-1
    wmctrl -r :ACTIVE: -b add,maximized_vert
else
    # then let's push to left edge, and maximize height, and set width to be 1/2
    # the monitor width
    wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
    wmctrl -r :ACTIVE: -e 0,0,0,$(($lw/2)),-1
    wmctrl -r :ACTIVE: -b add,maximized_vert
fi
exit 0
