#!/bin/sh
# Info
# Cleanup mapcfg failure

# Mount system as read/write
. /tsd/scripts/util_mount.sh
sleep 1

rm -rfv /tsd/var/nav/cfg/mapcfg/mapcfg

echo Done

exit 0
