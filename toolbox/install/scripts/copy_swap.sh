#!/bin/sh
export TOPIC=swap
export MIBPATH=/tsd/bin/swap/tsd.mibstd2.system.swap
export SDPATH=patch/$TOPIC/tsd.mibstd2.system.swap
export DESCRIPTION="This script will copy tsd.mibstd2.system.swap"
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

/bin/chmod 777 /tsd/bin/swap/tsd.mibstd2.system.swap

echo "Done. Now restart the unit."

exit 0
