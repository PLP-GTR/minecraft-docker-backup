#!/bin/sh

# This script backups a Minecraft data folder. Locations are important!
#
# Parameter 1: Container name, i.e. "mc_sui"
# Parameter 2: Minecraft server rcon-cli password
#
# Server data location:     /var/docker/dc_<container_name>_data
# Finished backup location: /home/plpgtr/backup/dc_<container_name>_data_<timestamp>.tar.gz

_c=$1
_rp=$2

printf $_c
printf $_rp

printf "Handling Server Shutdown..."
docker exec $_c rcon-cli --password $_rp say Server is going down for backups in 5 minutes!
sleep 5m
docker exec $_c rcon-cli --password $_rp say Server is going down for backups in 1 minute!
sleep 1m
docker exec $_c rcon-cli --password $_rp say Server is going down for backups now!
docker exec $_c rcon-cli --password $_rp say This is going to take a minute.

# Save the world before stopping the server (stop also saves world but w/e)
printf "Handling world saving before shutdown..."
docker exec $_c rcon-cli --password $_rp save-all
sleep 10s
printf "Shutting down minecraft server..."
docker exec $_c rcon-cli --password $_rp stop
sleep 10s

# Copy the world to another directory and start the server again
printf "Copying over the data folder to home dir..."
cd /home/plpgtr
cp -rp /var/docker/dc_${_c}_data dc_${_c}_data_backup
sleep 10s

printf "Starting minecraft server again..."
docker start ${_c}
sleep 10s

# Zip it
_now=$(date +"%Y%m%d_%H%M%S")

printf "Creating the world backup archive..."
# -c: Create archive
# -v: Verbose
# -p: Preserve Permissions
# -z: Gzip
# -f: The backup file (directly following -f)
tar -cvpzf backup/dc_${_c}_data_${_now}.tar.gz dc_${_c}_data_backup
rm -rf dc_${_c}_data_backup

printf "All done"