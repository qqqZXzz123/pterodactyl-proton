# Palworld Dedicated Server (Windows version of the server) running using Proton-GE

## What is this?

I wanted to run all the mods I want inside Pterodactyl Panel for easier management.

Since at the time of writing there is not much support for lua mods etc. on Linux I've written this to run the Windows Version of PalServer inside a for Pterodactyl optimized Docker container. This makes it possible to use the PalWorld-ServerInjector on Linux while at the same time you can manage the server files etc via the Pterodactyl web interface.

### What do the folders contain?

#### archive
This includes previous versions of the files in this repository for documentation purposes.
As soon as something needs to be changed, the current status is copied into its own subfolder in order to keep an earlier version more easily accessible.

#### Dockerfile
On the one hand, here is the Docker file, which specifies what should be contained in the Docker image. On the other hand, here is the entrypoint.sh file, which serves as an entry point in the container.

#### install-script
Here you will find the installation script that is used for the basic installation of the PalWorld Server in the Pterodactyl Panel.
This script is already included in the Egg and does not need to be inserted manually. The additionally stored script is used for easier editing or optimization.

#### pterodactyl-egg
This is where the Pterodactyl Egg is located, which can be imported into the panel.
