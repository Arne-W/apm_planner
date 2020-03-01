#!/bin/bash

# stop in case of error
set -e 
set -x

SOURCEPATH=/home/build/planner

{ cd $SOURCEPATH

    # build apm planner
    qmake apm_planner.pro -spec linux-g++-64
    make -j$(nproc)

    # create the appimage
    # appimages do not work in docker due to the lack of fuse. So we simply extract the images
    $SOURCEPATH/linuxdeploy-x86_64.AppImage --appimage-extract
    $SOURCEPATH/linuxdeploy-plugin-qt-x86_64.AppImage --appimage-extract

    # setup path
    QTPATH=/opt/qt512
    BINARY=apmplanner2
    BINPATH=$SOURCEPATH/release
    LINUXDEPLOY=$SOURCEPATH/squashfs-root/usr/bin/linuxdeploy
    BUILDINGPATH=$SOURCEPATH/AppImageBuild
    ICON=$SOURCEPATH/files/APMIcons/icon.iconset/icon_512x512.png
    DESKTOPFILE=/home/build/appimage/apmplanner2.desktop
    METADATAFILE=/home/build/appimage/apmplanner2.appdata.xml

    # needed in for centos package
    #LIBADD=libasound.so.2

    #----------------------------------------------

    export QMAKE=$QTPATH/bin/qmake
    export QML_SOURCES_PATHS=$SOURCEPATH/qml
    export VERSION=2.0.27-rc1

    # Create directory structure for AppImage
    $LINUXDEPLOY --appdir $BUILDINGPATH

    # Prepopulate the directories
    # copy qml files
    cp -R $SOURCEPATH/qml $BUILDINGPATH/usr/bin
    # copy sik-radio update tool
    cp -R $SOURCEPATH/sik_uploader $BUILDINGPATH/usr/bin
    
    # copy appstream meta data - does not work at the moment 202003 
    #mkdir -p $BUILDINGPATH/usr/share/metainfo
    #cp $METADATAFILE $BUILDINGPATH/usr/share/metainfo
    
    # copy icons
    cp $SOURCEPATH/files/APMIcons/icon.iconset/icon_16x16.png $BUILDINGPATH/usr/share/icons/hicolor/16x16/apps/
    cp $SOURCEPATH/files/APMIcons/icon.iconset/icon_32x32.png $BUILDINGPATH/usr/share/icons/hicolor/32x32/apps/
    cp $SOURCEPATH/files/APMIcons/icon.iconset/icon_128x128.png $BUILDINGPATH/usr/share/icons/hicolor/128x128/apps/
    cp $SOURCEPATH/files/APMIcons/icon.iconset/icon_256x256.png $BUILDINGPATH/usr/share/icons/hicolor/256x256/apps/

    $LINUXDEPLOY --appdir $BUILDINGPATH -e $BINPATH/$BINARY -i $ICON -d $DESKTOPFILE  --plugin qt --output appimage
}
