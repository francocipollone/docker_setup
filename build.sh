#!/bin/bash

set -e

IMAGE_NAME=ros_dev_zenoh_rmw_ws_image
echo "Building the docker image: $IMAGE_NAME"

SCRIPT_FOLDER_PATH="$(cd "$(dirname "$0")"; pwd)"
CONTEXT_FOLDER_PATH="$(cd "$(dirname "$0")"; cd .. ; pwd)"

DOCKERFILE_PATH=$SCRIPT_FOLDER_PATH/Dockerfile


USERNAME=$(whoami)
USER_UID=$(id -u)
USER_GID=$(id -g)

sudo docker build -t $IMAGE_NAME \
     --file $DOCKERFILE_PATH \
     --build-arg USERNAME=$USERNAME \
     --build-arg USER_UID=$USER_UID \
     --build-arg USER_GID=$USER_GID \
     $CONTEXT_FOLDER_PATH
