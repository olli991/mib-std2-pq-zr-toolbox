#!/bin/ksh
export TOPIC=buttons
export MIBPATH=/tsd/hmi/HMI/res/configurationmanager.res
export SDPATH=$TOPIC/configurationmanager.res
export TYPE="file"

echo "Remapping VOICE to MUTE button..."
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh
echo "ID: $TRAIN $SYS"

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Size of the file to patch
size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)

echo "Checking $MIBPATH..."
set -A bytes 58 32
offsets=""

case $size in
	68382) #MST2_EU_SK_ZR_P0369T cpu
		set -A offsets 9E16 9F3A ;;
esac

if [ -n "$offsets" ]; then
	fin=$MIBPATH
	j=0
	for i in ${offsets[@]}; do
		fh=$((16#$i))
		echo "Patching offset 0x$i ${bytes[j]}"
		fout="/tmp/configurationmanager$j"
		(head -c $fh $fin; awk -v byte="\x${bytes[j]}" 'BEGIN{printf(byte)}' 2>/dev/null;tail -c +$(($fh+2)) $fin) > $fout
		if [ $j -gt 0 ]; then
			rm $fin
		fi
		fin=$fout
		j=$((j+1))
	done
	
	if [ -f "$fout" ]; then
		# Mount system partition in read/write mode
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		echo "Setting file permissions..."
		
		mv -f $fout $MIBPATH
		chmod 777 $MIBPATH
		
		# Mount system partition in read/only mode
		. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
		echo "Patch is applied. Please restart the unit."
		echo "IMPORTANT! In coding of block 5F byte 24, set bit1=0"
	else
		echo "Patching failed!"
	fi
else
	echo "Unknown file size $size detected."
fi
exit 0