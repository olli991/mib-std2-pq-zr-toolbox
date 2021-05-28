#!/bin/ksh
echo "This script saves extended system info to sysinfo.txt"
echo

# Locate Toolbox
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh


if [ ! -d "$VOLUME/dump/$VERSION/$SERIAL" ]; then
	echo "Creating backup folder..."
	mkdir -p $VOLUME/dump/$VERSION/$SERIAL
fi

echo
echo "Collecting info, please wait..."
. /tsd/etc/persistence/esd/scripts/util_sysinfo.sh >$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt

echo >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "Processes running on J5:" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
on -f J5 ps -Afl >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt

echo >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "Processes running on iMX6:" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
ps -Afl >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt

echo >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "Environment variables iMX6:" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
env >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt

echo >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "aps info:" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
aps show >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt

echo >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "**************** SLOGINFO J5 ****************" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
on -f J5 sloginfo -t >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt


echo >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "*************** SLOGINFO iMX6 ***************" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt
sloginfo -t >>$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt

sync

echo
echo "Done. The file can be found on $VOLUME"
echo "in /dump/$VERSION/$SERIAL/sysinfo.txt"
exit 0