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
docker run -d --name=<container name>  -e SCHEDULE="12h" -v <path for output files>:/data -v <path for config files>:/config -v /etc/localtime:/etc/localtime:ro binhex/arch-get-iplayer
```

Please replace all user variables in the above command defined by <> with the correct values.

Note:- To define how often to re-run please set the Environment Variable "SCHEDULE" to "##X" where X is s for seconds, m for minutes, h for hours or d for days, e.g. "12h".

**Access application**

```
N/A (headless)
```