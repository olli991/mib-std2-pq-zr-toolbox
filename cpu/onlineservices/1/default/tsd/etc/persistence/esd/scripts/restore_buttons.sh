#!/bin/ksh
export TOPIC=buttons
export MIBPATH=/tsd/hmi/HMI/res/configurationmanager.res
export SDPATH=$TOPIC/configurationmanager.res
export TYPE="file"

echo "Restoring configurationmanager.res from backup..."
. /tsd/etc/persistence/esd/scripts/util_restore.sh