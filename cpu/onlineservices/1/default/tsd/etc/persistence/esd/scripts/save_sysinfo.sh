#!/bin/ksh
echo "This script saves extended system info to sysinfo.txt"
echo

# Locate Toolbox
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

if [ ! -d "$VOLUME/dump/$TRAIN/$SERIAL" ]; then
	echo "Creating backup folder..."
	mkdir -p $VOLUME/dump/$TRAIN/$SERIAL
fi

echo
echo "Collecting info, please wait..."
. /tsd/etc/persistence/esd/scripts/util_sysinfo.sh >$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt

echo >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
echo "Processes running on J5:" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
if [ -d /net/imx6 ]; then
	on -f J5 ps -Afl >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
	echo >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
	echo "Processes running on iMX6:" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
fi
ps -Afl >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt

echo >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
if [ -d /net/imx6 ]; then
	echo "Environment variables iMX6:" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
else
	echo "Environment variables J5:" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
fi
env >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt

echo >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
echo "aps info:" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
aps show >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt

echo >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
echo "**************** SLOGINFO J5 ****************" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
echo "*********************************************" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
if [ -d /net/imx6 ]; then
	on -f J5 sloginfo -t >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
	echo >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
	echo "*********************************************" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
	echo "*************** SLOGINFO iMX6 ***************" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
	echo "*********************************************" >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt
fi
sloginfo -t >>$VOLUME/dump/$TRAIN/$SERIAL/sysinfo.txt

sync

echo
echo "Done. The file can be found on $VOLUME"
echo "in /dump/$TRAIN/$SERIAL/sysinfo.txt"
exit 0