#!/bin/bash
# setting up variables
dotfiles_dir=~/.dotfiles/
dotfiles_dir_backup=~/.dotfiles.bak/
mkdir -p $dotfiles_dir_backup
# list of dotfiles/dirs to symlink
dotfiles=".vimrc .tmux.conf .bashrc .gdbinit .bash_profile .config/sway .config/waybar .config/nvim .config/swappy .xkb"

# for any dotfile, first back it up, then create a new symlink in ~/ to it
for file in $dotfiles; do
	echo "Backing up existing $file into $dotfiles_dir_backup"
    mv ~/$file $dotfiles_dir_backup
    echo "Creating symlink to $file in home directory."
    ln -snf -v $dotfiles_dir$file ~/$file
done
