#!/bin/bash

YCM_CONFIG_LOCATION="/home/jarvis/src/system_configurations/ROS_ycm_extra_conf.py"

echo "Setting up current directory to use YCMD!"

# let's check if we are currently in a ROS workspace:
SETUP=0
if [ ! -d "$(pwd)/.catkin_tools" ] && [ ! -e "$(pwd)/.catkin_workspace" ] 
then
	echo "You are not in a ROS workspace!"
	read -n 1 -p "Do you still want to setup $(pwd) as a YCMD directory [y/n]? " y
    [ "$y" == "y" ] || [ "$y" == "Y" ] && SETUP=1
	echo -e "\n"
else
	SETUP=1
fi

if [ $SETUP -eq 1 ]
then
	ln -svbi ${YCM_CONFIG_LOCATION} .ycm_extra_conf.py
fi
