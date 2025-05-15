#!/bin/bash

source ./config.sh

input_path=$1
file_extension=$2
keyword=$3
output_tiles_path=$4
zoom_level=$5
num_files=$6
ullr_coords=$7

if [[ -z "$input_path" || -z "$file_extension" || -z "$keyword" || -z "$output_tiles_path" || -z "$zoom_level" ]]; then
    echo "Usage: ./process_files.sh <input_path> <file_extension> <keyword> <output_tiles_path> <zoom_level> [ullr_coords]"
    exit 1
fi

find "$input_path" -type f -name "*$keyword*.$file_extension" -printf '%T@ %p\n' | sort -n | tail -n $num_files | cut -f2- -d' ' | while read filepath; do
    base_filename=$(basename "$filepath")
    timestamp_folder=$(extract_date_from_filename "$base_filename" "$keyword")

    if [[ -z "$timestamp_folder" ]]; then
        echo "Could not extract timestamp from: $base_filename"
        continue
    fi

    destination_folder="$output_tiles_path/$timestamp_folder"
    if [ -d "$destination_folder" ]; then
        echo "Folder $destination_folder already exists. Skipping..."
        continue
    fi

    mkdir -p "$destination_folder"

    if needs_georeferencing "$base_filename"; then
        if [[ -z "$ullr_coords" ]]; then
            echo "ULLR coordinates required to georeference $base_filename"
            rmdir "$destination_folder"
            continue
        fi
        temp_output_file=$(mktemp -p /tmp --suffix=.tiff)
        gdal_translate -of vrt -expand rgba -a_ullr $ullr_coords -a_srs EPSG:4326 "$filepath" "$temp_output_file"
        gdal2tiles.py "$temp_output_file" "$destination_folder" -z "$zoom_level" -w none 
        echo "Tiles created for $base_filename (with georeferencing)"
        rm "$temp_output_file"
    else
        gdal2tiles.py "$filepath" "$destination_folder" -z "$zoom_level" -w none --tilesize 150
        echo "Tiles created for $base_filename (already georeferenced)"
    fi
done

