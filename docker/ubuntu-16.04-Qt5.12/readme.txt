This docker can be used to build apm-planner

It is a ubuntu 16.04 based container using latest Qt 5.12.

start with:
copy appimage tools (linuxdeploy-x86_64.AppImage, linuxdeploy-plugin-qt-x86_64.AppImage) into the source folder and
start the container mounting the source into /root/planner like this:

docker run --rm -v /home/blaster/develop/ArduPilot-APM-Planner/:/root/planner -it apm-planner-build


export PATH=$PATH:/opt/qt512/bin

* change to /root/planner and call qmake apm_planner.pro CONFIG+=qtquickcompiler -spec linux-g++-64
* call make -j8
* change to /root/appimage/ and call buildAppimage.sh
