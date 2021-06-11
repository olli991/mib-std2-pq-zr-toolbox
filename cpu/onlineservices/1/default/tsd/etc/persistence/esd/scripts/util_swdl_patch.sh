#!/bin/ksh
export TOPIC=swdl
export MIBPATH=/tsd/bin/swdownload/tsd.mibstd2.system.swdownload
export SDPATH=$TOPIC/tsd.mibstd2.system.swdownload
export TYPE="file"

echo "This script will patch tsd.mibstd2.system.swdownload to"
echo "accept custom metainfo2.txt"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh 

file="/tsd/bin/swdownload/tsd.mibstd2.system.swdownload"
size=$(ls -l $file | awk '{print $5}' 2>/dev/null)

echo "Checking $file..."
case $size in
	3128084) #cpu EU ZR 253
		set -A offsets A9B1C ABAC7 ABBBF 14E190 ;;
	3084644) #cpuplus EU ZR 253
		set -A offsets A91F4 AB19F AB297 14CBB4 ;;
	3104884|3107004|3105500|3105572) #cpu US/EU PQ/ZR 363/367/368
		set -A offsets A9A64 ABA37 ABAF3 14EBDC ;;
	3061668|3063780|3062284|3062348) #cpuplus US/EU PQ/ZR 363/367/368
		set -A offsets A9214 AB1E7 AB2A3 14D6D8 ;;
	3108412) #cpu EU PQ/ZR 478/479
		set -A offsets A9A64 ABA37 ABAF3 14EBD4 ;;
	3065228) #cpuplus EU PQ/ZR 478/479
		set -A offsets A9234 AB207 AB2C3 14D6F0 ;;
	*)
		offsets="" ;;
esac

if [ -n $offsets ]; then
	mount -t qnx6 -o remount,rw /dev/hd0t177 /
	fin=$file
	set -A bytes 07 EA EA 07
	j=0
	for i in ${offsets[@]}; do
		fh=$((16#$i))
		echo "Patching offset 0x$i ${bytes[j]}"
		fout="/tmp/tsd.mibstd2.system.swdownload$j"
		(head -c $fh $fin; awk -v byte="\x${bytes[j]}" 'BEGIN{printf(byte)}' 2>/dev/null;tail -c +$(($fh+2)) $fin) > $fout
		if [ $j -gt 0 ]; then
			rm $fin
		fi
		fin=$fout
		j=$((j+1))
	done
	mv -f $fout $file
	chmod 777 $file
	sync
	mount -t qnx6 -o remount,ro /dev/hd0t177 /
	echo "Patch is applied. Please restart the unit."
else
	echo "Unknown $file version detected."
fi
exit 0