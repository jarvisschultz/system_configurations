#!/bin/bash

out=$(xrandr --current | grep -i " connected")
echo "xrandr output:"
echo "${out}" 
echo
moncount=$(echo "${out}" |wc -l)
echo "Monitor Count = ${moncount}"
echo 

i=0
while IFS= read
do 
    # echo "Reply: ${REPLY}"
    v1=$(echo "${REPLY}" | grep -o -E "[0-9]{3,}x[0-9]{3,}\+[0-9]{1,}")
    # echo "v1: ${v1}"
    widths[$i]=$(echo $v1 |cut -d'x' -f1)
    heights[$i]=$(echo $v1 |cut -d'x' -f2 |cut -d'+' -f1)
    locations[$i]=$(echo $v1 |cut -d'+' -f2)
    echo "Monitor number = $i, w=${widths[i]}, h=${heights[i]}, l=${locations[i]}"
    i=$(($i+1))
done <<<  "${out}"

i=0
while [ ${i} -lt $moncount ]
do
    # echo $i
    quads[$i*3]=$((${locations[i]}))
    quads[$(($i*3+1))]=$((${widths[i]}/2 + ${locations[i]}))
    quads[$(($i*3+2))]=$((${widths[i]} + ${locations[i]}))
    i=$(($i+1))
done
# for i in {0..5}
# do 
#     echo "quad $i = ${quads[i]}"
# done

# figure out where the window is:
xval=$(xwininfo -id $(xdpyinfo | grep focus | \
    grep -E -o 0x[0-9a-f]+) | grep Abs.*X: |grep -o -e "  [0-9].*")
echo "xval = ${xval}"
# now we need to figure out which sector the window is in
i=0
found=0
key=0
while [ ${i} -lt $moncount ]
do
    if (( ( ${xval} >= ${quads[$(($i*3))]} ) && ( ${xval} < ${quads[$(($i*3+1))]} ) ))
    then
 	echo "sector = $(($i*2+1))"
	found=1
	xloc=$((${quads[i*3]}))
	key=$(($i*3))
	echo $xloc
	
	break
    elif (( ( ${xval} >= ${quads[$(($i*3+1))]} ) && ( ${xval} < ${quads[$(($i*3+2))]} ) ))
    then
    	echo "sector = $(($i*2+2))"
    	found=1
	xloc=$((${quads[i*3+1]}))
	key=$(($i*3+1))
	echo $xloc
    	break
    fi	
    i=$(($i+1))
done

if (( $found == 0 ))
then
    echo "Not in a sector!"
    exit 1
fi

wid=$((${quads[$key+1]}-${quads[$key]}))
wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
wmctrl -r :ACTIVE: -e 0,${xloc},0,${wid},-1
wmctrl -r :ACTIVE: -b add,maximized_vert

exit 0
# # define monitor resolutions:
# # Left 
# resolutions=$(xrandr --current |grep -A 4 LVDS |grep \* |grep -o [0-9].*x[0-9].*\ )
# lw=$(echo $resolutions |cut -d'x' -f1)
# lh=$(echo $resolutions |cut -d'x' -f2)
# # Right 
# resolutions=$(xrandr --current |grep -A 4 CRT |grep \* |grep -o [0-9].*x[0-9].*\ )
# rw=$(echo $resolutions |cut -d'x' -f1)
# rh=$(echo $resolutions |cut -d'x' -f2)

# # figure out where the window is:
# xval=$(xwininfo -id $(xdpyinfo | grep focus | \
#     grep -E -o 0x[0-9a-f]+) | grep Abs.*X: |grep -o -e "  [0-9].*")

# # are we on the right monitor?
# if [ $(($xval)) -ge $(($rw-2)) ] 
# then
#     # then let's push to left edge, and maximize height, and set width to be 1/2
#     # the monitor width
#     # echo "On Right Monitor"
#     wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
#     wmctrl -r :ACTIVE: -e 0,$rw,0,$(($rw/2)),-1
#     wmctrl -r :ACTIVE: -b add,maximized_vert
# else
#     # then let's push to left edge, and maximize height, and set width to be 1/2
#     # the monitor width
#     wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
#     wmctrl -r :ACTIVE: -e 0,0,0,$(($lw/2)),-1
#     wmctrl -r :ACTIVE: -b add,maximized_vert
# fi
# exit 0
