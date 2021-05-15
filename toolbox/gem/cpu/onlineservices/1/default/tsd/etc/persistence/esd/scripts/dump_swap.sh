#!/bin/ksh
export TOPIC=swap
export MIBPATH=/tsd/bin/swap/tsd.mibstd2.system.swap
export SDPATH=patch/$TOPIC
export TYPE="file"

echo "This script will dump SWAP file"
. /tsd/etc/persistence/esd/scripts/util_dump.sh