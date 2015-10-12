#!/bin/bash
# Script to download tv shows from BBC iPlayer

# if SHOWS env var not defined then exit
if [[ -z "${SHOWS}" ]]; then

	echo "TV show list is not defined and/or is blank, please specify shows to download using the environment variable SHOWS"

else

	echo "TV shows defined as ${SHOWS}"

fi

# set umask to 000 (permissions octal is then 777 for dir, 666 for files)
umask 000

# split comma seperated string into list from SHOW env variable
IFS=',' read -ra SHOWLIST <<< "${SHOWS}"

# loop over list of shows with scheduled sleep period
while true
do

	# make folder for incomplete downloads
	mkdir -p "/data/get_iplayer/incomplete"

	# make folder for completed downloads
	mkdir -p "/data/completed"

	# loop over list of shows
	for show_name in "${SHOWLIST[@]}"; do

		echo "Processing show ${show_name}..."

		echo "Delete partial downloads from incomplete folder..."
		find /data/get_iplayer/incomplete/ -type f -name "*partial*" -delete
		
		# run get_iplayer for show, saving to incomplete folder
		/usr/bin/get_iplayer --profile-dir /config --get --nopurge --modes=flashhd,flashvhigh,flashhigh,flashstd,flashnormal,flashlow --file-prefix="${show_name} - <senum> - <episodeshort>" "${show_name}" --output "/data/get_iplayer/incomplete/${show_name}"

	done

	# check incomplete folder DOES contain files with flv extension
	if [[ -n $(find /data/get_iplayer/incomplete/ -name '*.flv') ]]; then

		echo "Copying folders in incomplete folder to completed..."
		cp -rf "/data/get_iplayer/incomplete"/* "/data/completed/"

		# if copy succesful then delete show folder in incomplete folder
		if [[ $? -eq 0 ]]; then

			echo "Delete folders in incomplete after succesful copy..."
			rm -rf "/data/get_iplayer/incomplete"/*

		fi

	fi

	# if env variable SCHEDULE not defined then use default
	if [[ -z "${SCHEDULE}" ]]; then

		sleep 12h

	else

		sleep ${SCHEDULE}

	fi

done
