#!/bin/ksh
echo "This script saves system info to /dump/sysinfo.txt"
echo

# Locate Toolbox
. /tsd/etc/persistence/esd/scripts/util_checksd.sh
echo
echo "Collecting info, please wait..."
. /tsd/etc/persistence/esd/scripts/sysinfo.sh >$VOLUME/dump/sysinfo.txt
echo >>$VOLUME/dump/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/sysinfo.txt
echo "****************** SLOGINFO *****************" >>$VOLUME/dump/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/sysinfo.txt
echo "Time                 Sev Major Minor Args" >>$VOLUME/dump/sysinfo.txt
sloginfo -t >>$VOLUME/dump/sysinfo.txt

sync

echo
echo "Done."
exit 0