#!/bin/bash

../planner/linuxdeploy-x86_64.AppImage --appimage-extract
../planner/linuxdeploy-plugin-qt-x86_64.AppImage --appimage-extract

QTPATH=/opt/qt512/

BINARY=apmplanner2

BINPATH=/root/planner/release

LINUXDEPLOY=/root/appimage/squashfs-root/usr/bin/linuxdeploy

BUILDINGPATH=/root/planner/AppImageBuild

ICON=/root/planner/files/APMIcons/icon.iconset/icon_512x512.png

DESKTOPFILE=/root/appimage/apmplanner2.desktop

# needed in for centos package
#LIBADD=libasound.so.2

#----------------------------------------------

# seems to be not needed anymore
# export LD_LIBRARY_PATH=$QTPATH/lib

export QMAKE=$QTPATH/bin/qmake

export QML_SOURCES_PATHS=$BINPATH/qml

export QML_MODULES_PATHS=$BINPATH/qml

export VERSION=2.0.28-rc1


$LINUXDEPLOY --appdir $BUILDINGPATH -e $BINPATH/$BINARY -i $ICON -d $DESKTOPFILE  --plugin qt --output appimage
