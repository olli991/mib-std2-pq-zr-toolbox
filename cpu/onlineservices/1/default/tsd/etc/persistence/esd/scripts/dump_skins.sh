#!/bin/ksh
export TOPIC=skins
export MIBPATH=/tsd/hmi/Resources
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump skins"
. /tsd/etc/persistence/esd/scripts/util_dump.sh