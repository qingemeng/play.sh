#!/bin/bash

# The directory where you would like to search for music files; change
# to wherever you keep your music
MUSIC_DIR=~/Music/Music

# Get arguments passed in
args="$@"

# Find mp3 files that contain args
songs=$(find $MUSIC_DIR -ipath "*${args}*.mp3")

# Count the number of files found
chars=$(echo -n "$songs" | wc -m | awk {'print $1'})
lines=$(echo "$songs" | wc -l | awk {'print $1'})

# No songs found
if [ $chars -eq "0" ]
then
	echo "No songs found matching '$args'."
	exit $?

# Only one result
elif [ $lines -eq "1" ]
then
	selection="$songs"

# Multiple results
# Show line numbers in front of each result and prompt the user to
# choose which song to play
# User can also enter '?' to choose one of the results at random
else
	echo "$lines songs found matching '$args':"
	echo
	echo "$songs" | while read song; do echo ${song#$MUSIC_DIR/}; done | sed 's:/: › :g' | nl | grep -i "$args"
	echo

	read -p "Choose the song to be played ('?' for random selection): " num
		if [ $num = "?" ]; then num=$[$RANDOM % $lines + 1]; fi
		selection=$(echo "$songs" | sed -n "$num"p)

	echo
fi

# Play the song in the background
# Playback can be stopped using `killall -TERM afplay`
echo "Playing: ${selection#$MUSIC_DIR/}" | sed 's:/: › :g'
afplay "$selection" &