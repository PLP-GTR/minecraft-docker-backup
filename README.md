# minecraft_backup
Backup script for Minecraft running by docker

*DISCLAIMER:* This is mainly a repository with stuff to help me remember how I set it up. This might break your system or whatever setup you are using. Maybe you should search for better alternatives but I started from scratch and this is it. I want to switch to rsnapshot and transfer the backups off the machine. (This note can also be read by future me!)

Currently the setup is too simple:
- 2 Minecraft servers run by docker
- Backups every night to home dir on same server
- Yeah that's it

Check other projects for better usage instead of this one:
- audy/backup-minecraft.rb [dockerized minecraft backup](https://gist.github.com/audy/e04f617f6ba2ae045b04)
- [Lerk](https://lerks.blog)'s [Automagic Minecraft Server Backups With Map Renderings Using GitLab CI and GitLab Pages](https://lerks.blog/automagic-minecraft-server-backups-with-map-renderings-using-gitlab-ci-and-gitlab-pages/)

Abbreviations in this Readme:
- `dc`: Docker
- `mc`: Minecraft

# About the server(s)

Image used by docker:
`itzg/minecraft-server:latest` ([docker hub](https://hub.docker.com/r/itzg/minecraft-server/))

Servers run by docker with following commands:

## Server A

**S-U-I** at Port 2320.

Minecraft data directory mapped by volume to host directory: `/var/docker/dc_mc_sui_data`

`docker run -d -e EULA=TRUE -e VERSION=1.14.4 -p 2320:25565 -v /var/docker/dc_mc_sui_data:/data --name mc_sui itzg/minecraft-server:latest`

## Server B

**La-Awesome** at Port 25565

Minecraft data directory mapped by volume to host directory: `/var/docker/dc_mc_laawesome_data`

`docker run -d -e EULA=TRUE -e VERSION=1.14.4 -p 25565:25565 -v /var/docker/dc_mc_laawesome_data:/data --name mc_laawesome itzg/minecraft-server:latest`

# Script

Usage:
`> sh backup_dc_mc.sh <container_name> <rcon_password>`

Parameters:
- `container_name`: The human readable name of the docker container. Docker CLI param `--name`
- `rcon_password`: The RCON password of the server (Minecraft `server.properties`, line `rcon.password=xxx`)

## Backup location

The location is currently hardcoded.

The backup filename is generated with date and time: `dc_<container_name>_data_yyyyMMdd_HHmmss.tar.gz` 

Example: `dc_mc_laawesome_data_20191030_042115.tar.gz`

# Cron

Cron example (no, these rcon passwords are not used anywhere):

```
# Backup Minecraft Docker Volume files once a day at 4 in the night
# Param 1: Container name
# Param 2: rcon-cli password
#
5 4 * * * sh /home/plpgtr/backup_dc_mc.sh mc_sui 68xEnjaVJFNDaD > /home/plpgtr/logs/backup_dc_mc_sui.log 2>&1
15 4 * * * sh /home/plpgtr/backup_dc_mc.sh mc_laawesome AD9B4gV3Q3J7pB > /home/plpgtr/logs/backup_dc_mc_laawesome.log 2>&1
```