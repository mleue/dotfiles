#!/bin/bash

# Ensure that the script is called with exactly two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 servername remote_logfile_path"
    exit 1
fi

SERVERNAME="$1"
REMOTE_LOGFILE="$2"
LOCAL_OUTPUT_FILE="${SERVERNAME}_errors_context.log"

# Fetch the logs with context for "Error" or "Exception" and save to a variable
log_output=$(ssh "$SERVERNAME" "grep -C 1 'Error\|Exception\|ERROR\|EXCEPTION' '$REMOTE_LOGFILE'")

# Count the occurrences ignoring the context lines, only counting unique "--" separators
occurrences=$(echo "$log_output" | grep -c -e '^--$')

# Output the occurrence count
echo "Found $occurrences occurrences."

# Save the output to the local file
echo "$log_output" > "$LOCAL_OUTPUT_FILE"

echo "Log file fetched. Local output: $LOCAL_OUTPUT_FILE"
