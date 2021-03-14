#!/bin/sh
# Info
export TOPIC=hmi
export MIBPATH=/tsd/hmi/tsd.mibstd2.hmi.ifs
export SDPATH=patch/$TOPIC/tsd.mibstd2.hmi.ifs
export TYPE="file"
DESCRIPTION="This script will copy tsd.mibstd2.hmi.ifs"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/scripts/util_checksd.sh

# Make backup folder
. /tsd/scripts/util_backup.sh
sleep 1

# Copy file(s) to unit
. /tsd/scripts/util_copy.sh
sleep 1

chmod 777 $MIBPATH

echo
echo "Done. Now restart the unit"

exit 0
