#!/bin/ksh
echo "This script dumps eMMC chip content. Make sure SD card or"
echo "USB drive is formatted in exFAT/NTFS as FAT32 has 4 GB limit."
echo

# Locate Toolbox
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

cp $VOLUME/toolbox/utils/dd /tmp/
chmod 777 /tmp/dd

if [ ! -d "$VOLUME/dump/$VERSION/$SERIAL" ]; then
	echo "Creating dump folder..."
	mkdir -p $VOLUME/dump/$VERSION/$SERIAL
fi

if [[ -n "$(mount|grep $VOLUME|grep fat32)" ]]; then
	echo "ERROR: Please use exFAT or NTFS formatted SD card/USB drive!"
	exit 0
fi

OUT=$VOLUME/dump/$VERSION/$SERIAL/emmc.img
EMMC_SIZE=$(df /dev/hd0 | awk '{printf "%d",$2*512 }' 2>/dev/null)
echo "eMMC size is $(df /dev/hd0|awk '{printf "%.2f",$2*512/1024/1024/1024}' 2>/dev/null) GB. Dumping to:"
echo "/dump/$VERSION/$SERIAL/emmc.img"
echo "It will take some time. Please wait..."
start=`date -t`
/tmp/dd if=/dev/hd0 of=${OUT} bs=524288 &
LAST_SIZE=""
while [ -n "$(ps -A|grep dd)" ]; do
	IMG_SIZE=$(ls -l ${OUT} | awk '{print $5}' 2>/dev/null)
	if [ -n "$LAST_SIZE" ]; then
		awk -v E="$EMMC_SIZE" -v B="$IMG_SIZE" -v L="$LAST_SIZE" 'BEGIN{printf "%d%% done, %d MB left, speed %.2f MB/s\n",B/E*100,(E-B)/1024/1024,(B-L)/30/1024/1024}' 2>/dev/null
	fi
	LAST_SIZE=$IMG_SIZE
	sleep 30
done

rm -f /tmp/dd
sync
end=`date -t`
echo
echo "Done. Time spent: $(((end-start)/60)) minutes."
exit 0