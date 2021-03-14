#!/bin/ksh
# Info
export TOPIC=shadow
export MIBPATH=/etc/shadow
export SDPATH=$TOPIC/shadow.txt
export TYPE="file"
DESCRIPTION="This script will dump shadow file"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/scripts/util_checksd.sh

# Dump files
. /tsd/scripts/util_dump.sh

# Show contents
echo Listing file:
sleep 1

cat $DUMPFOLDER

echo
echo "Done"

exit 0 
 