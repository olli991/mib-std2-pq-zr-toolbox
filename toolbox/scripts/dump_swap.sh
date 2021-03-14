#!/bin/ksh
# Info
export TOPIC=swap
export MIBPATH=/tsd/bin/swap/tsd.mibstd2.system.swap
export SDPATH=patch/$TOPIC
export TYPE="file"
DESCRIPTION="This script will dump SWAP file"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/scripts/util_checksd.sh

# Dump files
. /tsd/scripts/util_dump.sh

exit 0
 