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

# Install Winetricks
#cd /tmp
#mkdir -p /mnt/server/winetricks
#curl -sSL -o /mnt/server/winetricks/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
#chmod +x /mnt/server/winetricks/winetricks
#cd /mnt/server
#WINEPREFIX=/mnt/server/.wine /mnt/server/winetricks/winetricks vcrun2022 --force

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
#curl -sSL -o steamcmd.zip https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip
#unzip steamcmd.zip -d /mnt/server/steamcmd

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

## install game using steamcmd.exe
#WINEPREFIX=/mnt/server/.wine wine steamcmd/steamcmd.exe +force_install_dir ./PalServer +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} $( [[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows' ) +app_update ${SRCDS_APPID} $( [[ -z ${SRCDS_BETAID} ]] || printf %s "-beta ${SRCDS_BETAID}" ) $( [[ -z ${SRCDS_BETAPASS} ]] || printf %s "-betapassword ${SRCDS_BETAPASS}" ) ${INSTALL_FLAGS} validate +quit ## other flags may be needed depending on install. looking at you cs 1.6

# Install VC_redist 2022
cd /mnt/server
WINEPREFIX=/mnt/server/.wine wine /mnt/server/PalServer/_CommonRedist/vcredist/2022/VC_redist.x64.exe /q /norestart
WINEPREFIX=/mnt/server/.wine wine /mnt/server/PalServer/_CommonRedist/vcredist/2022/VC_redist.x86.exe /q /norestart


## add below your custom commands if needed

## install end
echo "-----------------------------------------"
echo "Installation completed..."
echo "-----------------------------------------"