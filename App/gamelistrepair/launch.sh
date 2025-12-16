#!/bin/sh

# fix_gamelist.sh - Gamelist.xml Cleaner for Miyoo Flip
# Purpose: Standardizes XML format and fixes path tags recursively with backups
# Features:
# - Creates backup (.bak) of original files
# - Removes './' from <path> tags  
# - Simplifies XML header to <?xml version="1.0"?>
# - Replaces self-closing tags with empty tags
# - Processes all gamelist.xml files in ../../Roms and subfolders

# Base directory to search from (relative to script location)
ROMS_DIR="$(dirname "$0")/../../Roms"

# Find and process all gamelist.xml files
find "$ROMS_DIR" -type f -name "gamelist.xml" | while read -r file; do
    echo "Processing: $file"

    # 0. Create a backup of the original file before continuing.
    cp "$file" "$file.bak"
    
    # 1. Fix path tags: remove './' prefix from ROM paths
    # Converts <path>./game.gb</path> to <path>game.gb</path>
    sed -i 's|<path>\./|<path>|g' "$file"
    
    # 2. Clean XML declaration: remove all extra attributes
    # Handles all variants:
    # <?xml version="1.0" encoding="utf-8"?>
    # <?xml version="1.0" standalone="yes"?>
    # Result: <?xml version="1.0"?>
    sed -i 's|<?xml version="1.0"[^>]*?>|<?xml version="1.0"?>|g' "$file"

    # 3. Clean XML self-closing empty tags
    # Replaces <foo /> with <foo></foo>
    sed -i 's|<\([a-zA-Z0-9]*\) */>|<\1></\1>|g' "$file"
    
    echo "Successfully modified: $file"
done

# Completion summary
echo "Operation complete. All gamelist.xml files processed with backups."
