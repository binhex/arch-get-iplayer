#!/bin/bash
# Script to download bbc iplayer tv series, also includes filebot renaming

#set the input field separator
IFS=','

#check to make sure env set and is not empty - defined via run command
if [ ${SHOWLIST:+x} ]

	then echo "TV show list defined as ($SHOWLIST), looping over list..."
	else echo "TV show list is not defined and/or is blank, please specify using the run command for the docker using the -e flag, see docker site for details"
	
fi

#loop over list of shows - show list set via env variable in run command
for show_name in $SHOWLIST;

	do
	
	#delete any partial files
	rm -rf "/media/$show_name/*partial*"
	
	#run get_iplayer for each show
	/usr/bin/get_iplayer --profile-dir /config --get --modes=flashhd,flashvhigh,flashhigh,flashstd,flashnormal,flashlow --file-prefix="$show_name - <senum> - <episodeshort>" "$show_name" --output "/media/$show_name"

	if [ -d "$show_name" ]; then

		#run filebot to rename downloaded tv episode
		/usr/bin/filebot -rename "/media/$show_name" --action move --format "/media/{n}/Season {s.pad(2)}/{n} - {s.pad(2)}x{e.pad(2)} - {t}" --db thetvdb --conflict skip --log all
	fi

done
