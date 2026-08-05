#!/bin/bash

# Check if a log directory argument was provided
if [ -z "$1" ]; then
    echo "Error: No log directory provided."
    echo "Usage: log-archive <log-directory>"
    exit 1
fi

LOG_DIR="$1"
ARCHIVE_DIR="/var/log/archive"
LOG_FILE="${ARCHIVE_DIR}/archive_history.log"

# Check if the target directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' does not exist."
    exit 1
fi

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Timestamp & Archive Filename (YYYYMMDD_HHMMSS)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${ARCHIVE_DIR}/${ARCHIVE_NAME}"

echo "Archiving logs from '$LOG_DIR'..."

# Compress the logs into a tar.gz file
tar -czf "$ARCHIVE_PATH" -C "$LOG_DIR" . 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Success: Archive created at '$ARCHIVE_PATH'"
    
    # Log the date and time of the archiving action
    LOG_ENTRY="[$(date +"%Y-%m-%d %H:%M:%S")] Archived '$LOG_DIR' to '$ARCHIVE_PATH'"
    echo "$LOG_ENTRY" >> "$LOG_FILE"
    
    echo "Archive history updated in '$LOG_FILE'."
else
    echo "Error: Failed to create archive."
    exit 1
fi