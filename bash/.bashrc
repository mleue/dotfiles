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

## set PS1
name="${purple}\u@\h${reset_color}"
location="${green}\w${reset_color}"
# determine whether there are uncommited changes (red color) or not (green color)
get_git_status_color() {
  if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
    echo -e "${red}"  # Red color escape code
  else
    echo -e "${green}"  # Green color escape code
  fi
}
# dynamic PS1 update
update_prompt() {
  # Default values
  pyenv_version="no pyenv"
  git_ps1="no git-prompt.sh"

  # Check if pyenv command is available
  command -v pyenv >/dev/null 2>&1 && {
      pyenv_version="$(pyenv version-name)"
  }

  # Check if git-prompt.sh exists
  if [ -f "/usr/share/git/completion/git-prompt.sh" ]; then
      source "/usr/share/git/completion/git-prompt.sh"
      git_ps1="$(get_git_status_color)$(__git_ps1 ' (%s)')${reset_color}"
  fi

  py_version="$(python --version 2>/dev/null | awk 'NR==1{print $2;}')"
  python_info="${yellow}[${pyenv_version}-${py_version}]${reset_color}"
  venv_name=$(basename "${VIRTUAL_ENV}")
  PS1="(${venv_name}) ${python_info} ${name} ${location}${git_ps1}\n\$ "
}
# ensures that the prompt is updated after every command you issue
# (e.g. so that it correctly updates after cd'ing into a git repo)
export PROMPT_COMMAND="update_prompt"

## SETTINGS
# set nvim as standard editor
export EDITOR='nvim'
# make locate work for encrypted home directories
export LOCATE_PATH="$HOME/var/mlocate.db"

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
# ls, ignore certain patterns,  color fix for ls
alias ls='ls --color=auto --ignore=__pycache__'
# always ask before deleting
alias rm='rm -i'
alias mv='mv -i'

## CUSTOM COMMANDS
# knowledgebase
alias "kb"="cd ~/notes && nvim todo.md"
# history counts
alias history-counts="history | awk '{print \$2}' | awk 'BEGIN {FS=\"|\"}{print \$1}' | sort | uniq -c | sort -nr | head"
# quickly jot down log notes with a date attached
alias "log"="echo `date -I` $1 >> ~/notes/log.md"
alias "logs"="tail ~/notes/log.md"

### PYENV
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

## WAYLAND
export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway

## FZF
if type rg &> /dev/null; then
	# fzf searches for candidate files using rg
	export FZF_DEFAULT_COMMAND='rg --files'
	# allow to select multiple entries via tab complete
	export FZF_DEFAULT_OPTS='-m'
fi

## CUSTOM BASH FUNCTIONS
if [ -f ~/.bash_functions ]; then
   source ~/.bash_functions
fi
## CUSTOM SCRIPTS
export PATH="$HOME/.local/bin:$PATH"
