#!/bin/ksh
export TOPIC=var
export MIBPATH=/tsd/var
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump /tsd/var partition"
. /tsd/etc/persistence/esd/scripts/util_dump.sh