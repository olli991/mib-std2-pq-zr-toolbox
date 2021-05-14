#!/bin/ksh
echo "This script saves system info to /dump/sysinfo.txt"
echo

# Locate Toolbox
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

echo
echo "Collecting info, please wait..."
. /tsd/etc/persistence/esd/scripts/sysinfo.sh >$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "****************** SLOGINFO *****************" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
sloginfo -t >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt

sync

echo
echo "Done."
exit 0