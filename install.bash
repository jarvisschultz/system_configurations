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
    mkdir -p $HOME/.emacs.d/misc-packages
fi
for f in $PWD/my_emacs_scripts/*
do
    ln -svbi ${f} $HOME/.emacs.d/misc-packages/
done
##################################################


##################################################
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
# global .gitignore
ln -svbi $PWD/globalgitignore.conf $HOME/.gitignore
# global .gitconfig
if [ -f $HOME/.gitconfig ]
then
	echo -n "Do you want to add custom Git commands to your Git config? (y/n)? "
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty $old_stty_cfg
	if echo "$answer" | grep -iq "^y" ;then
		echo "Answered yes!"
		echo "" >> $HOME/.gitconfig
		echo "[include]" >> $HOME/.gitconfig
		echo "	path = ~/.gitcustomconfig" >> $HOME/.gitconfig
	else
		echo "Answered no!"
	fi
fi
ln -svbi $PWD/gitconfig.conf $HOME/.gitcustomconfig
##################################################


##################################################
# latex stuff
ln -svbi $PWD/latexmkrc $HOME/.latexmkrc
##################################################


##################################################
# FZF stuff
ln -svbi $PWD/fzf.bash $HOME/.fzf.bash
##################################################
