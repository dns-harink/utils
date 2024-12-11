model="base2309"

for i in $(seq 0 9);
do
    docker kill \
    streamforge-rtsp-harin-ml-$model-$i
done