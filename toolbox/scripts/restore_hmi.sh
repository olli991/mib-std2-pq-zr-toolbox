#!/bin/sh
# Info
export TOPIC=hmi
export MIBPATH=/tsd/hmi/tsd.mibstd2.hmi.ifs
export SDPATH=$TOPIC/tsd.mibstd2.hmi.ifs
export TYPE="file"
DESCRIPTION="This script will restore tsd.mibstd2.hmi.ifs from backup"

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

chmod 777 $MIBPATH

echo
echo "Done. Now restart the unit"

exit 0
