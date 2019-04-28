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
    fname="${HOME}/.rosdefault_core"
	: ${ROS_HOSTNAME:=""}
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
		# core="localhost"
		echo "No args and ${fname} not found"
		return 1
    fi
    export ROS_MASTER_URI=http://$core:11311/;
    if [[ $core == *localhost* ]]
    then
		unset ROS_IP
		echo "unset ROS_IP"
	elif [[ -z $ROS_HOSTNAME ]]
	then
		echo "ROS_HOSTNAME not set, trying to set ROS_IP"
		ip=$(ifconfig |sed -n '2 p' |awk '{print $2}' |cut -d \: -f 2)
		export ROS_IP=$ip
	fi
	echo "ROS_MASTER_URI = ${ROS_MASTER_URI}"
	echo "ROS_IP = ${ROS_IP}"
	echo "ROS_HOSTNAME = ${ROS_HOSTNAME}"
}

function abspath () { case "$1" in /*)printf "%s\n" "$1";; *)printf "%s\n" "$PWD/$1";; esac; }

function rsource(){
	# If you pass args to this function it adds them to a list of files to be
	# sourced in the home dir. If you pass no args, it simply sources that file.
	fname="${HOME}/.ros_source"
	if [ $# -eq 0 ]
	then
		# we have no args!
		if [ -f ${fname} ]
		then
			echo "sourcing file ${fname}"
			source $fname
		else
			echo "${fname} not found!"
			return 1
		fi
	else
		if [ -f ${fname} ]
		then
			rm ${fname}
		fi
		for var in "$@"
		do
			line=$(abspath ${var})
			echo "source ${line}" >> ${fname}
			echo "sourcing ${line}"
			source ${line}
		done
	fi
}



function rosenv_clear(){
    # clear all ROS environment variables:
    unset $(env |awk -F "=" '{print $1}' |grep "ROS\|CMAKE_PREFIX_PATH\|PYTHONPATH" |xargs)
    if [ -z ${DEFAULT_PYTHON+x} ]; then
		echo "[WARN] Unable to set PYTHONPATH"
    else
		export PYTHONPATH=$DEFAULT_PYTHON
    fi
}


function rosenv_set(){
    # write all ROS environment variables into a file
    arg=$1
    if [ -n "$arg" ]; then
		FILE=$1
    else
		FILE="${HOME}/.ros_environment"
    fi
    if [ -f $FILE ]; then
    	rm $FILE
    fi
    # get the current ros environment variables:
    VARS=$(env |awk -F "=" '{print $1}' |grep "ROS\|CMAKE_PREFIX_PATH\|PYTHONPATH" |xargs)
    arrIN=(${VARS// / })
    for var in "${arrIN[@]}"
    do
    	val=$(env |grep ${var} |awk -F "=" '{print $2}')
    	echo "export $var=$val" 2>&1 |tee -a ${FILE}
    done
}


function rosenv_load(){
    # load all ROS environment variables from a file
    arg=$1
    if [ -n "$arg" ]; then
		FILE=$1
    else
		FILE="${HOME}/.ros_environment"
    fi
    if [ -f "$FILE" ]; then
		source $FILE
    fi
    echo "Current ROS vars:"
    env |grep --color=always "ROS\|CMAKE_PREFIX_PATH\|PYTHONPATH" |sort
}

function girelease() {
	name=$(basename $(git rev-parse --show-toplevel))
	echo "Building release for ${name} at HEAD"
	git archive master --prefix="${name}/" | bzip2 >${name}-$(git rev-parse HEAD | cut -c -8).tar.bz2
}


function tmux_exec_all() {
  for _window in $(tmux list-windows -F '#I'); do
    for _pane in $(tmux list-panes -t ${_window} -F '#P'); do
      tmux send-keys -t ${_window}.${_pane} "$@" Enter
    done
  done
}


alias eps2pgf='java -jar /home/jarvis/src/eps2pgf/eps2pgf.jar'
alias go='my-xdg-open.sh'
alias ur='sudo service udev reload'
alias tt='nautilus . &'
alias E='$EDITOR'
alias reload_serial='sudo rmmod ftdi_sio && sudo modprobe ftdi_sio'
alias kagent='kill -9 $SSH_AGENT_PID'
alias uncolor='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias emacsclient="emacsclient -c "
alias ga='gitk --all &'
alias battstate='upower -i $(upower -e |grep batt) |grep --color=never -E "state|to\ full|percentage|to\ empty"'
alias rget='env |grep --color=always "ROS\|CMAKE_PREFIX_PATH\|PYTHONPATH" |sort'
alias xssh='ssh -XC'
alias fixterm='echo -e "\033c"'
alias catkin_export_make='catkin_make --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias catkin_export_config='catkin config --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias resource_tmux="tmux_exec_all 'source ~/.bashrc'"
alias qtdesigner5="qtchooser -run-tool=designer -qt=5"
alias qtdesigner4="qtchooser -run-tool=designer -qt=4"

##########################
# old functions/ aliases #
##########################
# alias utags='find . -regex ".*\.[cChH]\(pp\)?\|.*\.py" -print | cut -c3- | etags -'
# ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
