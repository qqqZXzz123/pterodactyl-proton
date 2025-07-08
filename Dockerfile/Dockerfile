FROM ghcr.io/parkervcp/yolks:debian

LABEL author="Michael Parker" maintainer="parker@pterodactyl.io"
LABEL org.opencontainers.image.licenses=MIT

# Установка необходимых пакетов
RUN dpkg --add-architecture i386 \
    && apt update -y \
    && apt install -y --no-install-recommends \
        gnupg2 \
        numactl \
        tzdata \
        software-properties-common \
        libntlm0 \
        winbind \
        xvfb \
        xauth \
        python3 \
        libncurses5:i386 \
        libncurses6:i386 \
        libsdl2-2.0-0 \
        libsdl2-2.0-0:i386 \
        cabextract \
        curl \
        lib32gcc-s1 \
        ca-certificates \
        xterm \
        expect

# Установка Winetricks
RUN wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/sbin/winetricks

# Установка Proton GE
RUN mkdir -p /usr/local/proton-ge \
    && cd /usr/local/proton-ge \
    && curl -sL https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest \
    | grep "browser_download_url.*\.tar\.gz" \
    | cut -d '"' -f 4 \
    | head -1 \
    | xargs -I {} curl -L {} | tar xz --strip-components=1

# Клонирование и установка umu-launcher
RUN git clone https://github.com/Open-Wine-Components/umu-launcher.git /tmp/umu-launcher \
    && cd /tmp/umu-launcher \
    && python3 -m pip install . \
    && rm -rf /tmp/umu-launcher

# Настройка переменных окружения для Proton GE
ENV PATH="/usr/local/proton-ge/dist/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/proton-ge/dist/lib:${LD_LIBRARY_PATH}"
ENV WINEDLLPATH="/usr/local/proton-ge/dist/lib/wine"
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH="/home/container"
ENV STEAM_COMPAT_DATA_PATH="/home/container/.wine"

# Общие переменные окружения
ENV HOME=/home/container
ENV WINEPREFIX=/home/container/.wine
ENV WINEDLLOVERRIDES="mscoree,mshtml="
ENV DISPLAY=:0
ENV DISPLAY_WIDTH=1024
ENV DISPLAY_HEIGHT=768
ENV DISPLAY_DEPTH=16
ENV AUTO_UPDATE=1
ENV XVFB=1

# Cleanup apt cache
RUN apt clean && rm -rf /var/lib/apt/lists/*

USER container
ENV USER=container HOME=/home/container
ENV PROTON_LOG=1

WORKDIR /home/container

COPY entrypoint.sh /entrypoint.sh

CMD [ "/bin/bash", "/entrypoint.sh" ]
