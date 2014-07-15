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

# create dirs
#############

RUN mkdir -p /home/nobody

# set permissions
#################

# change owner
RUN chown -R nobody:users /home/nobody /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /usr/bin/get_iplayer-script.sh

# set permissions
RUN chmod -R 775 /home/nobody /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /usr/bin/get_iplayer-script.sh

# set root home dir to allow rwx for all users - required for rtmpdump and filebot
RUN chmod -R 777 /root

# cleanup
#########

# completely empty pacman cache folder
RUN pacman -Scc --noconfirm

# remove temporary files
RUN rm -rf /tmp/*

# docker settings
#################

# set user to nobody
USER nobody

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /media to host defined media path (used to read/write to media library)
VOLUME /media

# run process
#############

CMD ["/usr/bin/get_iplayer-script.sh"]
