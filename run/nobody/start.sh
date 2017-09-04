#!/bin/bash
# Script to download tv shows from BBC iPlayer

# if SHOWS env var not defined then exit
if [[ -z "${SHOWS}" ]]; then

	echo "[crit] TV show list is not defined and/or is blank, please specify shows to download using the environment variable SHOWS"

else

	echo "[info] TV shows defined as ${SHOWS}"

fi

# split comma seperated string into list from SHOW env variable
IFS=',' read -ra SHOWLIST <<< "${SHOWS}"

# make folder for incomplete downloads
mkdir -p "/data/get_iplayer/incomplete"

# make folder for completed downloads
mkdir -p "/data/completed"

# loop over list of shows with scheduled sleep period
while true
do

	# process each show in the list
	for show_name in "${SHOWLIST[@]}"; do

		# strip whitespace from start and end of show_name
		show_name=$(echo "${show_name}" | sed -e 's~^[ \t]*~~;s~[ \t]*$~~')

		echo "[info] Processing show ${show_name}..."

		echo "[info] Delete partial downloads from incomplete folder..."
		find /data/get_iplayer/incomplete/ -type f -name "*partial*" -delete

		echo "[info] Running get_iplayer..."
		# run get_iplayer for show, saving to incomplete folder
		/usr/bin/get_iplayer --profile-dir /config --get --nopurge --modes=flashhd,flashvhigh,flashhigh,flashstd,flashnormal,flashlow --file-prefix="${show_name} - <senum> - <episodeshort>" "${show_name}" --output "/data/get_iplayer/incomplete/${show_name}"

	done

	# check incomplete folder DOES contain files with mp4 extension
	if [[ -n $(find /data/get_iplayer/incomplete/ -name '*.mp4') ]]; then

		echo "[info] Copying show folders in incomplete to completed..."
		cp -rf "/data/get_iplayer/incomplete"/* "/data/completed/"

		# if copy succesful then delete show folder in incomplete folder
		if [[ $? -eq 0 ]]; then

			echo "[info] Copy succesful, deleting incoomplete folders..."
			rm -rf "/data/get_iplayer/incomplete"/*

		else

			echo "[error] Copy failed, skipping deletion of show folders in incoomplete folder..."

		fi

	fi

	# if env variable SCHEDULE not defined then use default
	if [[ -z "${SCHEDULE}" ]]; then

		echo "[info] Env var SCHEDULE not defined, sleeping for 12 hours..."
		sleep 12h

	else

		echo "[info] Env var SCHEDULE defined, sleeping for ${SCHEDULE}..."
		sleep "${SCHEDULE}"

	fi

done
