FROM binhex/arch-base:2014101300
MAINTAINER binhex

# additional files
##################

# download packer from aur
ADD https://aur.archlinux.org/packages/pa/packer/packer.tar.gz /root/packer.tar.gz

# add in custom script
ADD get-iplayer-script.sh /usr/bin/get-iplayer-script.sh

# add supervisor conf file for app
ADD get-iplayer.conf /etc/supervisor/conf.d/get-iplayer.conf

# install packer
################

# install base devel, install app using packer, set perms, cleanup
RUN pacman -Sy --noconfirm && \
	pacman -S --needed base-devel --noconfirm && \
	cd /root && \
	tar -xzf packer.tar.gz && \
	cd /root/packer && \
	makepkg -s --asroot --noconfirm && \
	pacman -U /root/packer/packer*.tar.xz --noconfirm && \
	packer -S rtmpdump-ksv-git flvstreamer get_iplayer --noconfirm && \
	pacman -Ru base-devel --noconfirm && \
	pacman -Scc --noconfirm && \	
	chmod +x /usr/bin/get-iplayer-script.sh && \
	chown -R nobody:users /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /root/ && \
	chmod -R 775 /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /root/	&& \	
	rm -rf /archlinux/usr/share/locale && \
	rm -rf /archlinux/usr/share/man && \
	rm -rf /root/* && \
	rm -rf /tmp/*

# docker settings
#################

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /data to host defined data path (used to store data from app)
VOLUME /data

# run supervisor
################

CMD ["supervisord", "-c", "/etc/supervisor.conf", "-n"]