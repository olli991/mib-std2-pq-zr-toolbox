#!/bin/ksh
export TOPIC=shadow
export MIBPATH=/etc/shadow
export SDPATH=$TOPIC/shadow
export TYPE="file"

echo "This script will restore shadow file from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh