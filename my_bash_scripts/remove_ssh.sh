#!/bin/bash

dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" | ( 
    while true; 
    do read X; 
	if echo $X | grep "boolean true" &> /dev/null; 
	then 
	    echo "SCREEN_LOCKED";
	    for sshenv in /tmp/keyring*;
	    do 
		SSH_AUTH_SOCK=${sshenv}/ssh
		ssh-add -D
	    done
	elif echo $X | grep "boolean false" &> /dev/null; 
	then 
	    echo "SCREEN_UNLOCKED"; 
	fi 
    done )

echo "Quitting all"
exit 0
