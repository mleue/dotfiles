#!/usr/bin/env bash

# template
custom_command() {
    # show a help text
    if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        echo "Usage: custom_command [URL]"
        echo "A custom command that does something."
        return 0
    fi
    # way to provide default arguments if they are not set
    local arg="${1:-DEFAULT_VALUE}" # Replace DEFAULT_VALUE with your actual default, if needed.
    echo "The argument was $arg"
}

ytmusicdl() {
    if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        echo "Usage: ytmusicdl [URL/ID]"
        echo "Download music from YouTube. Works both for single videos and playlists."
        return 0
    fi
    # yt-dlp -f bestaudio/best --extract-audio --audio-format mp3 -o "%(playlist_index&{} - |)s%(title)s.%(ext)s" "$1"
    yt-dlp -f bestaudio/best --extract-audio --audio-format mp3 -o "%(playlist_index&{:02d} - |)s%(title)s.%(ext)s" "$1"
}

count_files_recursively() {
  for dir in */; do 
    count=$(find "$dir" -type f | wc -l)
    echo "$count $dir"
  done | sort -nr
}

create_env() {
    # show help text
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        echo "Usage: create_env"
        echo "Create a Python virtual environment for the current directory."
        echo "Environment will be stored in ~/.cache/python_envs/"
        return 0
    fi
    
    local env_dir="$HOME/.cache/python_envs"
    local current_dir=$(basename "$PWD")
    local env_hash_file="./.env_hash"
    
    # Create the cache directory if it doesn't exist
    mkdir -p "$env_dir"
    
    # Check if hash already exists
    if [[ -f "$env_hash_file" ]]; then
        local hash=$(cat "$env_hash_file")
        echo "Using existing environment hash: $hash"
    else
        # Generate hash based on current directory path
        local hash=$(echo "$PWD" | sha256sum | cut -d' ' -f1 | head -c 8)
        echo "$hash" > "$env_hash_file"
        echo "Generated new environment hash: $hash"
    fi
    
    local venv_path="${env_dir}/${current_dir}_${hash}"
    
    if [[ -d "$venv_path" ]]; then
        echo "Virtual environment already exists at: $venv_path"
        echo "Use 'activate_env' to activate it."
        return 0
    fi
    
    echo "Creating virtual environment at: $venv_path"
    python -m venv "$venv_path"
    
    if [[ $? -eq 0 ]]; then
        echo "Virtual environment created successfully!"
        echo "Use 'activate_env' to activate it."
    else
        echo "Failed to create virtual environment."
        return 1
    fi
}

## ALIASES for standard commands
alias ls='ls --color=auto --ignore=__pycache__' # color and ignore __pycache__ directories
alias rm='rm -i' # always prompt before removing
alias mv='mv -i' # always prompt before moving onto something else

# knowledgebase
alias kb="cd ~/notes && nvim todo.md"
# history counts
alias history_counts="history | awk '{print \$2}' | awk 'BEGIN {FS=\"|\"}{print \$1}' | sort | uniq -c | sort -nr | head"
# activating python env
alias activate_env='source ~/.cache/python_envs/tmp_$(cat .env_hash)/bin/activate'


print_custom_functions() {
    echo "Available custom functions:"
    echo "custom_command - A custom command that does something."
    echo "ytmusicdl - Download music from YouTube. Works both for single videos and playlists."
    echo "count_files_recursively - Count files in each subdirectory and sort them by count."
    echo "create_env - Create a Python virtual environment for the current directory."
    echo "kb - open knowledgebase"
    echo "history_counts - Show the most frequently used commands in history."
    echo "activate_env - Activate the Python virtual environment for the current directory."
    # Add additional custom functions below with a brief description.
}
