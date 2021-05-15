#!/bin/ksh
export TOPIC=ringtones
export MIBPATH=/tsd/etc/waveplayer/ringtones
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will restore ringtones from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh