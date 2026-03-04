#!/bin/ksh
export TOPIC=greenmenu
export MIBPATH=/tsd/etc/persistence/esd
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump Green Engineering Menus (*.esd files)"
. /tsd/etc/persistence/esd/scripts/util_dump.sh