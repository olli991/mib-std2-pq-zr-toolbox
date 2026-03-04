#!/bin/ksh
echo "This script will dump root of J5 SD card/USB drive"
echo
export TOPIC=j5_root
if [ -d /net/J5 ]; then
	export MIBPATH=/net/J5
else
	export MIBPATH=""
fi

. /tsd/etc/persistence/esd/scripts/util_dump_root.sh