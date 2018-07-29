#!/bin/sh

# Script to monitor jammr.net for activity
# Add the below line to your crontab to check jammr.net every five minutes
# 5 * * * * ~/path/to/notify.sh >/dev/null 2>&1

# Read how many users were playing 5 minutes ago
PREVIOUS_FILE="previous.txt"
PREVIOUS=`cat $PREVIOUS_FILE`
# If no previous file found then set to zero
if [ -z "$PREVIOUS" ]; then
	PREVIOUS=0
fi

# Read how many users are playing now
# Fetch jammr.net and search for the string "users jamming now, extract numbers"
CURRENT=`curl --silent https://jammr.net | grep 'jamming now' | sed "s/[^0-9]//g"`

if [ -z "$CURRENT" ]; then
	# CURRENT is empty, setting to zero
	CURRENT=0
fi

echo "$PREVIOUS people were playing."
echo "$CURRENT people now playing."

#If the numbers are different, and CURRENT >0,
if [ $CURRENT -gt $PREVIOUS ]
then
	# visit my ifttt webhooks url to fire a notification
	echo "NOTIFY"
	curl 'https://maker.ifttt.com/trigger/People are jamming/with/key/myKey'
	
fi

#save the current numbers
echo $CURRENT > $PREVIOUS_FILE
