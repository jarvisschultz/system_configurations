function rmhist() {
    start=$1
    end=$2
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
