#!/usr/bin/env bash

# TODO: do we need bash-it?
### >>> bash-it initialize >>>
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

### GENERAL SETTINGS
# set vim as standard editor
export EDITOR='vim'
# vi mode in bash [ESC to enter]
set -o vi
# make locate work for encrypted home directories
export LOCATE_PATH="$HOME/var/mlocate.db"
# enable "clear" via CTRL+L even in vi mode
bind -m vi-insert "\C-l":clear-screen

### HISTORY
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# After each command, append to the history file and reread it (gather history from all open terminals)
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# back search in CTRL+R using CTRL+S (in case you jumped over your target)
stty -ixon
# don't keep duplicate history entries
export HISTCONTROL=ignoreboth:erasedups
# search for commands that start off with the same characters already typed
if [ -t 1 ]
then
  bind '"\e[A":history-search-backward'
  bind '"\e[B":history-search-forward'
fi
# history counts
alias history-counts="history | awk '{print \$2}' | awk 'BEGIN {FS=\"|\"}{print \$1}' | sort | uniq -c | sort -nr | head"

### ALIASES for standard commands
# ls, ignore vim undo files, color fix for ls
alias ls='ls --color=auto --ignore=__pycache__'
# always ask before deleting
alias rm='rm -i'
alias mv='mv -i'

### NOTES
# quickly jot down log notes with a date attached
alias "log"="echo `date -I` $1 >> ~/notes/log.md"
alias "logs"="tail ~/notes/log.md"
alias "kb"="cd ~/notes && vim todo.md"

### PYENV
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

### WAYLAND
export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway

### FZF
if type rg &> /dev/null; then
	# fzf searches for candidate files using rg
	export FZF_DEFAULT_COMMAND='rg --files'
	# allow to select multiple entries via tab complete
	export FZF_DEFAULT_OPTS='-m'
fi
