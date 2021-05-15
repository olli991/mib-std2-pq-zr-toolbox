#!/bin/ksh
export TOPIC=fec
export MIBPATH=/tsd/etc/slist/signed_exception_list.txt
export SDPATH=patch/$TOPIC/signed_exception_list.txt
export TYPE="file"

echo "This script will copy signed_exception_list.txt"
echo

# Make backup folder
if [ -f $MIBPATH ]; then
	. /tsd/etc/persistence/esd/scripts/util_backup.sh
fi

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. Please restart the unit."
exit 0