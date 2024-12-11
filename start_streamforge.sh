#!/bin/bash

docker run --gpus=1 \
--rm \
-it \
--name=streamforge-rhi-207-harin \
--net=host \
-v ~/projects:/shared \
streamforge-deepstream-rhombus-207-harin \
/bin/bash