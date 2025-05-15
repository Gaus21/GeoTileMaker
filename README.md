# Tiles Generator

This project provides a modular Bash-based system to process raster files and generate web tiles (XYZ format) using GDAL. It supports flexible file name formats and>

## 🔧 Features

- Automatically detects date in filenames (before or after a keyword).
- Processes only the 12 most recent matching files.
- Automatically skips already processed (existing) folders.
- Skips georeferencing for `.tif` or `.tiff` files (assumes they are already georeferenced).
- Uses `gdal_translate` and `gdal2tiles.py` for processing.
- Optional `ULLR` parameter when georeferencing is needed.

## 🗂️ Project Structure


## 📦 Dependencies

Make sure the following tools are installed:

- `bash`
- `gdal_translate` (from GDAL suite)
- `gdal2tiles.py`
- `awk`, `find`, `date`, `mktemp`

Install GDAL (if not already installed):

```bash
sudo apt-get install gdal-bin


./process_files.sh <input_path> <file_extension> <keyword> <output_tiles_path> <zoom_level> <num_images>  [ullr_coords]


