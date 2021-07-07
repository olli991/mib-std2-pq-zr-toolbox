#!/bin/ksh
export TOPIC=onlineservices
export MIBPATH=/tsd/var/onlineservices
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will copy online services settings to unit"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh

echo
echo "Done. Please restart the unit."
exit 0