#!/bin/ksh
export TOPIC=fec
export MIBPATH=/tsd/etc/slist/signed_exception_list.txt
export SDPATH=$TOPIC/signed_exception_list.txt
export TYPE="file"

echo "This script will remove signed_exception_list.txt"
echo

# Make backup first
if [ -f $MIBPATH ]; then
	. /tsd/etc/persistence/esd/scripts/util_backup.sh

	# Mount system partition in read/only mode
	. /tsd/etc/persistence/esd/scripts/util_mount.sh

	echo "Removing $MIBPATH"
	rm -f $MIBPATH
	echo "Removed."

	# Mount system partition in read/only mode
	. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
	echo
	echo "Done. Please restart the unit"
else
	echo "ERROR: $MIBPATH does not exist."
fi

exit 0