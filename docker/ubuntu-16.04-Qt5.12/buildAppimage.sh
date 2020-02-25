#!/bin/bash

set -x


SOURCEPATH=/home/build/planner

{ cd $SOURCEPATH
    qmake apm_planner.pro CONFIG+=qtquickcompiler -spec linux-g++-64
    make -j$(nproc)

    $SOURCEPATH/linuxdeploy-x86_64.AppImage --appimage-extract
    $SOURCEPATH/linuxdeploy-plugin-qt-x86_64.AppImage --appimage-extract

    QTPATH=/opt/qt512

    BINARY=apmplanner2

    BINPATH=$SOURCEPATH/release

    LINUXDEPLOY=$SOURCEPATH/squashfs-root/usr/bin/linuxdeploy

    BUILDINGPATH=$SOURCEPATH/AppImageBuild

    ICON=$SOURCEPATH/files/APMIcons/icon.iconset/icon_512x512.png

    DESKTOPFILE=/home/build/appimage/apmplanner2.desktop

    # needed in for centos package
    #LIBADD=libasound.so.2

    #----------------------------------------------

    # seems to be not needed anymore
    # export LD_LIBRARY_PATH=$QTPATH/lib

    export QMAKE=$QTPATH/bin/qmake

    export QML_SOURCES_PATHS=$SOURCEPATH/qml

    export QML_MODULES_PATHS=$BINPATH/qml

    export VERSION=2.0.27-rc1

    $LINUXDEPLOY --appdir $BUILDINGPATH -e $BINPATH/$BINARY -i $ICON -d $DESKTOPFILE  --plugin qt --output appimage
}
