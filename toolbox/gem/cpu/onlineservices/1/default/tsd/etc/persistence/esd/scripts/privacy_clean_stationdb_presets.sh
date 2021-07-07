#!/bin/ksh
export TOPIC=stationdb_presets
export MIBPATH=/tsd/var/stationdb/slPresets_1.slp
export SDPATH=$TOPIC/slPresets_1.slp
export TYPE="file"

echo "This script will remove stationdb presets"
echo

# Make backup first
if [ -f $MIBPATH ]; then
	. /tsd/etc/persistence/esd/scripts/util_backup.sh
	echo "Removing $MIBPATH"
	rm -f $MIBPATH
	echo
	echo "Done. Please restart the unit"
else
	echo "ERROR: $MIBPATH does not exist."
fi

exit 0