#!/bin/bash

set +e

echo "Running the container..."

CURRENT_FOLDER_PATH_PARENT="$(cd "$(dirname "$0")"; cd .. ; pwd)"
# Location from where the script was executed.
RUN_LOCATION="$(pwd)"

OS_VERSION=focal
IMAGE_NAME="ros_dev_zenoh_rmw_ws_image"
CONTAINER_NAME="ros_dev_zenoh_rmw_ws_container"

SSH_PATH=/home/$USER/.ssh
WORKSPACE_CONTAINER=/home/$(whoami)/ros_dev_zenoh_rmw_ws/
SSH_AUTH_SOCK_USER=$SSH_AUTH_SOCK

# Check if name container is already taken.
if sudo -g docker docker container ls -a | grep -w "${CONTAINER_NAME}$" -c &> /dev/null; then
   printf "Error: Docker container called $CONTAINER_NAME is already opened.     \
   \n\nTry removing the old container by doing: \n\t docker rm $CONTAINER_NAME   \
   \nor just initialize it with a different name.\n"
   exit 1
fi

xhost +
sudo docker run -it --runtime=nvidia \
       -e DISPLAY=$DISPLAY \
       -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK_USER \
       -v $(dirname $SSH_AUTH_SOCK_USER):$(dirname $SSH_AUTH_SOCK_USER) \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v ${CURRENT_FOLDER_PATH_PARENT}:$WORKSPACE_CONTAINER \
       -v $SSH_PATH:$SSH_PATH \
       --privileged \
       --name $CONTAINER_NAME $IMAGE_NAME
xhost -

# Trap workspace exits and give the user the choice to save changes.
function onexit() {
  while true; do
    read -p "Do you want to overwrite the image called '$IMAGE_NAME' with the current changes? [y/n]: " answer
    if [[ "${answer:0:1}" =~ y|Y ]]; then
      echo "Overwriting docker image..."
      sudo docker commit $CONTAINER_NAME $IMAGE_NAME
      break
    elif [[ "${answer:0:1}" =~ n|N ]]; then
      break
    fi
  done
  docker stop $CONTAINER_NAME > /dev/null
  docker rm $CONTAINER_NAME > /dev/null
}

trap onexit EXIT