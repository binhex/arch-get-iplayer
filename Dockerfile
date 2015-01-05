FROM binhex/arch-base:2015010500
MAINTAINER binhex

# additional files
##################

# add in custom script
ADD get-iplayer-script.sh /usr/bin/get-iplayer-script.sh

# add supervisor conf file for app
ADD get-iplayer.conf /etc/supervisor/conf.d/get-iplayer.conf

# install packer
################

# install base devel, install app using packer, set perms, cleanup
RUN pacman -Sy --noconfirm && \
	pacman -S --needed base-devel --noconfirm && \
	useradd -m -g wheel -s /bin/bash makepkg-user && \
	echo -e "makepkg-password\nmakepkg-password" | passwd makepkg-user && \
	echo "%wheel      ALL=(ALL) ALL" >> /etc/sudoers && \
	echo "Defaults:makepkg-user      !authenticate" >> /etc/sudoers && \
	curl -o /home/makepkg-user/packer.tar.gz https://aur.archlinux.org/packages/pa/packer/packer.tar.gz && \
	cd /home/makepkg-user && \
	tar -xvf packer.tar.gz && \
	su -c "cd /home/makepkg-user/packer && makepkg -s --noconfirm --needed" - makepkg-user && \
	pacman -U /home/makepkg-user/packer/packer*.tar.xz --noconfirm && \
	su -c "packer -S rtmpdump-ksv-git flvstreamer get_iplayer --noconfirm" - makepkg-user && \
	chmod +x /usr/bin/get-iplayer-script.sh && \
	chown -R nobody:users /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /root/ && \
	chmod -R 775 /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /root/	&& \	
	pacman -Ru packer base-devel git --noconfirm && \
	yes|pacman -Scc && \
	userdel -r makepkg-user && \
	rm -rf /usr/share/locale/* && \
	rm -rf /usr/share/man/* && \
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