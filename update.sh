#!/bin/sh
echo "Copying files.."
cp --backup .vimrc ~
cp --backup .bashrc ~
cp --backup .tmux.conf ~
# Merge gitconfig with current files first 3 lines
mv ~/.gitconfig ~/.gitconfig~
head ~/.gitconfig~ --lines=3 | cat - .gitconfig > ~/.gitconfig
# Copy git template dir
cp --backup --recursive ./.git_template ~
echo "Done!"
exit 0
