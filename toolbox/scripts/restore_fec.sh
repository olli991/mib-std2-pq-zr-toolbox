#!/bin/sh
# Info
export TOPIC=fec
export MIBPATH=/tsd/etc/slist/signed_exception_list.txt
export SDPATH=$TOPIC/signed_exception_list.txt
export TYPE="file"
DESCRIPTION="This script will restore signed_exception_list.txt from backup"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh
sleep 1

# Restore file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_restore.sh
sleep 1

echo
echo "Done. Now restart the unit"

exit 0
