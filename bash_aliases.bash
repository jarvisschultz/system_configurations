function rmhist() {
    start=$1
    end=$2
    if [[ -z "$start" || -z "$end" ]];
    then
	echo "Bad args!"
	echo "Usage: rmhist start stop"
	return
    fi
    count=$(( end - start ))
    while [ $count -ge 0 ] ; do
        history -d $start
        ((count--))
    done
}

function cs () {
    cd "$1";
    ls 
}

function roscs(){
    roscd "$1";
    ls
}

function rcon(){
    arg=$1
    fname="/home/$USER/.rosdefault_core"
    if [ -n "$arg" ] 
    then
    	## if we have an argument, let's send it to the config file
	echo -n "$arg" > "$fname"
    fi
    ## let's read from the config file
    if [ -f $fname ]
    then
        core=`cat ~/.rosdefault_core`
    else
	core="localhost"
    fi
    export ROS_MASTER_URI=http://$core:11311/;
    echo "ROS_MASTER_URI = ${ROS_MASTER_URI}"
    if [[ $core == *localhost* ]]
    then
	unset ROS_IP
	echo "unset ROS_IP"
    else
	ip=$(ifconfig |sed -n '2 p' |awk '{print $2}' |cut -d \: -f 2)
	export ROS_IP=$ip
	echo "ROS_IP=${ip}"
    fi
}

function rversion(){
    arg=$1
    fname="/home/$USER/.rosversiondefault"
    if [ -n "$arg" ]
    then
	# if we have an argument, send it to the config file
	echo -n "$arg" > "$fname"
    fi
    # read default version from file
    if [ -f $fname ]
    then
       ver=$(cat $fname)
    else
	echo "Could not determine ROS version"
	echo "Please provide argument"
	return 1
    fi
    if [[ $ver == *fuerte* ]]
    then
	des1="hydro"
	des2="groovy"
	unset $(env |awk -F "=" '{print $1}' |grep "ROS\|CMAKE_PREFIX_PATH" |xargs)
	source ~/.bashrc
    elif [[ $ver == *groovy* ]]
    then
	des1="fuerte"
	des2="hydro"
	unset $(env |awk -F "=" '{print $1}' |grep "ROS\|CMAKE_PREFIX_PATH" |xargs)
	source ~/groovyws/devel/setup.bash
    elif [[ $ver == *hydro* ]]
    then
	des1="fuerte"
	des2="groovy"
	unset $(env |awk -F "=" '{print $1}' |grep "ROS\|CMAKE_PREFIX_PATH" |xargs)
	source ~/hydrows/devel/setup.bash
    else
	echo "Unrecognized version!"
	return 1
    fi
    # check that PYTHONPATH isn't containing any old stuff:
    arrIN=(${PYTHONPATH//:/ })
    strOut=""
    for dir in "${arrIN[@]}"
    do
	if [[ $dir != *$des1* && $dir != *$des2* ]]
	then
	    if [ -z "${strOut}" ]
	    then
		strOut="${dir}"
	    else
		strOut="${strOut}:${dir}"
	    fi
	fi
    done
    export PYTHONPATH="${strOut}"
    echo "Current ROS vars:"
    env |grep --color=always "ROS\|CMAKE_PREFIX_PATH\|PYTHONPATH" |sort
}
  
alias eps2pgf='java -jar /home/jarvis/src/eps2pgf/eps2pgf.jar'
alias go='xdg-open'
alias ur='sudo service udev reload'
##alias utags='find . -regex ".*\.[cChH]\(pp\)?\|.*\.py" -print | cut -c3- | etags -'
alias tt='nautilus . &'
alias E='$EDITOR'
alias reload_serial='sudo rmmod ftdi_sio && sudo modprobe ftdi_sio'
alias kagent='kill -9 $SSH_AGENT_PID'
alias uncolor='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias emacsclient="emacsclient -c "
alias ga='gitk --all &'
alias battstate='upower -i $(upower -e |grep batt) |grep --color=never -E "state|to\ full|percentage|to\ empty"'

# ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
