#!/bin/sh
# Info
export TOPIC=shadow
export MIBPATH=/etc/shadow
export SDPATH=$TOPIC
export TYPE="file"
DESCRIPTION="This script will replace shadow file"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh
sleep 1

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh
sleep 1

chmod 777 $MIBPATH

echo
echo "Done. Now restart the unit"

exit 0
