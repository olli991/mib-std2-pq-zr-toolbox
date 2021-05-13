#!/bin/ksh
export TOPIC=corelogs
export MIBPATH=/tsd/var/core
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script removes core debug logs"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

if [ -d $MIBPATH ]; then
	echo "Deleting core logs. Please wait..."
	rm -rf $MIBPATH && mkdir $MIBPATH
	sync
	echo "Done. Core logs are deleted."
else
	echo "ERROR: $MIBPATH is not found"
fi

exit 0