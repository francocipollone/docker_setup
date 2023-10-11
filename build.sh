#!/bin/bash

set -e


SCRIPT_FOLDER_PATH="$(cd "$(dirname "$0")"; pwd)"
CONTEXT_FOLDER_PATH="$(cd "$(dirname "$0")"; cd .. ; pwd)"

# Read config file: config.yaml and obtain IMAGE_NAME
IMAGE_NAME=$(cat ${SCRIPT_FOLDER_PATH}/config.yaml | grep -v "#" | grep "IMAGE_NAME" | cut -d " " -f 2)
if [ -z "$IMAGE_NAME" ]; then
    echo "Error: IMAGE_NAME not found in the config.yaml file. Using default value."
    IMAGE_NAME="ros_dev_ws_image"
fi
echo "Building the docker image: $IMAGE_NAME"


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
