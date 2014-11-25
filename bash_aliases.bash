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
		core="localhost"
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


rsource(){
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
			exit 1
		fi
	else
		if [ -f ${fname} ]
		then
			rm ${fname}
		fi
		for var in "$@"
		do
			line=$(readlink -m ${var})
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
		des3="indigo"
		unset $(env |awk -F "=" '{print $1}' |grep "ROS\|CMAKE_PREFIX_PATH" |xargs)
		source ~/.bashrc
    elif [[ $ver == *groovy* ]]
    then
		des1="fuerte"
		des2="hydro"
		des3="indigo"
		unset $(env |awk -F "=" '{print $1}' |grep "ROS\|CMAKE_PREFIX_PATH" |xargs)
		source ~/groovyws/devel/setup.bash
    elif [[ $ver == *hydro* ]]
    then
		des1="fuerte"
		des2="groovy"
		des3="indigo"
		unset $(env |awk -F "=" '{print $1}' |grep "ROS\|CMAKE_PREFIX_PATH" |xargs)
		source ~/hydrows/devel/setup.bash
    elif [[ $ver == *indigo* ]]
    then
		des1="fuerte"
		des2="hydro"
		des3="groovy"
		unset $(env |awk -F "=" '{print $1}' |grep "ROS\|CMAKE_PREFIX_PATH" |xargs)
		source ~/indigows/devel/setup.bash
    else
		echo "Unrecognized version!"
		return 1
    fi
    # check that PYTHONPATH isn't containing any old stuff:
    arrIN=(${PYTHONPATH//:/ })
    strOut=""
    for dir in "${arrIN[@]}"
    do
		if [[ $dir != *$des1* && $dir != *$des2*  && $dir != *$des3* ]]
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

function girelease() {
	name=$(basename $(git rev-parse --show-toplevel))
	echo "Building release for ${name} at HEAD"
	git archive master --prefix="${name}/" | bzip2 >${name}-$(git rev-parse HEAD | cut -c -8).tar.bz2
}


alias eps2pgf='java -jar /home/jarvis/src/eps2pgf/eps2pgf.jar'
alias go='xdg-open'
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
alias xssh='ssh -c arcfour,blowfish-cbc -XC'


##########################
# old functions/ aliases #
##########################
# alias utags='find . -regex ".*\.[cChH]\(pp\)?\|.*\.py" -print | cut -c3- | etags -'
# ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
