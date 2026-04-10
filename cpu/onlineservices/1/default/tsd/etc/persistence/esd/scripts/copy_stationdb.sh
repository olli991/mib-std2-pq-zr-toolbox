#!/bin/ksh
export TOPIC=stationdb
export MIBPATH=/tsd/etc/stationdb/VW_STL_DB.sqlite
export SDPATH=$TOPIC/VW_STL_DB.sqlite
export TYPE="file"

echo "This script will copy Radio Station DB (RSDB) to "
echo "$MIBPATH"
echo

# Find the volume with Toolbox folder
unset VOLUME
for i in /media/mp00*; do
	if [ -d $i/toolbox ]; then
		export VOLUME=$i
		break
	fi
done

if [ -z $VOLUME ]; then
	echo "ERROR: No SD card or USB drive with toolbox folder were found"
	exit 1
fi

if [ ! -f "$VOLUME/custom/$SDPATH" ]; then
	echo "$VOLUME/custom/$SDPATH is not found."
	export SDPATH=$TOPIC/stl.1vw
	if [ ! -f "$VOLUME/custom/$SDPATH" ]; then
		echo "$VOLUME/custom/$SDPATH is not found."
		echo
		echo "Error: Database file is not found!"
		exit 0
	fi
fi

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh

#if [ -f "$VOLUME/custom/$TOPIC/update.txt" ]; then
#	echo "Updating info file..."
#	if [ ! -d "/tsd/etc/customer_updates/stationdb" ]; then
#		mkdir -p /tsd/etc/customer_updates/stationdb
#	fi
#	cp -f $VOLUME/custom/$TOPIC/update.txt /tsd/etc/customer_updates/stationdb/update.txt
#fi

echo "Deleting the logo cache..."
rm -f /tsd/var/stationdb/slPresets_1.slp

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. Please restart the unit."
exit 0