FROM binhex/arch-base
MAINTAINER binhex

# install application
#####################

# update package databases for arch
RUN pacman -Sy --noconfirm

# run packer to install application
RUN packer -S rtmpdump-ksv-git flvstreamer get_iplayer --noconfirm

# add in custom script for shows
ADD get-iplayer-script.sh /usr/bin/get-iplayer-script.sh

# make custom script executable
RUN chmod +x /usr/bin/get-iplayer-script.sh

# set permissions
#################

# change owner
RUN chown -R nobody:users /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /root/

# set permissions
RUN chmod -R 775 /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /root/

# cleanup
#########

# completely empty pacman cache folder
RUN pacman -Scc --noconfirm

# remove temporary files
RUN rm -rf /tmp/*

# docker settings
#################

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /data to host defined data path (used to store data from app)
VOLUME /data

# add supervisor conf file
##########################

ADD get-iplayer.conf /etc/supervisor/conf.d/get-iplayer.conf

# run supervisor
################

CMD ["supervisord", "-c", "/etc/supervisor.conf", "-n"]