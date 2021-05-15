#!/bin/ksh
export TOPIC=swap
export MIBPATH=/tsd/bin/swap/tsd.mibstd2.system.swap
export SDPATH=$TOPIC/tsd.mibstd2.system.swap
export TYPE="file"

echo "This script will restore  tsd.mibstd2.system.swap from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh