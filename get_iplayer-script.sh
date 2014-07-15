#!/bin/bash
# Script to download bbc iplayer tv series

#set the input field separator
IFS=','

#create list of bbc iplayer shows to download
show_list="Everything's Rosie,Waybuloo,Chuggington,Mike the Knight,The Adventures of Abney and Teal,The Adventures of Abney & Teal,Tree Fu Tom,Octonauts,Charlie and Lola,Little Robots,Q Pootle 5,Topsy and Tim"

#loop over list of shows
for show_name in $show_list;

	do

	#run get_iplayer for each show
	/usr/bin/get_iplayer --profile-dir /config --get --modes=flashhd,flashvhigh,flashhigh,flashstd,flashnormal,flashlow --file-prefix="$show_name - <senum> - <episodeshort>" "$show_name" --output "/media/$show_name"

	if [ -d "$show_name" ]; then

		#run filebot to rename downloaded tv episode
		filebot -rename "/media/$show_name" --action move --format "/media/{n}/Season {s.pad(2)}/{n} - {s.pad(2)}x{e.pad(2)} - {t}" --db thetvdb --conflict skip --log all
	fi

done
