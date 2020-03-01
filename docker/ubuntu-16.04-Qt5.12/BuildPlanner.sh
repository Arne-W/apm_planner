#!/bin/bash

# Stop in case of error
set -e 
set -x

USER=$(id -u)
GROUP=$(id -g)

SOURCEDIR=$PWD/../..
LINUXDEPLOY=linuxdeploy-x86_64.AppImage
LINUXDEPLOYQT=linuxdeploy-plugin-qt-x86_64.AppImage

# download AppImage tools from gitHub
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage -O $SOURCEDIR/$LINUXDEPLOY
wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage -O $SOURCEDIR/$LINUXDEPLOYQT

chmod +x $SOURCEDIR/$LINUXDEPLOY
chmod +x $SOURCEDIR/$LINUXDEPLOYQT

# build and start docker
docker build -t apm-planner-build:latest .

docker run --rm --user $USER:$GROUP -v $SOURCEDIR/:/home/build/planner -it apm-planner-build:latest
