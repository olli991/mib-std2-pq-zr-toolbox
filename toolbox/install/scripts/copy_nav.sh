#!/bin/sh
export TOPIC=navigation
export MIBPATH=/tsd/etc/nav/mibstd2_nav_target.ini 
export SDPATH=$TOPIC/mibstd2_nav_target.ini 
export DESCRIPTION="This script will copy mibstd2_nav_target.ini "
export TYPE="file"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later
. /tsd/scripts/util_checksd.sh
if [[ -z "$VOLUME" ]] 
then
	echo "No SD card found, quitting"
	exit 0
fi

# Make backup folder
export BACKUPFOLDER=$VOLUME/backup/$TOPIC/

. /tsd/scripts/util_backup.sh

# Copy file(s) to unit
. /tsd/scripts/util_copy.sh

/bin/chmod 777 /tsd/etc/nav/mibstd2_nav_target.ini

echo "Done. Now restart the unit."

exit 0
