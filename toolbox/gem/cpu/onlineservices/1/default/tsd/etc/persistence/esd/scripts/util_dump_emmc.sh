#!/bin/ksh
echo "This script dumps eMMC chip content. Make sure SD card or"
echo "USB drive is formatted in exFat/NTFS as FAT32 has 4Gb limit."
echo

# Locate Toolbox
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

cp $VOLUME/toolbox/utils/dd /tmp/
chmod 777 /tmp/dd

if [ ! -d "$VOLUME/dump/$VERSION/$SERIAL" ]; then
	echo "Creating backup folder..."
	mkdir -p $VOLUME/dump/$VERSION/$SERIAL
fi

echo "Dumping eMMC content to:"
echo "$VOLUME/dump/$VERSION/$SERIAL/emmc.img"
echo "It will take some time. Please wait..."
/tmp/dd if=/dev/hd0 of=$VOLUME/dump/$VERSION/$SERIAL/emmc.img
rm -f /tmp/dd
sync
echo
echo "Done."