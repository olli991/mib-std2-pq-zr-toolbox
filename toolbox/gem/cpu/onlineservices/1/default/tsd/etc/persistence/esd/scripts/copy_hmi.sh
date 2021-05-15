#!/bin/ksh
export TOPIC=hmi
export MIBPATH=/tsd/hmi/tsd.mibstd2.hmi.ifs
export SDPATH=patch/$TOPIC/tsd.mibstd2.hmi.ifs
export TYPE="file"

echo "This script will copy tsd.mibstd2.hmi.ifs"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. Please restart the unit."
exit 0