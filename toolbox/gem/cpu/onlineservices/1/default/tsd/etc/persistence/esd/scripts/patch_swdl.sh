#!/bin/ksh
export TOPIC=swdl
export MIBPATH=/tsd/bin/swdownload/tsd.mibstd2.system.swdownload
export SDPATH=$TOPIC/tsd.mibstd2.system.swdownload
export TYPE="file"

echo "This script will patch tsd.mibstd2.system.swdownload to"
echo "accept custom metainfo2.txt"
echo

size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)
sys=$(uname -m)

echo "Checking $MIBPATH..."
set -A bytes 07 EA EA 07
case $size in
	2949116) #cpu EU PQ 138
		set -A offsets C88D4 C9DC3 C9EDB 
		set -A bytes 07 EA EA ;;
	2950532) #cpu EU ZR 140
		set -A offsets C88D4 C9DC3 C9EDB 13D270 ;;
	3128116|3128084|3128124) #cpu PQ/ZR EU/US 241/245/253
		set -A offsets A9B1C ABAC7 ABBBF 14E190 ;;
	3084644|3084684) #cpuplus EU ZR/US PQ 253
		set -A offsets A91F4 AB19F AB297 14CBB4 ;;
	3105260|3104884|3105164|3105188|3105500|3105572|3106676|3106276|3104900|3108028) #cpu CN/US/EU PQ/ZR 346/356/361/363/367/368/369
		set -A offsets A9A64 ABA37 ABAF3 14EBDC ;;
	3061668|3062284|3062348|3063452|3061684) #cpuplus US/EU PQ/ZR 363/368/369
		set -A offsets A9214 AB1E7 AB2A3 14D6D8 ;;
	3107004) #cpu US PQ/ZR 367
		set -A offsets A9A64 ABA34 ABAEF 14EBD8 ;;
	3063780) #cpuplus US PQ/ZR 367
		set -A offsets A9214 AB1E4 AB29F 14D6D4 ;;
	3107820|3108412|3108516|3108180|3110212) #cpu CN/EU/US PQ/ZR 449/478/479
		set -A offsets A9A64 ABA37 ABAF3 14EBD4 ;;
	3065228|3066612|3065324) #cpuplus EU/US PQ/ZR 478/479/516
		set -A offsets A9234 AB207 AB2C3 14D6F0 ;;
	3109772|3109788) #cpu EU ZR 515/516
		set -A offsets A9A5C ABA2F ABAEB 14EBCC ;;
	3110500) #cpu EU PQ 604
		set -A offsets A9A94 ABA67 ABB23 14EB0C ;;	
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