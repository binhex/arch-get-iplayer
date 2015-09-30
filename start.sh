#!/bin/bash
# Script to download tv shows from BBC iPlayer

# if SHOWS env var not defined then exit
if [[ -z "${SHOWS}" ]]; then

	echo "TV show list is not defined and/or is blank, please specify shows to download using the environment variable SHOWS"
	
else

	echo "TV shows defined as ${SHOWS}"
	
fi

# make directory for incomplete downloads
mkdir -p "/data/get_iplayer/incomplete"

# split comma seperated string into list from SHOW env variable
IFS=',' read -ra SHOWLIST <<< "$SHOWS"

# re-run check for new episodes for all series
while true
do

	# loop over list of shows - SHOWS set via env variable
	for show_name in "${SHOWLIST[@]}"; do

		echo "Processing show $(show_name}..."

		# run get_get_iplayer for each show
		/usr/bin/get_iplayer --profile-dir /config --get --nopurge --modes=flashhd,flashvhigh,flashhigh,flashstd,flashnormal,flashlow --file-prefix="$show_name - <senum> - <episodeshort>" "$show_name" --output "/data/get_iplayer/incomplete/$show_name"

		# if downloaded file doesnt contain partial then move to completed else delete
		if ! ls /data/get_iplayer/incomplete/$show_name/*partial* 1> /dev/null 2>&1; then

			echo "Moving downloaded episode to completed folder..."

			# make directory for completed downloads
			mkdir -p "/data/completed/$show_name"

			# move to completed if the filename doesn't contain "partial"
			mv "/data/get_iplayer/incomplete/$show_name/*partial*" "/data/completed/$show_name/*partial*"

		else

			echo "Deleting partial downloaded episode from incomplete folder..."

			rm -rf /data/get_iplayer/incomplete/$show_name/*partial*

		fi

	done

	# if env variable SCHEDULE not defined then use default
	if [[ -z "${SCHEDULE}" ]]; then

		sleep 12h

	else

		sleep $SCHEDULE

	fi

done
