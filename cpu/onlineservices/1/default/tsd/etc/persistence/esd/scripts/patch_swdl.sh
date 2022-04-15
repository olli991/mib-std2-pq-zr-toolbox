#!/bin/ksh
export TOPIC=swdl
export MIBPATH=/tsd/bin/swdownload/tsd.mibstd2.system.swdownload
export SDPATH=$TOPIC/tsd.mibstd2.system.swdownload
export TYPE="file"

echo "This script will patch tsd.mibstd2.system.swdownload to"
echo "accept custom metainfo2.txt"
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

# Size of the file to patch
size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)

echo "Checking $MIBPATH..."
set -A bytes 07 07 07 07
case $size in
	2949116|2951292|2950532) #cpu EU PQ/ZR 137/138/140
		set -A offsets C88D4 C9DBC C9ED4 ;;
	3128116|3128084|3128124) #cpu PQ/ZR EU/US 241/245/253
		set -A offsets A9AF8 ABAC0 ABBB8 14E190 ;;
	3084644|3084684) #cpuplus EU ZR/US PQ 253
		set -A offsets A91D0 AB198 AB290 14CBB4 ;;
	3105260|3104884|3105164|3105188|3105500|3105572|3106676|3106276|3104900|3108028) #cpu CN/US/EU PQ/ZR 346/356/359/361/363/367/368/369
		set -A offsets A9A40 ABA30 ABAEC 14EBDC ;;
	3061668|3062284|3062348|3063452|3061684) #cpuplus US/EU PQ/ZR 363/368/369
		set -A offsets A91F0 AB1E0 AB29C 14D6D8 ;;	
	3107004) #cpu US PQ/ZR 367
		set -A offsets A9A40 ABA2D ABAE8 14EBD8 ;;
	3063780) #cpuplus US PQ/ZR 367
		set -A offsets A9214 AB1DD AB298 14D6D4 ;;
	3107820|3108412|3108516|3108180|3110212) #cpu CN/EU/US PQ/ZR 449/478/479/480
		set -A offsets A9A40 ABA30 ABAEC 14EBD4 ;;
	3065228|3066612|3065324) #cpuplus EU/US PQ/ZR 478/479/480/516
		set -A offsets A9234 AB200 AB2BC 14D6F0 ;;
	3109772|3109788) #cpu EU ZR 515/516
		set -A offsets A9A38 ABA28 ABAE4 14EBCC ;;
	3110500) #cpu EU PQ 604
		set -A offsets A9A94 ABA60 ABB1C 14EB0C ;;	
	*)
		offsets="" ;;
esac

if [ -n "$offsets" ]; then
	fin=$MIBPATH
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
	
	if [ -f "$fout" ]; then
		# Make backup folder
		. /tsd/etc/persistence/esd/scripts/util_backup.sh 

		# Mount system partition in read/write mode
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		
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