model="base2309"
if [ "$model" = "class-filter" ]; then
    TRITON_PORT=9101
elif [ "$model" = "class-filter-org" ]; then
    TRITON_SERVER_URL=9201
elif [ "$model" = "base" ]; then
    TRITON_SERVER_URL=9501
elif [ "$model" = "base2309" ]; then
    TRITON_SERVER_URL=9501
else
    echo "Not valid model name"
    exit 1
fi

for i in $(seq 20 29);
do
    docker run \
    --name=streamforge-rtsp-harin-ml-$model-$i \
    --rm -d \
    --gpus=all --net=host \
    -v ./camera_logs:/mount \
    --env-file=../.env.example \
    --env CAMERA_ID=ml-$model-$i\
    --env STREAM_URI=rtsp://127.0.0.1:8554/harin-ml-$model-$i \
    --env TRITON_SERVER_URL=$TRITON_SERVER_URL \
    streamforge-deepstream-onprem-rtsp-harin
    # streamforge-deepstream-rtsp-harin-ml
done