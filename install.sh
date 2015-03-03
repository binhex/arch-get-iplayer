#!/bin/bash

# install pre-reqs
pacman -Sy --noconfirm

# call aur packer script
source /root/packer.sh

# set permissions
chmod +x /usr/bin/get-iplayer-script.sh
chown -R nobody:users /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /root/
chmod -R 775 /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /root/	

# cleanup
yes|pacman -Scc
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /tmp/*
