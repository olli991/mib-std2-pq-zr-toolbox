#!/bin/ksh
# Info
export TOPIC=shadow
export MIBPATH=/etc/shadow
export SDPATH=$TOPIC
export TYPE="file"
DESCRIPTION="This script will dump shadow file"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Dump files
. /tsd/etc/persistence/esd/scripts/util_dump.sh

# Show contents
echo Listing file:
sleep 1

cat $DUMPFOLDER/shadow

echo "Done"

exit 0 
 