#!/bin/bash

export HARIN_PORT1=9100
export HARIN_PORT2=9101
export HARIN_PORT3=9102

# IMAGE_NAME=harin-tritonserver23-ml-base
IMAGE_NAME=triton-server-base2309

docker run --gpus=1 \
--shm-size=1g \
--rm \
-d \
--name=$IMAGE_NAME-1 \
-p $HARIN_PORT1:8000 \
-p $HARIN_PORT2:8001 \
-p $HARIN_PORT3:8002 \
-v ~/projects:/shared \
-v .:/sharedc \
$IMAGE_NAME \
tritonserver --model-repository=/models

# Helper commands
# /bin/bash
#
# tritonserver --model-repository=/models
#
# tritonserver --model-repository=/sharedc/models --log-verbose=2
#
# tritonserver \
# --model-repository=/models \
# --model-control-mode=poll \
# --repository-poll-secs=1 \
# --cache-config local,size=1048576
