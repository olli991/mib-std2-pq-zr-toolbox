#!/bin/ksh
export TOPIC=fec
export MIBPATH=/tsd/etc/slist/signed_exception_list.txt
export SDPATH=patch/$TOPIC
export TYPE="file"

echo "This script will dump signed_exception_list.txt"
. /tsd/etc/persistence/esd/scripts/util_dump.sh