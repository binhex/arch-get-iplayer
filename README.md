get_iplayer
===========

get_iplayer - http://www.infradead.org/get_iplayer/html/get_iplayer.html

Latest stable get_iplayer releases from Arch Linux AUR using Packer to compile.

**Pull image**

```
docker pull binhex/arch-get-iplayer
```

**Run container**

```
docker run -d --name=<container name> -v <path for media files>:/media -v <path for config files>:/config -v /etc/localtime:/etc/localtime:ro binhex/arch-get-iplayer
```

Please replace all user variables in the above command defined by <> with the correct values.

**Access application**

```
N/A (headless)
```