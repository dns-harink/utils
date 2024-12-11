#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_video> <destination_folder> <fps>"
    exit 1
fi

# Assign arguments to variables
input_video=$1
dest_folder=$2
fps=$3

# Check if the input video file exists
if [ ! -f "$input_video" ]; then
    echo "Input video file '$input_video' not found!"
    exit 1
fi

# Create the destination folder if it doesn't exist
if [ ! -d "$dest_folder" ]; then
    echo "Destination folder '$dest_folder' does not exist. Creating it..."
    mkdir -p "$dest_folder"
fi

# Run the ffmpeg command to extract frames
echo "running" "ffmpeg -i "$input_video" -vf "fps=$fps" "$dest_folder/frame_%04d.png""
ffmpeg -i "$input_video" -vf "fps=$fps" "$dest_folder/frame_%04d.png"

echo "Frames extracted successfully to $dest_folder"