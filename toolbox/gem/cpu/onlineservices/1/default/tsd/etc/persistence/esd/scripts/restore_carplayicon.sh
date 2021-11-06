#!/bin/ksh
export TOPIC=carplayicon
export MIBPATH=/tsd/etc/sal/carplay/oemIcon.png
export SDPATH=$TOPIC/oemIcon.png
export TYPE="file"

echo "This script will restore oemIcon.png from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh
