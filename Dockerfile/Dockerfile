FROM cm2network/steamcmd:root

RUN apt-get update && apt-get install -y gosu cron wget python3 libfreetype6

ARG APPID=2394010

ENV STEAM_HOME="/home/container" \
    PALSERVER_EXECUTABLE="/home/container/PalServer/Pal/Binaries/Win64/PalServer-Win64-Shipping-Cmd.exe" \
    STEAM_USER="anonymous" \
    STEAM_PATH="/home/container/.steam/steam" \
    APPID=$APPID \
    WINEDLLOVERRIDES="xinput1_3.dll=n,b"

RUN adduser --disabled-password --home /home/container container

RUN mkdir -p ${STEAM_PATH}
WORKDIR ${STEAM_PATH}

ENV DEBIAN_FRONTEND noninteractive

ENV PROTON_VERSION GE-Proton8-28

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        ca-certificates \
        locales \
        locales-all \
        wget

## install required packages
RUN             dpkg --add-architecture i386 \
                && apt update -y \
                && apt install -y --no-install-recommends gnupg2 numactl tzdata software-properties-common libntlm0 winbind xvfb xauth python3 libncurses5:i386 libncurses6:i386 libsdl2-2.0-0 libsdl2-2.0-0:i386



# Install Wine and xorg-x11-server-Xvfb
RUN dpkg --add-architecture i386 && \
    mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources
RUN             apt update -y
RUN             apt install --install-recommends winehq-stable cabextract wine-binfmt -y
RUN             apt install -y curl lib32gcc-s1 ca-certificates xterm expect

# Export Proton paths
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH=$STEAM_PATH
ENV STEAM_COMPAT_DATA_PATH=${STEAM_PATH}/steamapps/compatdata/${APPID}
ENV PROTON=${STEAM_PATH}/compatibilitytools.d/${PROTON_VERSION}/proton

ENV DISPLAY :1

RUN apt-get update \
    && apt-get -y install xserver-xorg-video-dummy x11-apps

# Set up Winetricks
RUN	            wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
                && chmod +x /usr/sbin/winetricks

ENV             HOME=/home/container
ENV             WINEPREFIX=/home/container/.wine
ENV             WINEDLLOVERRIDES="mscoree,mshtml="
ENV             DISPLAY=:0
ENV             DISPLAY_WIDTH=1024
ENV             DISPLAY_HEIGHT=768
ENV             DISPLAY_DEPTH=16
ENV             AUTO_UPDATE=1
ENV             XVFB=1

# Cleanup apt cache
RUN apt clean && rm -rf /var/lib/apt/lists/*

USER container
ENV USER=container HOME=/home/container
ENV PROTON_LOG=1

WORKDIR /home/container

COPY entrypoint.sh /entrypoint.sh

CMD [ "/bin/bash", "/entrypoint.sh" ]
