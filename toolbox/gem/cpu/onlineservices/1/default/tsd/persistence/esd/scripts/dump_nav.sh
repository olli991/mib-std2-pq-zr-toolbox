#!/bin/ksh
export TOPIC=navigation
export MIBPATH=/tsd/etc/nav/mibstd2_nav_target.ini 
export SDPATH=$TOPIC
export TYPE="file"

echo "This script will dump Navigation config file"
. /tsd/etc/persistence/esd/scripts/util_dump.sh