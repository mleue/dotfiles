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

print_custom_functions() {
    echo "Available custom functions:"
    echo "custom_command - A custom command that does something."
    echo "ytmusicdl - Download music from YouTube. Works both for single videos and playlists."
    # Add additional custom functions below with a brief description.
}
