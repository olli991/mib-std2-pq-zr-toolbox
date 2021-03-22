#!/bin/ksh
# Info
export TOPIC=fec
export MIBPATH=/tsd/etc/slist/signed_exception_list.txt
export SDPATH=patch/$TOPIC
export TYPE="file"
DESCRIPTION="This script will dump signed_exception_list.txt"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Dump files
if [ -f $MIBPATH ]; then
	. /tsd/etc/persistence/esd/scripts/util_dump.sh
else
	echo "No custom FEC file found"
	exit 0
fi

exit 0
 