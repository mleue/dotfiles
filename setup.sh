#!/bin/bash
# sets up the dotfiles and environments for vim, tmux and bash

# setting up variables
dotfiles_dir=~/.dotfiles/             	# dotfiles directory
backup_dotfiles_dir=~/.dotfiles_backup/ # dotfiles backup directory
backup_config_dir=~/.config_backup/ 	# config dirs backup directory
dotfiles=".vimrc .tmux.conf .bashrc .gdbinit .bash_profile"  	# list of files to symlink
configdirs="sway waybar nvim"  			# list of .config dirs to symlink

# create backup dotfiles dir in homedir
echo "Creating $backup_dotfiles_dir for backing up any existing dotfiles in ~"
mkdir -p $backup_dotfiles_dir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dotfiles_dir directory"
cd $dotfiles_dir
echo "...done"

# for any dotfile, first back it up, then create a new symlink in ~ to the dotfile
for file in $dotfiles; do
	echo "Backing up the existing $file into $backup_dotfiles_dir."
    mv ~/$file $backup_dotfiles_dir
    echo "Creating symlink to $file in home directory."
    ln -sf -v $dotfiles_dir$file ~/$file
done

# for any .config dir, first back it up, then symlink to it
for dir in $configdirs; do
	echo "Backing up the existing $dir into $backup_config_dir."
    mv ~/.config/$dir $backup_dotfiles_dir
    echo "Creating symlink to $dir in home .config directory."
    ln -snf -v $dotfiles_dir.config/$dir ~/.config/$dir
done

# symlink ftplugin (filetype plugin) files for vim
mkdir -p ~/.vim/ftplugin
for file in $dotfiles_dir/.ftplugin/*; do
	filename=$(basename "$file")
	echo "Creating symlink to $filename in ftplugin directory."
	ln -sf -v $dotfiles_dir/.ftplugin/$filename ~/.vim/ftplugin/$filename
done

# Update bash-it if it's already installed or download it if it's not
if [ -d $HOME/.bash_it ]; then
  cd $HOME/.bash_it
  git pull
else
  git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it
fi
