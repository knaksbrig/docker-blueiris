FROM phusion/baseimage:master
MAINTAINER jshridha

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /config nobody && \
 chown -R nobody:users /home

RUN apt-get update &&  apt-get -y install xvfb x11vnc xdotool wget supervisor cabextract websockify net-tools

ENV WINEPREFIX /root/prefix64
ENV WINEARCH win64
ENV DISPLAY :0

# Install wine
RUN \
 #wget -nc https://dl.winehq.org/wine-builds/Release.key && \
  #wget -nc https://dl.winehq.org/wine-builds/Release.key && \
 #apt-key add Release.key && \
 #apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv F987672F && \
 #apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' && \
 #add-apt-repository ppa:cybermax-dexter/sdl2-backport && \
 apt-get update && \
 apt -y install --allow-unauthenticated wine64
 #apt-get -y install --allow-unauthenticated --install-recommends winehq-devel

RUN \
 cd /usr/bin/ && \
 wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
 chmod +x winetricks && \
 sh winetricks corefonts wininet

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD blueiris.sh /root/blueiris.sh
RUN chmod +x /root/blueiris.sh

RUN mv /root/prefix64 /root/prefix64_original && \
    mkdir /root/prefix64

WORKDIR /root/
ADD novnc /root/novnc/

# Expose Port
EXPOSE 8080

CMD ["/usr/bin/supervisord"]
