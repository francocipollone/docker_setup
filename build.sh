#!/bin/bash

set +e


SCRIPT_FOLDER_PATH="$(cd "$(dirname "$0")"; pwd)"
CONTEXT_FOLDER_PATH="$(cd "$(dirname "$0")"; cd .. ; pwd)"

# Read config file: config.yaml and obtain BASE_IMAGE
BASE_IMAGE=$(cat ${SCRIPT_FOLDER_PATH}/config.yaml | grep -v "#" | grep "BASE_IMAGE" | cut -d " " -f 2)
if [ -z "$BASE_IMAGE" ]; then
    echo "Error: BASE_IMAGE not found in the config.yaml file. Using default value."
    BASE_IMAGE="osrf/ros:rolling-desktop"
fi
echo "Using base image: $BASE_IMAGE"
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
     --build-arg BASE_IMAGE=$BASE_IMAGE \
     --build-arg USERNAME=$USERNAME \
     --build-arg USER_UID=$USER_UID \
     --build-arg USER_GID=$USER_GID \
     $CONTEXT_FOLDER_PATH
