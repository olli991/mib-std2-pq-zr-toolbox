#!/bin/ksh
echo "This script saves system info to sysinfo.txt"
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
. /tsd/etc/persistence/esd/scripts/sysinfo.sh >$VOLUME/dump/$VERSION/$SERIAL/sysinfo.txt

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
echo "Done. The file can be found at:"
echo "/dump/$VERSION/$SERIAL/sysinfo.txt"
exit 0