#!/bin/sh
# Info
export TOPIC=screenshots
export SDPATH=$TOPIC
DESCRIPTION="This script will move screenshots from SD card to USB"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Possible SD card mounts
SD1=/media/mp000
SD2=/media/mp001

# Check if a USB is actually connected
if [[ $VOLUME == "/media/mp002" || $VOLUME == "/media/mp003" || $VOLUME == "/media/mp004" ]]; then
	echo "Connected USB found on mount: $VOLUME"
	
	# Check for screenshots on either SD1 or SD2
	if [ -f $SD1/SCREENSHOT_*.png ]; then
		echo "Screenshots on SD found, moving to USB..."		
		# Check if screenshot folder is already present on USB
		if [ -d $VOLUME/$TOPIC ]; then
			mv -v $SD1/SCREENSHOT_*.png $VOLUME/$TOPIC/
			echo "Copy done. Screenshots are now stored on your USB"
			exit 0
		else
			mkdir -p $VOLUME/$TOPIC
			mv -v $SD1/SCREENSHOT_*.png $VOLUME/$TOPIC/
			echo "Copy done. Screenshots are now stored on your USB"
			exit 0
		fi
		
	elif [ -f $SD2/SCREENSHOT_*.png ]; then
		echo "Screenshots on SD found, moving to USB..."		
		# Check if screenshot folder is already present on USB
		if [ -d $VOLUME/$TOPIC ]; then
			mv -v $SD2/SCREENSHOT_*.png $VOLUME/$TOPIC/
			echo "Copy done. Screenshots are now stored on your USB"
			exit 0
		else
			mkdir -p $VOLUME/$TOPIC
			mv -v $SD2/SCREENSHOT_*.png $VOLUME/$TOPIC/
			echo "Copy done. Screenshots are now stored on your USB"
			exit 0
		fi
		
	else
		echo "No screenshots on SD cards found. Aborting"
		exit 0
	fi

else
	echo "No connected USB found. Aborting"
	exit 0
fi
