#!/bin/bash

# first thing we do is update the window order
windows=$(xprop -root | grep _NET_CLIENT_LIST_STACKING\(WINDOW\) | awk -F "# " '{print $2}')
echo  $windows
# get an array of windows:
IFS=', ' read -a winarr <<< "$windows"
num=${#winarr[@]}
echo "len(winarray) = $num"
# get current window:
wcurr=$(printf "0x%x" $(xdotool getactivewindow))
echo "current = ${wcurr}"

# now iterate through all windows, and find the one in the stack that matches
i=0
while [[ ${i} -lt ${num} ]]
do
    echo "${i}, ${winarr[i]}, ${wcurr}"
    if [[ ${winarr[i]} == ${wcurr} ]]
    then
	echo "Match!"
	break
    fi
    i=$(($i+1))
done

# now, activate the next window
dtop=$(xdotool get_desktop)
j=0
for j in {1..11}
do
    key=$(($(($i+$j))%${num}))
    wdesired=$(printf "%d" ${winarr[key]})
    ddesk=$(xdotool get_desktop_for_window ${wdesired})
    if [[ ${dtop} == ${ddesk} ]]
    then
	echo "Matched desktop!"
	break
    fi
done
out=$(xdotool windowactivate $wdesired)

