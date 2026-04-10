#!/bin/ksh
export TOPIC=greenmenu
export MIBPATH=/tsd/etc/persistence/esd
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will restore Green Engineering Menus from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh