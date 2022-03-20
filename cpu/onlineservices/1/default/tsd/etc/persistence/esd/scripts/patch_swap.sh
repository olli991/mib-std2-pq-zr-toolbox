#!/bin/ksh
export TOPIC=swap
export MIBPATH=/tsd/bin/swap/tsd.mibstd2.system.swap
export SDPATH=$TOPIC/tsd.mibstd2.system.swap
export TYPE="file"

echo "This script will patch tsd.mibstd2.system.swap"
echo

size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)
sys=$(uname -m)

echo "Checking $MIBPATH..."
case $size in
	1197248) #cpu EU PQ 138
		set -A offsets 2F190 2F191 2F192 2F197 2F52C 2F52D 2F52E 2F533 391D8 41C7C
		set -A bytes 01 30 A0 EA 01 30 A0 EA 07 07 ;;
	1186460) #cpu EU PQ/ZR 253
		if [ "$sys" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 18430 1F160 4A2A4 4A2A6 4A2AB 4A66C 4A66D 4A66E 4A673 6AF64
			set -A bytes 07 07 01 A0 EA 01 40 A4 EA 07
		else #cpuplus EU PQ/ZR 253
			set -A offsets 18434 1F164 4A2A8 4A2AA 4A2AF 4A670 4A671 4A672 4A677 6AF68
			set -A bytes 07 07 01 A0 EA 01 40 A4 EA 07
		fi ;;
	1166772) #cpu EU PQ 353
		set -A offsets 198EC 198EE 198F3 19CB4 19CB5 19CB6 19CBB 2EFB3
		set -A bytes 01 A0 EA 01 40 A4 EA 1A ;;
	1166364) #cpu EU ZR 368
		set -A offsets 28618 2861A 2861F 289E0 289E1 289E2 289E7 3113C 380BC
		set -A bytes 01 A0 EA 01 40 A4 EA 07 07 ;;
	1166356) #cpuplus EU PQ 369
		set -A offsets 249A0 2B920 4A1BC 4A1BE 4A1C3 4A584 4A585 4A586 4A58B
		set -A bytes 07 07 01 A0 EA 01 40 A4 EA ;;		
	1166348) #cpu EU ZR 369
		set -A offsets 2499C 2B91C 4A1B8 4A1BA 4A1BF 4A580 4A581 4A582 4A587
		set -A bytes 07 07 01 A0 EA 01 40 A4 EA ;;
	1167660) #cpu EU ZR 369
		set -A offsets 198E8 198EA 198EF 19CB0 19CB1 19CB2 19CB7 3B674 425F4
		set -A bytes 01 A0 EA 01 40 A4 EA 07 07 ;;	
	1168924) #cpuplus EU ZR 369
		set -A offsets 23AF8 23AFA 23AFF 23EC0 23EC1 23EC2 23EC7 3B34C 422CC
		set -A bytes 01 A0 EA 01 40 A4 EA 07 07 ;;
	1168916) #cpu EU ZR 369
		set -A offsets 23AF4 23AF6 23AFB 23EBC 23EBD 23EBE 23EC3 3B348 422C8
		set -A bytes 01 A0 EA 01 40 A4 EA 07 07 ;;
	1170896) #cpu CN/US/EU PQ/ZR 478/479/480
		set -A offsets 1A4E8 21480 45A30 45A32 45A37 45DF8 45DF9 45DFA 45DFF
		set -A bytes 07 07 01 A0 EA 01 40 A4 EA ;;
	1170904) #cpuplus CN/US/EU PQ/ZR 478/479/480
		set -A offsets 1A4EC 21484 45A34 45A36 45A3B 45DFC 45DFD 45DFE 45E03
		set -A bytes 07 07 01 A0 EA 01 40 A4 EA ;;
	1170704) #cpu EU ZR 516
			set -A offsets 1A4E0 21478 45A28 45A2A 45A2F 45DF0 45DF1 45DF2 45DF7
			set -A bytes 07 07 01 A0 EA 01 40 A4 EA ;;
	1171136) #cpu+ EU ZR 516
			set -A offsets 1A4E4 2147C 45A2C 45A2E 45A33 45DF4 45DF5 45DF6 45DFB
			set -A bytes 07 07 01 A0 EA 01 40 A4 EA ;;
	1173048) #cpu EU PQ 604
			set -A offsets 19990 19992 19997 19D58 19D59 19D5A 19D5F 23B20 2AAB8
			set -A bytes 07 07 01 A0 EA 01 40 A4 EA ;;
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