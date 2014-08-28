#!/bin/bash

dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" | ( 
    while true; 
    do read X; 
	if echo $X | grep "boolean true" &> /dev/null; 
	then 
	    echo "SCREEN_LOCKED";
	    for dir in /run/user/*;
	    do
		echo "Testing dir = $dir"
		if [ -O $dir ]
		then
		    echo "$dir Owned by me"
		    for sshenv in $dir/keyring*;
		    do 
			echo "Running remove for $sshenv"
			SSH_AUTH_SOCK=${sshenv}/ssh
			ssh-add -D
		    done
		fi 
	    done
	elif echo $X | grep "boolean false" &> /dev/null; 
	then 
	    echo "SCREEN_UNLOCKED"; 
	fi 
    done )

echo "Quitting all"
exit 0
