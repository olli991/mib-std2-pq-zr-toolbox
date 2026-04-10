#!/bin/ksh
export TOPIC=carplayicon
export MIBPATH=/tsd/etc/sal/carplay/oemIcon.png
export SDPATH=$TOPIC
export TYPE="file"

echo "This script will dump carplay icon file"
. /tsd/etc/persistence/esd/scripts/util_dump.sh