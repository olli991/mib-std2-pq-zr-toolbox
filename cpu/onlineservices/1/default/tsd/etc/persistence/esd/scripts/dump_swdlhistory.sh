#!/bin/ksh
export TOPIC=swdownload
export MIBPATH=/tsd/var/swdownload
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump SWDL history logs"
. /tsd/etc/persistence/esd/scripts/util_dump.sh
