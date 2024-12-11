#!/bin/bash
# Note: to run this script on background:
# ./script.sh < /dev/null &> /tmp/ffmpeg_cameras/<stream_name>.log &

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color


if [ "$#" -lt 1 ]; then
  echo -e "${RED}Error:${NC} The script requires at least one argument: the ${YELLOW}endpoint name${NC}."
  echo -e "Optionally, you can provide a ${YELLOW}second argument${NC}: the ${GREEN}input file name${NC}."
  echo -e ""
  echo -e "Usage: start_camera ${BLUE}<stream_name>${NC} ${BLUE}<file_path>${NC}"
  echo -e "${CYAN}Example:${NC} start_camera ${GREEN}mystream_smit${NC}"
  echo -e "This will start an RTSP stream at ${BLUE}rtsp://localhost:8554/mystream_smit${NC} using the default video."
  echo -e "${CYAN}Example:${NC} start_camera ${GREEN}mystream_custom_video${NC} ${YELLOW}video_file.mp4${NC}"
  echo -e "This will start an RTSP stream at ${BLUE}rtsp://localhost:8554/mystream_custom_video${NC} serving '${YELLOW}video_file.mp4${NC}' in a loop."
  echo -e "${CYAN}Example:${NC} start_camera ${GREEN}mystream_custom_image${NC} ${YELLOW}image_file.jpg${NC}"
  echo -e "This will start an RTSP stream at ${BLUE}rtsp://localhost:8554/mystream_custom_image${NC} serving '${YELLOW}image_file.jpg${NC}' in a loop."
  exit 1
fi

if [ "$#" -lt 2 ]; then
  DEFAULT_FILE="/home/ubuntu/ffmpeg-dash-server/20240912125112937.MP4"
  echo -e "${GREEN}Using file:${NC} ${YELLOW}${DEFAULT_FILE}${NC}"
else
  DEFAULT_FILE="$2"
fi


STREAM_URL="rtsp://localhost:8554/$1"

monitor_progress() {
  "$@" -progress /dev/stdout | \
  {
    frame=""; fps=""; bitrate=""; total_size=""; speed=""
    while IFS= read -r line; do
      # Check for each desired parameter and update the respective variable
      if [[ "$line" =~ ^frame= ]]; then
        frame="${line#*=}"
      elif [[ "$line" =~ ^fps= ]]; then
        fps="${line#*=}"
      elif [[ "$line" =~ ^bitrate= ]]; then
        bitrate="${line#*=}"
      elif [[ "$line" =~ ^total_size= ]]; then
        total_size="${line#*=}"
      elif [[ "$line" =~ ^speed= ]]; then
        speed="${line#*=}"
      fi

      # Print all the gathered information on one line with colors and clear previous output
      printf "\r%-115s" "" # Clear previous line with padding
      printf "\r${YELLOW}${STREAM_URL}${NC} : ${RED}Frame:${NC} %s | ${GREEN}FPS:${NC} %s | ${YELLOW}Bitrate:${NC} %s | ${BLUE}Total Size:${NC} %s | ${CYAN}Speed:${NC} %s" \
        "$frame" "$fps" "$bitrate" "$total_size" "$speed"
    done
  }
  echo "" # Newline after the monitoring ends
}

# Determine the MIME type of the input file
file_type=$(file --mime-type -b "$DEFAULT_FILE")

if [[ "$file_type" == image/* ]]; then
  # If the input is an image, stream it as a continuous video
  monitor_progress ffmpeg -stream_loop -1 -re -loop 1 -i "$DEFAULT_FILE" \
    -f lavfi -i anullsrc -c:v libx264 -preset ultrafast -tune zerolatency \
    -pix_fmt yuv420p -c:a aac -ar 44100 -ac 2 -loglevel error -shortest \
    -f rtsp -rtsp_transport tcp $STREAM_URL

elif [[ "$file_type" == video/* ]]; then
  # If the input is a video, stream it normally in a loop
  monitor_progress ffmpeg -stream_loop -1 -re -i "$DEFAULT_FILE" \
    -c copy -f rtsp -rtsp_transport tcp -loglevel error \
    $STREAM_URL


else
  echo "Unsupported file type: $file_type"
  exit 1
fi

wait