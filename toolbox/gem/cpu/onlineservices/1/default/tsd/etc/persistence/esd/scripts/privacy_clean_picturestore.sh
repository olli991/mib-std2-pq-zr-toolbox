#!/bin/ksh
export TOPIC=picturestore
export MIBPATH=/tsd/var/picturestore
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script cleans radiostations picturestore"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

if [ -d $MIBPATH ]; then
	echo "Deleting picturestore. Please wait..."
	rm -rf $MIBPATH && mkdir $MIBPATH
	sync
	echo "Done. Please reboot the unit."
else
	echo "ERROR: $MIBPATH is not found"
fi

exit 0