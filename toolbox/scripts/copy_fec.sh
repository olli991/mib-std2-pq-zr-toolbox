#!/bin/sh
# Info
export TOPIC=fec
export MIBPATH=/tsd/etc/slist/signed_exception_list.txt
export SDPATH=patch/$TOPIC/signed_exception_list.txt
export TYPE="file"
DESCRIPTION="This script will copy signed_exception_list.txt"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Make backup folder
if [ -f $MIBPATH ]; then
	. /tsd/etc/persistence/esd/scripts/util_backup.sh
	sleep 1
fi

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh
sleep 1

echo
echo "Done. Now restart the unit"

exit 0
