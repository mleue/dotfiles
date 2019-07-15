#!/usr/bin/env bash

# set vim as standard editor
export EDITOR='vim'

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

# make locate work for encrypted home directories
export LOCATE_PATH="$HOME/var/mlocate.db"

# history counts
alias history-counts="history | awk '{print \$2}' | awk 'BEGIN {FS=\"|\"}{print \$1}' | sort | uniq -c | sort -nr | head"

# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# After each command, append to the history file and reread it (gather history from all open terminals)
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# ls, ignore vim undo files
# color fix for ls
alias ls='ls --color=auto'

# some more useful date commands
alias DATE='date +%Y-%m-%d'
alias DATE2='date "+%Y-%m-%d %H:%M"'

# a standard-application file opener alias
alias o='xdg-open'

# enable "clear" via CTRL+L even in vi mode
bind -m vi-insert "\C-l":clear-screen

# an alias command to copy pass passwords to wl-clipboard
alias passc='head -n 1 | tr -t "\n" "\0" | wl-copy'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/michael/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/michael/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/michael/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/michael/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> bash-it initialize >>>
# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
export BASH_IT=~/.bash_it
# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby-python'
export THEME_SHOW_PYTHON=true

# Load Bash It
source "$BASH_IT"/bash_it.sh
# <<< bash-it initialize <<<
