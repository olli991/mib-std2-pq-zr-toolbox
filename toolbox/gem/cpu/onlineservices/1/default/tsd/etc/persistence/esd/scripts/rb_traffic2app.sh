#!/bin/ksh
export TOPIC=buttons
export MIBPATH=/tsd/hmi/HMI/res/configurationmanager.res
export SDPATH=$TOPIC/configurationmanager.res
export TYPE="file"

echo "Remapping TRAFFIC to APP button..."
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh
echo "ID: $TRAIN $SYS"

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Size of the file to patch
size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)

echo "Checking $MIBPATH..."
set -A bytes 72 05
offsets=""

case $size in
	59520) #MST2_EU_SK_ZR_P0369T cpuplus
		set -A offsets 7BCC 82B0 ;;
	68446) #MST2_EU_XX_PQ_P0361T cpu
		set -A offsets 9A96 A17A ;;
	68382) #MST2_EU_XX_ZR_P0363/369T cpu
		set -A offsets 9A56 A13A ;;
	77892) #MST2_CN_XX_PQ_P0478T cpu
		set -A offsets A318 A9FC ;;
	78070) #MST2_EU_XX_ZR_P0480T cpu
		set -A offsets A3CA AAAE ;;
	78072) #MST2_EU_XX_ZR_P0468T cpu
		set -A offsets AA3C AAB0 ;;
	78098) #MST2_CN_SK_ZR_P0476T cpu
		set -A offsets A3E6 AACA ;;
	78200) #MST2_EU_VW_PQ_P0478/604T cpu
		set -A offsets A44C AB30 ;;
	78202) #MST2_EU_VW_PQ_P0480T cpu
		set -A offsets A44E AB32 ;;
	78254) #MST2_EU_VW_ZR_P0515/516T cpu
		set -A offsets A482 AB66 ;;
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