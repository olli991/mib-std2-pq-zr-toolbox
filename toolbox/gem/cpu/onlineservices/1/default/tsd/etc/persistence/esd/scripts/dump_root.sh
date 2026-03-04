#!/bin/ksh
echo "This script will dump root of iMX6 to SD card/USB drive"
echo
if [ -d /net/imx6 ]; then
	export TOPIC=imx6_root
	export MIBPATH=""
	. /tsd/etc/persistence/esd/scripts/util_dump_root.sh
else
	echo
	echo "ERROR: /net/imx6 is not found."
	exit 0
fi