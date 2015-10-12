#!/bin/bash

# exit script if return code != 0
set -e

# define pacman packages
pacman_packages="perl-xml-simple"

# install pre-reqs
pacman -Sy --noconfirm
pacman -S --needed $pacman_packages --noconfirm

# call aur packer script
source /root/packer.sh

# set permissions
chmod +x /home/nobody/start.sh
chown -R nobody:users /usr/share/get_iplayer/plugins /usr/bin/get_iplayer
chmod -R 775 /usr/share/get_iplayer/plugins /usr/bin/get_iplayer

# cleanup
yes|pacman -Scc
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /tmp/*
