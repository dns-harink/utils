#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_image_folder> <output_video> <framerate> "
    exit 1
fi

# Assign arguments to variables
input_folder=$1
output_video=$2
framerate=$3

# Check if the input folder exists
if [ ! -d "$input_folder" ]; then
    echo "Input folder '$input_folder' not found!"
    exit 1
fi

# Run the ffmpeg command to create a video from the images
echo "running" "ffmpeg -framerate "$framerate" -pattern_type glob -i "$input_folder/*.jpg" -c:v libx264 -pix_fmt yuv420p $output_video"
ffmpeg -framerate "$framerate" -pattern_type glob -i "$input_folder/*.png" -c:v libx264 -pix_fmt yuv420p $output_video

echo "Video created successfully at $output_video"
