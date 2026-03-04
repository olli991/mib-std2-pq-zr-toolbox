#!/bin/ksh
export TOPIC=fec
export MIBPATH=/tsd/etc/slist/signed_exception_list.txt
export SDPATH=$TOPIC/signed_exception_list.txt
export TYPE="file"

echo "This script will restore FEC (signed_exception_list.txt) from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh