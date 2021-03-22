#!/bin/ksh
# Info
export TOPIC=mirrorlink
export MIBPATH=/tsd/etc/mirrorlink/mirrorlink.config.common.xml
export SDPATH=$TOPIC
export TYPE="file"
DESCRIPTION="This script will dump Mirrorlink config file"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Dump files
. /tsd/etc/persistence/esd/scripts/util_dump.sh

exit 0
