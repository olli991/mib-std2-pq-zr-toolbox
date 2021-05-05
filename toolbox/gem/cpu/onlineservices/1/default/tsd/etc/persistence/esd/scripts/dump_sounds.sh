#!/bin/ksh
export TOPIC=sounds
export MIBPATH=/tsd/etc/waveplayer/sound
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump system sounds"
. /tsd/etc/persistence/esd/scripts/util_dump.sh