FROM vookimedlo/ubuntu-qt:5.12_gcc_xenial

RUN apt-get update && apt-get install -y qt512svg qt512serialport zlib1g-dev libsdl2-dev libasound2-dev libsndfile1-dev

COPY ./apmplanner2.desktop /root/appimage/
COPY ./buildAppimage.sh /root/appimage/

ENV PATH "$PATH:/opt/qt512/bin"

CMD ["/root/appimage/buildAppimage.sh"]
