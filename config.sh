#!/bin/bash

# Determines if georeferencing is needed
# Returns 0 if needed, 1 if not needed
needs_georeferencing() {
    local extension=$(echo "$1" | awk -F. '{print tolower($NF)}')
    if [[ "$extension" == "tif" || "$extension" == "tiff" ]]; then
        return 1
    fi
    return 0
}

# Extracts date in %Y%m%d%H%M format from filename
extract_date_from_filename() {
    local filename="$1"
    local keyword="$2"
    
    # Try format: keyword + date
    local candidate1="${filename#*$keyword}"
    candidate1="${candidate1%%.*}"

    # Try format: date + keyword
    local candidate2="${filename%%$keyword*}"

    for possible in "$candidate1" "$candidate2"; do
        if [[ $possible =~ ^[0-9]{12}$ ]]; then
            date -d "${possible:0:4}-${possible:4:2}-${possible:6:2} ${possible:8:2}:${possible:10:2}" "+%Y%m%d%H%M" 2>/dev/null
            return
        fi
    done

    echo ""
}

