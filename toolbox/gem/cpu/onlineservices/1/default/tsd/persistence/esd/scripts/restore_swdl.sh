#!/bin/ksh
export TOPIC=swdl
export MIBPATH=/tsd/bin/swdownload/tsd.mibstd2.system.swdownload
export SDPATH=$TOPIC/tsd.mibstd2.system.swdownload
export TYPE="file"

echo "This script will restore tsd.mibstd2.system.swdownload from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh