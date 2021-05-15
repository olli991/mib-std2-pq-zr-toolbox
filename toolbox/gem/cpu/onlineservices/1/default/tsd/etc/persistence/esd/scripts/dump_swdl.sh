#!/bin/ksh
export TOPIC=swdl
export MIBPATH=/tsd/bin/swdownload/tsd.mibstd2.system.swdownload
export SDPATH=patch/$TOPIC
export TYPE="file"

echo "This script will dump SWDL file"
. /tsd/etc/persistence/esd/scripts/util_dump.sh