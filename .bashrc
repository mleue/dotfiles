#!/usr/bin/env bash
## GENERAL SETTINGS
# define some colors
red="\[\e[0;31m\]"
green="\[\e[0;32m\]"
yellow="\[\e[0;33m\]"
blue="\[\e[0;34m\]"
purple="\[\e[0;35m\]"
cyan="\[\e[0;36m\]"
reset_color="\[\e[39m\]"

# set PS1
name="${purple}\u@\h${reset_color}"
location="${green}\w${reset_color}"
py_version="$(python --version 2>&1 | awk 'NR==1{print $2;}')"
pyenv_version="$(pyenv version-name)"
python_info="${yellow}[${pyenv_version}-${py_version}]${reset_color}"
source /usr/share/git/completion/git-prompt.sh
# determine whether there are uncommited changes (red color) or not (green color)
get_git_status_color() {
  if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
    echo -e "${red}"  # Red color escape code
  else
    echo -e "${green}"  # Green color escape code
  fi
}
update_prompt() {
  git_ps1="$(get_git_status_color)$(__git_ps1 ' (%s)')${reset_color}"
  PS1="${python_info} ${name} ${location}${git_ps1}\n\$ "
}
export PROMPT_COMMAND="update_prompt"

# set nvim as standard editor
export EDITOR='nvim'
# vi mode in bash [ESC to enter]
set -o vi
# make locate work for encrypted home directories
export LOCATE_PATH="$HOME/var/mlocate.db"
# enable "clear" via CTRL+L even in vi mode
bind -m vi-insert "\C-l":clear-screen

## HISTORY
export HISTCONTROL=ignoredups:erasedups # erase duplicates
export HISTSIZE=100000
export HISTFILESIZE=100000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# After each command, append to the history file and reread it (gather history from all open terminals)
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# back search in CTRL+R using CTRL+S (in case you jumped over your target)
stty -ixon
# search for commands that start off with the same characters already typed
if [ -t 1 ]
then
  bind '"\e[A":history-search-backward'
  bind '"\e[B":history-search-forward'
fi

## ALIASES for standard commands
# history counts
alias history-counts="history | awk '{print \$2}' | awk 'BEGIN {FS=\"|\"}{print \$1}' | sort | uniq -c | sort -nr | head"
# ls, ignore certain patterns,  color fix for ls
alias ls='ls --color=auto --ignore=__pycache__'
# always ask before deleting
alias rm='rm -i'
alias mv='mv -i'
# quickly jot down log notes with a date attached
alias "log"="echo `date -I` $1 >> ~/notes/log.md"
alias "logs"="tail ~/notes/log.md"
# knowledgebase
alias "kb"="cd ~/notes && nvim todo.md"

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
