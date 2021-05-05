#!/bin/ksh

export TOPIC=fec
export MIBPATH=/tsd/etc/slist/signed_exception_list.txt
export SDPATH=patch/$TOPIC/signed_exception_list.txt
export TYPE="file"

# Info
echo "This script will copy signed_exception_list.txt"
echo

# Make backup folder
if [ -f $MIBPATH ]; then
	. /tsd/etc/persistence/esd/scripts/util_backup.sh
fi

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh

echo
echo "Done. Now restart the unit"

exit 0
