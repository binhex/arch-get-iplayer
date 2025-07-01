# Application

[get_iplayer](http://www.infradead.org/get_iplayer/html/get_iplayer.html)

## Description

get_iplayer has PVR-like capabilities (like Sky+ / TiVo / Series-Link); You can
save lists of program searches which are automatically recorded when they become
available so that you can watch them when you choose and on devices that cannot
run Adobe Flash Player – even if you don’t have adequate broadband speeds or if
your broadband streams too slowly at peak hours when you want to watch a
program.

## Build notes

Latest stable get_iplayer release from Arch Linux AUR.

## Usage

```bash
docker run -d \
    --name=<container name> \
    -e SCHEDULE=<XXd|h|m|s> \
    -e VIDEO_SHOWS_NAME=<comma separated show names> \
    -e VIDEO_SHOWS_PID=<comma separated show pid's> \
    -e AUDIO_SHOWS_NAME=<comma separated show names> \
    -e AUDIO_SHOWS_PID=<comma separated show pid's> \
    -v <path for data files>:/data \
    -v <path for config files>:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e UMASK=<umask for created files> \
    -e PUID=<uid for user> \
    -e PGID=<gid for user> \
    binhex/arch-get-iplayer
```

Please replace all user variables in the above command defined by <> with the
correct values.

## Access application

N/A, CLI only.

## Example

```bash
docker run -d \
    --name=get_iplayer \
    -e SCHEDULE=12h \
    -e VIDEO_SHOWS_NAME="Chuggington,Mike the Knight" \
    -e VIDEO_SHOWS_PID="b01j9sth,m000ptgr" \
    -v /apps/docker/get_iplayer/downloaded:/data \
    -v /apps/docker/get_iplayer:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e UMASK=000 \
    -e PUID=0 \
    -e PGID=0 \
    binhex/arch-get-iplayer
```

## Notes

User ID (PUID) and Group ID (PGID) can be found by issuing the following command
for the user you want to run the container as:-

```bash
id <username>
```

___
If you appreciate my work, then please consider buying me a beer  :D

[![PayPal donation](https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MM5E27UX6AUU4)

[Documentation](https://github.com/binhex/documentation) | [Support forum](http://forums.unraid.net/index.php?topic=45838.0)
