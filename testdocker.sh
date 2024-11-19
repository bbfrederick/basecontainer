#!/bin/bash

MYIPADDRESS=`ifconfig en0 | grep 'inet ' | awk '{print $2}'`
VERSION=latest

# allow network connections in Xquartz Security settings
xhost +

# Allow your local user access via xhost: xhost +SI:localuser:picachooser and create a similar user with docker run option: --user=$(id -u):$(id -g)
docker pull fredericklab/basecontainer:${VERSION}
docker run \
    --network host\
    -it \
    -e DISPLAY=${MYIPADDRESS}:0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    fredericklab/basecontainer:${VERSION} \
    xterm
