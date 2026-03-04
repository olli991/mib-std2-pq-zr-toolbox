#!/bin/ksh
export TOPIC=media
export MIBPATH=/tsd/var/media
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script cleans media cache"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

if [ -d $MIBPATH ]; then
	echo "Deleting media cache. Please wait..."
	rm -rf $MIBPATH && mkdir $MIBPATH
	sync
	echo "Done. Please reboot the unit."
else
	echo "ERROR: $MIBPATH is not found"
fi

exit 0