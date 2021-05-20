#!/bin/ksh
export TOPIC=onlineservices
export MIBPATH=/tsd/var/onlineservices
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will restore online services settings from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh