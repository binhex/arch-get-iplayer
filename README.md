**Application**

[get_iplayer](http://www.infradead.org/get_iplayer/html/get_iplayer.html)

**Description**

get_iplayer has PVR-like capabilities (like Sky+ / TiVo / Series-Link); You can save lists of programme searches which are automatically recorded when they become available so that you can watch them when you choose and on devices that cannot run Adobe Flash Player – even if you don’t have adequate broadband speeds or if your broadband streams too slowly at peak hours when you want to watch a programme.

**Build notes**

Latest stable get_iplayer release from Arch Linux AUR using Packer to compile.

**Usage**
```
docker run -d \
    --name=<container name> \
    -e SCHEDULE=<XXd|h|m|s> \
    -e SHOWS=<comma seperated show names> \
    -v <path for data files>:/data \
    -v <path for config files>:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e UID=<uid for user> \
    -e GID=<gid for user> \
    binhex/arch-get-iplayer
```

Please replace all user variables in the above command defined by <> with the correct values.

**Access application**

N/A, CLI only.

**Example**
```
docker run -d \
    --name=get_iplayer \
    -e SCHEDULE=12h \
    -e SHOWS=Chuggington,Mike the Knight \
    -v /apps/docker/get_iplayer/downloaded:/data \
    -v /apps/docker/get_iplayer:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e UID=0 \
    -e GID=0 \
    binhex/arch-get-iplayer
```

**Notes**

User ID (UID) and Group ID (GID) can be found by issuing the following command for the user you want to run the container as:-

```
id <username>
```

If you appreciate my work, then please consider buying me a beer  :D

[![PayPal donation](https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MM5E27UX6AUU4)

[Support forum](http://lime-technology.com/forum/index.php?topic=45838.0)