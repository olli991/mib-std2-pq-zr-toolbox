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
		if [ "$sys" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 2F197 2F530 2F531 2F532 2F533 391D8 41C7C
			set -A bytes EA 00 30 A0 E3 07 07
		else #cpuplus EU PQ 138
			set -A offsets 2F19B 2F534 2F535 2F536 2F537 391DC 41C80
			set -A bytes EA 00 30 A0 E3 07 07
		fi ;;		
	1194776) #cpu EU ZR 140
		if [ "$sys" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 33947 33D0C 33D0D 33D0E 33D0F 3C110 44BB4
			set -A bytes EA 00 30 A0 E3 07 07
		else #cpuplus EU ZR 140
			set -A offsets 3394B 33D10 33D11 33D12 33D13 3C114 44BB8
			set -A bytes EA 00 30 A0 E3 07 07
		fi ;;			
	1186460) #cpu EU PQ/ZR 245/253
		if [ "$sys" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 18430 1F160 4A2AB 4A673
			set -A bytes 07 07 EA EA
		else #cpuplus EU PQ/ZR 253
			set -A offsets 18434 1F164 4A2AF 4A677
			set -A bytes 07 07 EA EA
		fi ;;
	1166772) #cpu EU PQ 353
		set -A offsets 198F3 19CBB 2802C 2EFAC
		set -A bytes EA EA 07 07 ;;
	1163264) #cpu CN ZR 361
		set -A offsets 1864C 1F5D0 1F5D2 1F5D3 4033B 40703
		set -A bytes 07 00 A0 E3 EA EA ;;
	1164620) #cpu EU PQ 367
		set -A offsets 277F7 27BBF 3037C 372FC
		set -A bytes EA EA 07 07 ;;
	1166364) #cpu EU ZR 368
		set -A offsets 2861F 289E7 3113C 380BC
		set -A bytes EA EA 07 07 ;;
	1166356) #cpuplus EU PQ 369
		set -A offsets 249A0 2B920 4A1C3 4A58B
		set -A bytes 07 07 EA EA ;;		
	1166348) #cpu EU ZR 369
		set -A offsets 2499C 2B91C 4A1BF 4A587
		set -A bytes 07 07 EA EA ;;
	1167660) #cpu EU ZR 369
		set -A offsets 198EF 19CB7 3B674 425F4
		set -A bytes EA EA 07 07 ;;	
	1168924) #cpuplus EU ZR 369
		set -A offsets 23AFF 23EC7 3B34C 422CC
		set -A bytes EA EA 07 07 ;;
	1168916) #cpu EU ZR 369
		set -A offsets 23AFB 23EC3 3B348 422C8
		set -A bytes EA EA 07 07 ;;
	1170896) #cpu CN/US/EU PQ/ZR 478/479/480
		set -A offsets 1A4E8 21480 45A37 45DFF
		set -A bytes 07 07 EA EA ;;
	1170904) #cpuplus CN/US/EU PQ/ZR 478/479/480
		set -A offsets 1A4EC 21484 45A3B 45E03
		set -A bytes 07 07 EA EA ;;
	1170704|1171128) #cpu EU ZR 515/516
			set -A offsets 1A4E0 21478 45A2F 45DF7
			set -A bytes 07 07 EA EA ;;
	1171136) #cpuplus EU ZR 516
			set -A offsets 1A4E4 2147C 45A33 45DFB
			set -A bytes 07 07 EA EA ;;
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