FROM ghcr.io/parkervcp/yolks:debian

LABEL author="Michael Parker" maintainer="parker@pterodactyl.io"
LABEL org.opencontainers.image.licenses=MIT

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    git \
    make \
    scdoc \
    python3 \
    python3-pip \
    python3-venv \
    cargo \
    cabextract \
    wget \
    xvfb \
    wine \
    && rm -rf /var/lib/apt/lists/*

# Установка Proton GE (последняя версия)
RUN mkdir -p /opt/proton-ge \
    && cd /opt/proton-ge \
    && wget -q $(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep "browser_download_url.*\.tar\.gz" | cut -d '"' -f 4 | head -1) \
    && tar -xzf GE-Proton*.tar.gz --strip-components=1 \
    && rm GE-Proton*.tar.gz

# Клонирование и установка umu-launcher
RUN git clone https://github.com/Open-Wine-Components/umu-launcher.git /tmp/umu-launcher \
    && cd /tmp/umu-launcher \
    && pip3 install . \
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
