#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

# list of files/folders to symlink in homedir
files="bashrc vimrc vim inputrc ackrc gitconfig gitignore tmux.conf"

##########

# get vundle
mkdir -p ~/dotfiles/vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/dotfiles/vim/bundle/Vundle.vim

# create dotfiles_old in homedir
mkdir -p $olddir

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from
# the homedir to any files in the ~/dotfiles directory specified in $files
echo "creating symlinks..."
for file in $files; do
    if [ -e ~/.$file ]; then
        echo "found existing dotfile $file. moving to $olddir"
        mv "$HOME/.$file" "$olddir"
    fi

    echo "Creating symlink to $file in home directory."
    ln -s "$dir/$file" "$HOME/.$file"
done

# if we didn't move anything $olddir will be empty and we might as well delete it to reduce clutter
if [ "$(ls -A $olddir)" ]; then
    echo "Some old dotfiles were found and moved to $olddir"
else
    echo "Nothing was moved. Deleting $olddir.."
    rmdir $olddir
fi

echo "Installing Vim plugins..."
vim +PluginInstall +qall
