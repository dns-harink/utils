# model="base2309"
model=$1
start=$2
end=$3
> "$model-stream.txt"

for i in $(seq $start $end);
do
    ~/projects/utils/start_camera.sh harin-$model-$i </dev/null > "/home/dns-harink/logs/rtsp_stream/harin-$model-$i.log" 2>&1 &
    pid=$!
    pgid=$(ps -o pgid= -p "$pid" | tr -d ' ')  # Get the PGID for the new session
    echo "$pgid" >> "$model-stream.txt"
done