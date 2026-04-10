#!/bin/ksh
export TOPIC=sounds
export MIBPATH=/tsd/etc/waveplayer/sound
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will restore system sounds from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh