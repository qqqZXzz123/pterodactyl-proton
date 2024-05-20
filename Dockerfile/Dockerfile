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

# Install Wine and xorg-x11-server-Xvfb
RUN dpkg --add-architecture i386 && \
    mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources && \
    apt-get update -y && \
    apt-get install -y --install-recommends winehq-staging

# Export Proton paths
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH=$STEAM_PATH
ENV STEAM_COMPAT_DATA_PATH=${STEAM_PATH}/steamapps/compatdata/${APPID}
ENV PROTON=${STEAM_PATH}/compatibilitytools.d/${PROTON_VERSION}/proton

ENV DISPLAY :1

RUN apt-get update \
    && apt-get -y install xserver-xorg-video-dummy x11-apps

# Cleanup apt cache
RUN apt clean && rm -rf /var/lib/apt/lists/*

USER container
ENV USER=container HOME=/home/container
ENV PROTON_LOG=1

WORKDIR /home/container

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
