FROM binhex/arch-base
MAINTAINER binhex

# install application
#####################

# update package databases for arch
RUN pacman -Sy --noconfirm

# run packer to install application
RUN packer -S rtmpdump flvstreamer get_iplayer filebot --noconfirm

# add in custom script for shows
ADD get_iplayer-script.sh /usr/bin/get_iplayer-script.sh

# docker settings
#################

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /media to host defined media path (used to read/write to media library)
VOLUME /media

# create dirs
#############

RUN mkdir -p /home/nobody

# set permissions
#################

# change owner
RUN chown -R nobody:users /home/nobody /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /usr/bin/get_iplayer-script.sh

# set permissions
RUN chmod -R 775 /home/nobody /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /usr/bin/get_iplayer-script.sh

# add conf file
###############

ADD get_iplayer.conf /etc/supervisor/conf.d/get_iplayer.conf

# cleanup
#########

# completely empty pacman cache folder
RUN pacman -Scc --noconfirm

# remove temporary files
RUN rm -rf /tmp/*

# run supervisor
################

# run supervisor
CMD ["supervisord", "-c", "/etc/supervisor.conf", "-n"]
