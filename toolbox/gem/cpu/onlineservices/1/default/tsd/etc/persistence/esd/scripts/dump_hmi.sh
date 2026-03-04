#!/bin/ksh
export TOPIC=hmi
export MIBPATH=/tsd/hmi/tsd.mibstd2.hmi.ifs
export SDPATH=$TOPIC
export TYPE="file"

echo "This script will dump HMI file"
. /tsd/etc/persistence/esd/scripts/util_dump.sh