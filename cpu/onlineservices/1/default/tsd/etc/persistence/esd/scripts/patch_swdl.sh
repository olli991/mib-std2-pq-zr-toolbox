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
echo "ID: $TRAIN $SYS"

# Size of the file to patch
size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)

echo "Checking $MIBPATH..."
set -A bytes 07 07 07 07
offsets=""

case $size in
	1484196|1484084|1484164) #mainstd EU ZR 133/138/140
		set -A offsets 7EAC4 7F668 7FBDC ;;
	1541236) #mainstd EU ZR 253/254
		set -A offsets 6EE80 72328 72A4C BE660 ;;
	1562016|1562024|1562036|1562060) #mainstd EU ZR 361/363/367/369
		set -A offsets 6F8E4 73718 73E44 BF534 ;;
	1562772) #mainstd EU ZR 475/478/480
		set -A offsets 6F8D0 73704 73E30 BF518 ;;
	2949116|2950228|2949516|2951292|2950532) #cpu EU PQ/ZR 125/131/136/137/138/140
		set -A offsets C88D4 C9DBC C9ED4 ;;
	2909244|2908844|2909916|2910260) #cpuplus EU PQ/ZR 135/138/140
		set -A offsets C83A4 C988C C99A4 ;;
	2986892) #cpuplus RoA ZR 138
		set -A offsets C55B4 C6A9C C6BB4 ;;
	3020964) #cpu CN ZR 138
		set -A offsets C41E4 C56CC C57E4 ;;
	3128116|3128076|3128084|3128124|3130452) #cpu EU/US/CN PQ/ZR 240/241/245/247/253/254
		set -A offsets A9AF8 ABAC0 ABBB8 14E190 ;;
	1490944|3084636|3084676|3084644|3084684|3084668) #cpuplus EU/US/RoW PQ/ZR 240/241/245/247/253/254
		set -A offsets A91D0 AB198 AB290 14CBB4 ;;
	3105260|3104884|3105164|3105188|3105500|3105572|3106644|3106988|3106676|3106276|3107004|3104900|3108028) #cpu EU/US/CN PQ/ZR 140/346/353/356/357/359/360/361/363/366/367/368/369/370/472/480/604
		set -A offsets A9A40 ABA30 ABAEC 14EBDC ;;
	3064812|3061668|3062284|3062348|3063452|3063780|3061684|3063764|3061948|3063420|3062004) #cpuplus EU/RoW/US PQ/ZR 351/359/363/367/368/369
		set -A offsets A91F0 AB1E0 AB29C 14D6D8 ;;
	3109476) #cpu EU PQ 431
		set -A offsets A9A38 14EBE4 ;;
	3107820|3108412|3109596|3108516|3108180|3109620|3110212) #cpu EU/US/CN PQ/ZR 447/449/462/468/469/472/475/478/479/480
		set -A offsets A9A40 ABA30 ABAEC 14EBD4 ;;
	3065228|3067460|3067020|3065324|3066404|3066596|3066612|3064636|3066428) #cpuplus EU/US/RoW PQ/ZR 447/448/449/462/468/475/478/479/480/515/516
		set -A offsets A9210 AB200 AB2BC 14D6F0 ;;
	3109772|3109788) #cpu EU ZR 515/516
		set -A offsets A9A38 ABA28 ABAE4 14EBCC ;;
	3110500) #cpu EU PQ 604
		set -A offsets A9A70 ABA60 ABB1C 14EB0C ;;
	3067324) #cpuplus EU PQ 604
		set -A offsets A9240 AB230 AB2EC 14D628 ;;
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