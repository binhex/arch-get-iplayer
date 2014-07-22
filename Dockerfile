FROM binhex/arch-base
MAINTAINER binhex

# install application
#####################

# update package databases for arch
RUN pacman -Sy --noconfirm

# install any pre-reqs for application
RUN pacman -S cronie --noconfirm

# run packer to install application
RUN packer -S rtmpdump flvstreamer get_iplayer filebot --noconfirm

# add in custom script for shows
ADD get_iplayer-script.sh /usr/bin/get_iplayer-script.sh

# create cronjob
################

# add crontab file
ADD get-iplayer.cron /usr/bin/get-iplayer.cron

# load crontab file as user nobody
RUN crontab -u nobody /usr/bin/get-iplayer.cron

# set permissions
#################

# change owner
RUN chown -R nobody:users /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /usr/bin/get-iplayer.cron /usr/bin/get_iplayer-script.sh /var/run/ /root/

# set permissions
RUN chmod -R 775 /usr/share/get_iplayer/plugins /usr/bin/get_iplayer /usr/bin/get-iplayer.cron /usr/bin/get_iplayer-script.sh /var/run/ /root/

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

# map /media to host defined media path (used to read/write to media library)
VOLUME /media

# add supervisor conf file
##########################

ADD get-iplayer.conf /etc/supervisor/conf.d/get-iplayer.conf

# run supervisor
################

CMD ["supervisord", "-c", "/etc/supervisor.conf", "-n"]