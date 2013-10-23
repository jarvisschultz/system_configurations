#!/bin/bash

# get connected monitor data:
out=$(xrandr --current | grep -i " connected")
echo "xrandr output:"
echo "${out}" 
echo
moncount=$(echo "${out}" |wc -l)
echo "Monitor Count = ${moncount}"
echo 

# get each monitor's width, height, and location in the virtual desktop:
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

# sort the previous data by location (min to max)
tmp=$(for k in {0..2}
do
    echo "${widths[k]} ${heights[k]} ${locations[k]}"
done | 
sort -n -k3)
widths=($(printf '%s\n' "${tmp[@]}" | cut -d' ' -f1))
heights=($(printf '%s\n' "${tmp[@]}" | cut -d' ' -f2))
locations=($(printf '%s\n' "${tmp[@]}" | cut -d' ' -f3))

# get boundaries of vertically split secors in each monitor 
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
# echo

# figure out where the window is:
# winid=$(xdpyinfo | grep focus |  grep -E -o 0x[0-9a-f]+)
winid=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
echo "winid = ${winid}"
xmin=$(xwininfo -id ${winid}| grep Abs.*X: |grep -o -E "[0-9]{0,}")

echo "xmin = ${xmin}"

# now we need to figure out which sector the window is in, and set values for
# moving it
i=0
found=0
key=0
while [ ${i} -lt $moncount ]
do
    if (( ( ${xmin} >= ${quads[$(($i*3))]} ) && \
	( ${xmin} < ${quads[$(($i*3+1))]} ) ))
    then
 	echo "sector = $(($i*2+1))"
	found=1
	key=$(($i*3)) 
	xloc=$((${quads[key]}))
	err=$((${xmin} - ${quads[$((key))]}))
	echo "err = ${err}"
	if (( $err < 5 ))
	then
	    key=$((key-2)) 
	    if (( $key < 0 ))
	    then
		key=0
	    fi
	    xloc=$((${quads[key]}))
	fi
	echo "Moving to = ${xloc}"
	break
    elif (( ( ${xmin} >= ${quads[$(($i*3+1))]} ) && \
	( ${xmin} < ${quads[$(($i*3+2))]} ) ))
    then
    	echo "sector = $(($i*2+2))"
    	found=1
	key=$(($i*3+1))
	xloc=$((${quads[key]}))
	err=$((${xmin} - ${quads[$((key))]}))
	echo "err = ${err}"
	if (( $err < 5 ))
	then
	    key=$((key-1)) 
	    if (( $key < 0 ))
	    then
		key=0
	    fi
	    xloc=$((${quads[key]}))
	fi
	echo "Moving to = ${xloc}"
    	break
    fi	
    i=$(($i+1))
done

# quit if we didn't accurately find the sector
if (( $found == 0 ))
then
    echo "Not in a sector!"
    exit 1
fi

# move window
wid=$((${quads[$key+1]}-${quads[$key]}))
wmctrl -i -r ${winid} -b remove,maximized_horz
wmctrl -i -r ${winid} -e 0,${xloc},0,${wid},-1
wmctrl -i -r ${winid} -b add,maximized_vert

exit 0
