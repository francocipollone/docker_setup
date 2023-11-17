# docker_setup

## Introduction

How many times have you had to create a docker setup for code development or for trying any other library?
The idea of this repository is to ease the path of setting up the environment.

## Usage

Clone this repo at the same level as the code you want to add as a volume into a container.

Modify `config.yaml` and `requirements.txt` files  according to your case.

 - config.yaml: It is a configuration file that can be used to customize the container:
   - BASE_IMAGE: Base image to built upon. (e.g.: osrf/ros:rolling-desktop)
   - IMAGE_NAME: Name of the built image. (e.g.: ros_dev_ws_image)
   - CONTAINER_NAME: Name of the container. (e.g.: ros_dev_ws_container)
   - BASHRC_APPEND: Commands to be added to the .bashrc file. (e.g.: export MY_VAR=30;export RULE=True)
 - requirements.txt: List of `apt` packages that you want to install in the image.

Build image
```
./build.sh
```

Run container
```
./run.sh
```

_Note: If the container is already running you can use `join.sh` to join to the container._

## Save the current state

Once you open the container and continue setting this up, you can save the context and overwrite the image so it isn't necessary to do it again in the future. It is useful for development.
For doing so simply execute `exit`:

```
(docker) franco@:~/ros_dev_ws$ exit
access control enabled, only authorized clients can connect
Do you want to overwrite the image called 'ros_dev_ws_image' with the current changes? [y/n]: y
Overwriting docker image...
```
Next time you run the container these changes will be persisted.
You can go back to initial state by building again the image (`./build.sh`)
