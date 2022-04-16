#!/bin/ksh
export TOPIC=swap
export MIBPATH=/tsd/bin/swap/tsd.mibstd2.system.swap
export SDPATH=$TOPIC/tsd.mibstd2.system.swap
export TYPE="file"

echo "This script will patch tsd.mibstd2.system.swap"
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

# Size of the file to patch
size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)

echo "Checking $MIBPATH..."
set -A bytes 07 07 07 07
case $size in
	1197376) #cpu EU ZR 137
		set -A offsets 2C778 3521C 4B73C 4BAD8 ;;
	1197248) #cpu EU PQ 138
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 2F164 2F500 391D8 41C7C
		else #cpuplus EU PQ 138
			set -A offsets 2F168 2F504 391DC 41C80
		fi ;;
	1194776) #cpu EU ZR 140
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 33940 33CDC 3C110 44BB4
		else #cpuplus EU ZR 140
			set -A offsets 33944 33CE0 3C114 44BB8
		fi ;;
	1187364) #cpu US PQ/ZR 245/253
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 226AC 293DC 44D44 4510C
		else #cpuplus EU PQ/ZR 253
			set -A offsets 226B0 293E0 44D48 45110
		fi ;;		
	1186460) #cpu EU PQ/ZR 245/253
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 18430 1F160 4A2A4 4A66C
		else #cpuplus EU PQ/ZR 253
			set -A offsets 18434 1F164 4A2A8 4A670
		fi ;;
	1166380) #cpu US ZR 367
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 26AD4 26E9C 3B15C 420DC
		else #cpuplus EU ZR 367
			set -A offsets 26AD8 26EA0 3B160 420E0
		fi ;;	
	1166772) #cpu EU ZR 356
		if [ "$TRAIN" = "MST2_EU_VW_ZR_P0356T" ]; then
			set -A offsets 198E8 19CB0 28028 2EFA8
		else #cpu EU PQ 353
			set -A offsets 198EC 19CB4 2802C 2EFAC
		fi ;;
	1168644) #cpu EU ZR 359
		set -A offsets 198E8 19CB0 3BFD4 42F54 ;;
	1163264) #cpu CN ZR 361
		set -A offsets 1864C 1F5D3 4033B 40703
		set -A bytes 07 E3 EA EA ;;
	1164620) #cpu EU ZR 346
		if [ "$TRAIN" = "MST2_EU_SE_ZR_P0346T" ]; then
			set -A offsets 20BBC 27B3C 42C0C 42FD4
		else #cpu EU PQ 363
			set -A offsets 277F0 27BB8 3037C 372FC
		fi ;;
	1165100) #cpu CN PQ 367
		set -A offsets 20310 206D8 3B18C 4210C ;;
	1166364) #cpu EU ZR 368
		set -A offsets 2861F 289E7 3113C 380BC
		set -A bytes EA EA 07 07 ;;
	1166348) #cpu EU ZR 369
		set -A offsets 2499C 2B91C 4A1B8 4A580 ;;
	1166356) #cpuplus EU PQ 369
		set -A offsets 249A0 2B920 4A1BC 4A584 ;;
	1167660) #cpu EU ZR 369
		set -A offsets 198E8 19CB0 3B674 425F4 ;;
	1168924) #cpuplus EU ZR 369
		set -A offsets 23AF8 23EC0 3B34C 422CC ;;
	1168916) #cpu EU ZR 369
		set -A offsets 23AF4 23EBC 3B348 422C8 ;;
	1168208) #cpu EU PQ 449
		set -A offsets 230D0 23498 37890 3E828 ;;
	1168104) #cpu CN PQ 478
		set -A offsets 22F88 23350 2F9E0 36978 ;;
	1170896) #cpu CN/US/EU PQ/ZR 478/479/480
		set -A offsets 1A4E8 21480 45A30 45DF8 ;;
	1170904) #cpuplus CN/US/EU PQ/ZR 478/479/480
		set -A offsets 1A4EC 21484 45A34 45DFC ;;
	1170704) #cpu EU ZR 515
		set -A offsets 1AAB0 1AE78 2EA44 359DC ;;
	1171128) #cpu EU ZR 516
		set -A offsets 1A4E0 21478 45A28 45DF0 ;;
	1171136) #cpuplus EU ZR 516
		set -A offsets 1A4E4 2147C 45A2C 45DF4 ;;
	1173048) #cpu EU PQ 604
		set -A offsets 19997 19D5F 23B20 2AAB8
		set -A bytes EA EA 07 07 ;;
	*)
		offsets="" ;;
esac

if [ -n "$offsets" ]; then
	fin=$MIBPATH
	j=0
	for i in ${offsets[@]}; do
		fh=$((16#$i))
		echo "Patching offset 0x$i ${bytes[j]}"
		fout="/tmp/tsd.mibstd2.system.swap$j"
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
		
		mv $fout $MIBPATH
		chmod 777 $MIBPATH

		echo "YD?-00???.??.1?????????" >/tsd/etc/slist/signed_exception_list.txt
		echo "YD5-?????.??.??????????" >>/tsd/etc/slist/signed_exception_list.txt
		echo "YD7-?????.??.??????????" >>/tsd/etc/slist/signed_exception_list.txt
		echo >>/tsd/etc/slist/signed_exception_list.txt
		echo "[SupportedFSC]" >>/tsd/etc/slist/signed_exception_list.txt
		echo >>/tsd/etc/slist/signed_exception_list.txt
		echo "[Signature]" >> /tsd/etc/slist/signed_exception_list.txt
		echo 'signature1 = "00000000000000000000000000000000"' >>/tsd/etc/slist/signed_exception_list.txt
		echo 'signature2 = "00000000000000000000000000000000"' >>/tsd/etc/slist/signed_exception_list.txt
		echo 'signature3 = "00000000000000000000000000000000"' >>/tsd/etc/slist/signed_exception_list.txt
		echo 'signature4 = "00000000000000000000000000000000"' >>/tsd/etc/slist/signed_exception_list.txt
		echo 'signature5 = "00000000000000000000000000000000"' >>/tsd/etc/slist/signed_exception_list.txt
		echo 'signature6 = "00000000000000000000000000000000"' >>/tsd/etc/slist/signed_exception_list.txt
		echo 'signature7 = "00000000000000000000000000000000"' >>/tsd/etc/slist/signed_exception_list.txt
		echo 'signature8 = "00000000000000000000000000000000"' >>/tsd/etc/slist/signed_exception_list.txt

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