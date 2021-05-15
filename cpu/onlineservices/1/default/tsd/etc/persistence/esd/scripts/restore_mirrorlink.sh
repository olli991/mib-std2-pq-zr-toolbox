#!/bin/ksh
export TOPIC=mirrorlink
export MIBPATH=/tsd/etc/mirrorlink/mirrorlink.config.common.xml
export SDPATH=$TOPIC/mirrorlink.config.common.xml
export TYPE="file"

echo "This script will restore mirrorlink.config.common.xml from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh