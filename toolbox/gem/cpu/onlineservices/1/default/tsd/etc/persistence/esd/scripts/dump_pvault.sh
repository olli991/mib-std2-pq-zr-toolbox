#!/bin/ksh
export TOPIC=persistence
export MIBPATH=/tsd/var/persistence
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump persistence vault"
. /tsd/etc/persistence/esd/scripts/util_dump.sh
