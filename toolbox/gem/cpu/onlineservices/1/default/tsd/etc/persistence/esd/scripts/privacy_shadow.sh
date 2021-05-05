#!/bin/ksh
export TOPIC=shadow
export MIBPATH=/etc/shadow
export SDPATH=$TOPIC
export TYPE="file"

echo "This script will replace shadow file"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. Please restart the unit"

exit 0
