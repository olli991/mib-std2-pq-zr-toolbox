#!/bin/ksh
export TOPIC=stationdb
export MIBPATH=/tsd/etc/stationdb/VW_STL_DB.sqlite
export SDPATH=$TOPIC
export TYPE="file"

echo "This script will dump the radio station logo database (RSDB)"
. /tsd/etc/persistence/esd/scripts/util_dump.sh