#!/bin/ksh
export TOPIC=onlineservices
export MIBPATH=/tsd/var/onlineservices
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump online services settings"
. /tsd/etc/persistence/esd/scripts/util_dump.sh
