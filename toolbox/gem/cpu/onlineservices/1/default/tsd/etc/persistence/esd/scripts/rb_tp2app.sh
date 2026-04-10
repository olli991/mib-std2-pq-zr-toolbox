#!/bin/ksh
export TOPIC=buttons
export MIBPATH=/tsd/hmi/HMI/res/configurationmanager.res
export SDPATH=$TOPIC/configurationmanager.res
export TYPE="file"

echo "Remapping TP to APP button..."
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh
echo "ID: $TRAIN $SYS"

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Size of the file to patch
size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)

echo "Checking $MIBPATH..."
set -A bytes 72 57
offsets=""

case $size in
	67854) #MST2_EU_XX_ZR_P0480T cpuplus
		set -A offsets 8A74 8CA4 ;;
	78070) #MST2_EU_XX_ZR_P0480T cpu
		set -A offsets A87E AAAE ;;
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
	else
		echo "Patching failed!"
	fi
else
	echo "Unknown file size $size detected."
fi
exit 0