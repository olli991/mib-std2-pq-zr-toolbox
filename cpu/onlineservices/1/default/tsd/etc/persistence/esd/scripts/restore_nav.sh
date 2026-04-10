#!/bin/ksh
export TOPIC=navigation
export MIBPATH=/tsd/etc/nav/mibstd2_nav_target.ini 
export SDPATH=$TOPIC/mibstd2_nav_target.ini 
export TYPE="file"

echo "This script will restore mibstd2_nav_target.ini from backup"
. /tsd/etc/persistence/esd/scripts/util_restore.sh