#!/bin/ksh
export TOPIC=shadow
export MIBPATH=/etc/shadow
export SDPATH=$TOPIC
export TYPE="file"

echo "This script will dump shadow password file"
. /tsd/etc/persistence/esd/scripts/util_dump.sh