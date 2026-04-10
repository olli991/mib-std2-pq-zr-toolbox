#!/bin/ksh
export TOPIC=mirrorlink
export MIBPATH=/tsd/etc/mirrorlink/mirrorlink.config.common.xml
export SDPATH=$TOPIC
export TYPE="file"

echo "This script will dump Mirrorlink config file"
. /tsd/etc/persistence/esd/scripts/util_dump.sh