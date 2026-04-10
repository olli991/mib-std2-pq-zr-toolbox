#!/bin/ksh
export TOPIC=hmi
export MIBPATH=/tsd/hmi/tsd.mibstd2.hmi.ifs
export SDPATH=$TOPIC/tsd.mibstd2.hmi.ifs
export TYPE="file"

echo "This script will restore tsd.mibstd2.hmi.ifs from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh
