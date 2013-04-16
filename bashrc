# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# make nano automatically open with sudo when necessary
function nano() {
    nano=`which nano`;
    if ([ -e "$1" ] && ! [ -w "$1" ]) || ( ! [ -e "$1" ] && ! [ -w "`dirname $1`" ]);
    then
        read -n 1 -p "$1 is not editable by you. sudo [y/n]? " y
        [ "$y" == "y" ] || [ "$y" == "Y" ] && echo -e "\n" && sudo $nano $@
    else
        $nano $@
    fi
}

# add 256 color support for the terminal:
# export TERM=xterm-256color 
## note that this causes problems with emacs when it tries to autoload
## color themes.

## python config
export PYTHONPATH=/usr/local/lib:/usr/lib/python2.7/config:/usr/local/lib/python2.7/site-packages
## OpenCV
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib/python2.7/config:/home/jarvis/OpenCV-2.2.0/release/lib
## ROS
source /opt/ros/fuerte/setup.bash
export ROS_PACKAGE_PATH=/home/jarvis/ros/stacks:/home/jarvis/ros/packages:/opt/ros/fuerte
# Set EMACS as default editor:
export EDITOR='emacsclient -t'
# Add Eagle, and sbin:
PATH=$HOME/bin:$HOME/eagle-5.11.0/bin:$PATH
# Add MATLAB_JAVA Environment Variable:
export MATLAB_JAVA=/usr/lib/jvm/java-6-openjdk-amd64/jre/
# Add processing apps to PATH
export PATH=/home/jarvis/Dropbox/Processing/nuscope/application.linux64:$PATH
# fix rviz flickering
unset LIBGL_ALWAYS_INDIRECT
# add microchip compilers to the path
export PATH=$PATH:/opt/microchip/xc32/v1.11/bin
# add android tools to path:
# export PATH=$PATH:/home/jarvis/src/android/android-sdk-linux/tools

# add syntax color and piping to less
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -RXF ' # raw control chars, turn off screen resetting, auto exit if less than one screen
export CLICOLOR_FORCE="true"
alias lsc='ls --color=always'
alias grepc='grep --color=always'
    
# disable XON/XOFF flow control for the connection to stty
stty -ixon

# Add settings for emacs client:
export ALTERNATE_EDITOR=""

# set default gpg key
export GPGKEY=9BBA54C6

# add lib64 for phantom omni
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64

# add self-built texlive 2012 to PATH
export PATH=/usr/local/texlive/2012/bin/x86_64-linux:$PATH
