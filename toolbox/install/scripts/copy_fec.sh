#!/bin/sh
export TOPIC=fec
export MIBPATH=/tsd/etc/slist/signed_exception_list.txt
export SDPATH=patch/$TOPIC/signed_exception_list.txt
export DESCRIPTION="This script will copy signed_exception_list.txt"
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

echo "Done. Now restart the unit."

exit 0
