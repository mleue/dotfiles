#!/usr/bin/env bash

# override snap command
# function snap() { echo "We don't like snaps. :)"; }

# path to anaconda
export PATH=~/anaconda3/bin:$PATH

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby-python'
export THEME_SHOW_PYTHON=true

# Path to the bash it configuration
export BASH_IT=~/.bash_it

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Load Bash It
source "$BASH_IT"/bash_it.sh

# vi mode in bash [ESC to enter]
set -o vi

# back search in CTRL+R using CTRL+S (in case you jumped over your target)
stty -ixon

# don't keep duplicate history entries
export HISTCONTROL=ignoreboth:erasedups

# piping to and from system clipboard
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# search for commands that start off with the same characters already typed
if [ -t 1 ]
then
  bind '"\e[A":history-search-backward'
  bind '"\e[B":history-search-forward'
fi

# always ask before deleting
alias rm='rm -i'

# cli octave is the standard
alias octave='octave --no-gui'

# lock the rfkill unblock command
alias 'rfkill'='echo please use rfkillb/rfkillu to block/unblock'
alias 'rfkillb'='/usr/sbin/rfkill block wlan'
alias 'rfkilll'='/usr/sbin/rfkill list'
alias 'rfkillu'='comlock && /usr/sbin/rfkill unblock all'

# make locate work for encrypted home directories
export LOCATE_PATH="$HOME/var/mlocate.db"

# history counts
alias history-counts="history | awk '{print \$2}' | awk 'BEGIN {FS=\"|\"}{print \$1}' | sort | uniq -c | sort -nr | head"

# gather history from all open terminals, don't silo it

# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# ls, ignore vim undo files
# color fix for ls
alias ls='ls --color=auto -I ".*.un~"'

# some more useful date commands
alias DATE='date +%Y-%m-%d'
alias DATE2='date +%Y-%m-%d %H:%M'
