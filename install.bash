#!/bin/bash


##################################################
# bash stuff
ln -svbi $PWD/bashrc.bash $HOME/.bashrc
ln -svbi $PWD/bash_aliases.bash $HOME/.bash_aliases
if [ ! -d $HOME/bin ]
then
    mkdir $HOME/bin
fi
for f in $PWD/my_bash_scripts/*
do
    ln -svbi ${f} $HOME/bin/
done
for f in $PWD/my_display_scripts/*
do
    ln -svbi ${f} $HOME/bin/
done
##################################################


##################################################
# # emacs
ln -svbi $PWD/dotemacs.el $HOME/.emacs
if [ ! -d $HOME/.emacs.d/misc-packages ]
then
    mkdir $HOME/.emacs.d/misc-packages
fi
for f in $PWD/my_emacs_scripts/*
do
    ln -svbi ${f} $HOME/.emacs.d/misc-packages/
done
##################################################


##################################################
# ssh
ln -svbi $PWD/sshpublickey $HOME/.ssh/id_rsa.pub
# screen and tmux
ln -svbi $PWD/screenrc.conf $HOME/.screenrc
ln -svbi $PWD/tmux.conf $HOME/.tmux.conf
# xbindkeys
ln -svbi $PWD/xbindkeysrc $HOME/.xbindkeysrc
# byobu
if [ ! -d $HOME/.byobu ]
then
    mkdir $HOME/.byobu
fi
for f in $PWD/byobu-config/*
do
    ln -svbi ${f} $HOME/.byobu/
done
##################################################
