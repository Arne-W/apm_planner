#!/bin/bash

set -x

SOURCEDIR=$PWD/../..
LINUXDEPLOY=linuxdeploy-x86_64.AppImage
LINUXDEPLOYQT=linuxdeploy-plugin-qt-x86_64.AppImage

wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage -O $SOURCEDIR/$LINUXDEPLOY
wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage -O $SOURCEDIR/$LINUXDEPLOYQT

chmod o+x $SOURCEDIR/$LINUXDEPLOY
chmod o+x $SOURCEDIR/$LINUXDEPLOYQT

docker build -t apm-planner-build:latest .

docker run --rm -v $SOURCEDIR/:/root/planner -it apm-planner-build
