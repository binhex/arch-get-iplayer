#!/usr/bin/dumb-init /bin/bash
# Script to download tv shows from BBC iPlayer

function download() {

	shows="${1}"
	show_type="${2}"

	echo "[info] TV show Name/PID defined as '${shows}'"

	# split comma separated string into list from SHOW env variable
	IFS=',' read -ra showlist <<< "${shows}"

	# process each show in the list
	for show in "${showlist[@]}"; do

		# strip whitespace from start and end of show
		show=$(echo "${show}" | sed -e 's~^[ \t]*~~;s~[ \t]*$~~')

		echo "[info] Processing show '${show}'..."

		echo "[info] Delete partial downloads from incomplete folder '/data/get_iplayer/incomplete/'..."
		find /data/get_iplayer/incomplete/ -type f -name "*partial*" -delete

		if [[ "${show_type}" == "name" ]]; then

			/usr/bin/get_iplayer --profile-dir /config --get --nopurge --tv-quality="fhd,hd,sd,web,mobile" --file-prefix="${show} - <senum> - <episodeshort>" "${show}" --output "/data/get_iplayer/incomplete/${show}"

		else

			/usr/bin/get_iplayer --profile-dir /config --get --nopurge --tv-quality="fhd,hd,sd,web,mobile" --file-prefix="${show} - <senum> - <episodeshort>" --pid="${show}" --pid-recursive --output "/data/get_iplayer/incomplete/${show}"

		fi

	done

}

function move() {

	# check incomplete folder DOES contain files with mp4 extension
	if [[ -n $(find /data/get_iplayer/incomplete/ -name '*.mp4') ]]; then

		echo "[info] Copying show folders in incomplete to completed..."
		cp -rf "/data/get_iplayer/incomplete"/* "/data/completed/"

		# if copy successful then delete show folder in incomplete folder
		if [[ $? -eq 0 ]]; then

			echo "[info] Copy successful, deleting incomplete folders..."
			rm -rf "/data/get_iplayer/incomplete"/*

		else

			echo "[error] Copy failed, skipping deletion of show folders in incomplete folder..."

		fi

	fi

}

function start() {

	# make folder for incomplete downloads
	mkdir -p "/data/get_iplayer/incomplete"

	# make folder for completed downloads
	mkdir -p "/data/completed"

	while true; do

		if [[ -n "${SHOWS}" ]]; then
			download "${SHOWS}" "name"
		fi

		if [[ -n "${SHOWS_PID}" ]]; then
			download "${SHOWS_PID}" "pid"
		fi

		# run function to move downloaded tv shows
		move

		# if env variable SCHEDULE not defined then use default
		if [[ -z "${SCHEDULE}" ]]; then

			echo "[info] Env var SCHEDULE not defined, sleeping for 12 hours..."
			sleep 12h

		else

			echo "[info] Env var SCHEDULE defined, sleeping for ${SCHEDULE}..."
			sleep "${SCHEDULE}"

		fi

	done

}

# if SHOWS env var not defined then exit
if [ -z "${SHOWS}" ] && [ -z "${SHOWS_PID}" ]; then

	echo "[crit] TV Show Name and PID is not defined and/or is blank, please specify shows to download using the environment variable 'SHOWS' and/or 'SHOWS_PID'"

fi

# run function to start processing
start