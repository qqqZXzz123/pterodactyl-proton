#!/bin/bash
# Palworld Base Installation Script
#
# Server Files: /mnt/server
# Image to install with is 'ghcr.io/parkervcp/yolks:wine_staging'



# Install packages. Default packages below are not required if using our existing install image thus speeding up the install process.
apt -y update
apt -y --no-install-recommends install curl lib32gcc-s1 ca-certificates unzip

# Install ProtonGE
mkdir -p /mnt/server/.steam/steam
cd /mnt/server/.steam/steam
mkdir -p /mnt/server/.steam/steam/compatibilitytools.d/
wget -O - \
    https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton8-28/GE-Proton8-28.tar.gz \
    | tar -xz -C /mnt/server/.steam/steam/compatibilitytools.d/
mkdir -p /mnt/server/.steam/steam/steamapps/compatdata/2394010
cp -r /mnt/server/.steam/steam/compatibilitytools.d/GE-Proton8-28/files/share/default_pfx/* /mnt/server/.steam/steam/steamapps/compatdata/2394010

## just in case someone removed the defaults.
if [[ "${STEAM_USER}" == "" ]] || [[ "${STEAM_PASS}" == "" ]]; then
    echo -e "steam user is not set.\n"
    echo -e "Using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "user set to ${STEAM_USER}"
fi

## download and install steamcmd
cd /tmp
mkdir -p /mnt/server/steamcmd
chown -R root:root /mnt
chown -R root:root /mnt/server

cd /mnt/server/steamcmd
curl curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# SteamCMD fails otherwise for some reason, even running as root.
# This is changed at the end of the install process anyways.
chown -R root:root /mnt
chown -R root:root /mnt/server
chown -R root:root /home/container
export HOME=/mnt/server

## Create new server directory
mkdir -p /mnt/server/PalServer
cd /mnt/server

## Install game using steamcmd.sh
steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /mnt/server/PalServer +login anonymous +app_update 2394010 validate +quit

# Install VC_redist 2022
cd /mnt/server
WINEPREFIX=/mnt/server/.wine wine /mnt/server/PalServer/_CommonRedist/vcredist/2022/VC_redist.x64.exe /q /norestart
WINEPREFIX=/mnt/server/.wine wine /mnt/server/PalServer/_CommonRedist/vcredist/2022/VC_redist.x86.exe /q /norestart

cat <<EOT >> PalServer.sh
#!/bin/bash

# Updating PalServer if needed and if auto update is enabled
if [ "$AUTO_UPDATE" -eq "1" ]; then
    cd /home/container/PalServer
    /home/container/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +app_update 2394010 +quit
fi

# Starting PalServer
cd /home/container
\$PROTON run \$PALSERVER_EXECUTABLE -port {{SERVER_PORT}} -players {{MAX_PLAYERS}} -log -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS #EpicApp=PalServer
EOT

chmod +x PalServer.sh

## add below your custom commands if needed

## install end
echo "-----------------------------------------"
echo "Installation completed..."
echo "-----------------------------------------"
