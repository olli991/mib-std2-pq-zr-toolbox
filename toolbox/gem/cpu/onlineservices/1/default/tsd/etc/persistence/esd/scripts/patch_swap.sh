#!/bin/ksh
export TOPIC=swap
export MIBPATH=/tsd/bin/swap/tsd.mibstd2.system.swap
export SDPATH=$TOPIC/tsd.mibstd2.system.swap
export TYPE="file"

echo "This script will patch tsd.mibstd2.system.swap"
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh
if [[ "$TRAIN" = "----" ]]; then
	TRAIN=$MUVER
fi
echo "ID: $TRAIN $SYS"

# Size of the file to patch
size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)

echo "Checking $MIBPATH..."
set -A bytes 07 07 07 07
offsets=""

case $size in
	633660) #EU mainstd ZR 133
		set -A offsets 2776C 29F90 3344C 33784 ;;
	633580) #EU mainstd ZR 138
		set -A offsets 16B9C 16B9C 242F8 26B1C ;;
	633668) #EU mainstd ZR 140
		set -A offsets 25ABC 25DF4 32144 34968 ;;
	619040) #EU mainstd ZR 253/254
		set -A offsets 18018 18B8C 3248C 32764 ;;
	630184) #EU mainstd ZR 363
		set -A offsets 20978 20C50 2B030 2BBA4 ;;
	630416) #EU mainstd ZR 367
		set -A offsets 1E640 1F1B4 2D0CC 2D3A4 ;;
	630160) #EU mainstd ZR 361/369
		set -A offsets 1D184 1D45C 2E674 2F1E8 ;;
	630408) #EU mainstd ZR 369
		set -A offsets 1F370 1FEE4 3245C 32734 ;;
	631292) #EU mainstd ZR 475
		set -A offsets 1CE0C 1D0E4 2E9C8 2F53C ;;
	631548) #EU mainstd ZR 478/480
		set -A offsets 1AF98 1BB0C 2F7F4 2FACC ;;
	1196272) #EU ZR 125
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 2BC24 2BFC0 3CED0 45974
		fi ;;
	1196304) #EU PQ 135/136
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 28A84 31528 47C64 48000
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 28A88 3152C 47C68 48004
		fi ;;
	1197376) #EU PQ/ZR 131/137
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 2C778 3521C 4B73C 4BAD8
		fi ;;
	1197248) #EU PQ/ZR 138
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 2F164 2F500 391D8 41C7C
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 2F168 2F504 391DC 41C80
		fi ;;
	1197752) #EU ZR 138 v.37204
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 19D58 1A0F4 2336C 2BE10
		fi ;;
	1212544) #CN ZR 138
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 1281C 1A350 379D8 37D74
		fi ;;
	1212936) #RoA ZR 138
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 19924 19CC0 2E9F0 36524
		fi ;;
	1194776) #EU PQ/ZR 140
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 33940 33CDC 3C110 44BB4
		fi ;;
	1194784) #EU PQ/ZR 140
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 33944 33CE0 3C114 44BB8
		fi ;;
	1187364) #EU/US PQ/ZR 241/245/247/253/254
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 226AC 293DC 44D44 4510C
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 226B0 293E0 44D48 45110
		fi ;;
	1186460) #EU PQ/ZR 240/241/245/253/254
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 18430 1F160 4A2A4 4A66C
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 18434 1F164 4A2A8 4A670
		fi ;;
	1187340) #CN PQ 247/253
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 25894 2C5C4 44E88 45250
		fi ;;
	1186556) #RoW ZR 254
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 1E110 24E40 3CB3C 3CF04
		fi ;;
	1166772) #EU PQ/ZR 353/356/359/363
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 198E8 19CB0 28028 2EFA8
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 198EC 19CB4 2802C 2EFAC
		fi ;;
	1165412) #RoW ZR 359
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 26A1C 2D99C 49928 49CF0
		fi ;;
	1168644) #EU ZR 359/363
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 198E8 19CB0 3BFD4 42F54
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 198EC 19CB4 3BFD8 42F58
		fi ;;
	1163264) #CN ZR 361
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 1864C 1F5CC 40334 406FC
		fi ;;
	1164620) #EU ZR 346/351 PQ/ZR 363/367/368/370
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			case "$TRAIN" in
				*0346*|*0351*) #ZR 346/351
					set -A offsets 20BBC 27B3C 42C0C 42FD4 ;;
				*0363*|*0367*|*0368*|*0370*|*0478*) #PQ/ZR 363/367/368/478
					set -A offsets 277F0 27BB8 3037C 372FC ;;
			esac
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			case "$TRAIN" in
				*0346*|*0351*) #ZR/PQ 346/351
					set -A offsets 20BC0 27B40 42C10 42FD8 ;;
				*0363*|*0367*|*0368*|*0478*) #PQ/ZR 363/367/368/478
					set -A offsets 277F4 27BBC 30380 37300 ;;
			esac
		fi ;;
	1165100) #CN PQ 367
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 20310 206D8 3B18C 4210C
		fi ;;
	1166380) #EU/US PQ/ZR 357/359/367
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 26AD4 26E9C 3B15C 420DC
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 26AD8 26EA0 3B160 420E0
		fi ;;	
	1166364) #EU ZR 368
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 28618 289E0 3113C 380BC
		fi ;;
	1166348) #EU PQ/ZR 140/367/369/478/604
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			case "$TRAIN" in
				*0367*) #PQ/ZR 367
					set -A offsets 1FB74 26AF4 42AAC 42E74 ;;
				*0140*|*0369*|*0370*|*04*) #ZR 140/369/480 17206, PQ 478/604 17217
					set -A offsets 2499C 2B91C 4A1B8 4A580 ;;
			esac
		fi ;;
	1166356) #EU PQ/ZR 367/369
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			case "$TRAIN" in
				*0367*) #PQ/ZR 367
					set -A offsets 1FB78 26AF8 42AB0 42E78 ;;
				*0369*) #PQ/ZR 369
					set -A offsets 249A0 2B920 4A1BC 4A584 ;;
			esac
		fi ;;
	1167660) #EU ZR 369
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 198E8 19CB0 3B674 425F4
		fi ;;
	1167668) #EU PQ 369
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 198EC 19CB4 3B678 425F8
		fi ;;
	1168932) #EU PQ/ZR 359
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 28AA8 28E70 314D0 38450
		fi ;;
	1168924) #EU PQ/ZR 353/359/360/363/366/369
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			case "$TRAIN" in
				*0353*) #PQ 353
					set -A offsets 314CC 38453 ;;
				*0359*|*0360*|*0361*|*0363*|*0366*|*0480*|'') #ZR 359/360/361/366, PQ 363
					set -A offsets 28AA4 28E6C 314CC 3844C ;;
			esac
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			case "$TRAIN" in
				*0369*) #PQ/ZR 369
					set -A offsets 23AF8 23EC0 3B34C 422CC ;;
			esac
		fi ;;
	1168916) #EU ZR 369
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 23AF4 23EBC 3B348 422C8
		fi ;;
	1170872) #EU PQ 431
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 1A4E0 2147F
		fi ;;
	1169168) #EU RoW PQ/ZR 448/475
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 2C048 32FE0 496F4 49ABC
		fi ;;
	1168208) #EU PQ/ZR 449/475
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 230D0 23498 37890 3E828
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 230D4 2349C 37894 3E82C
		fi ;;
	1168104) #CN PQ/ZR 469/472/475/478
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 22F88 23350 2F9E0 36978
		fi ;;
	1168608) #US PQ 478
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 12E38 19DD0 364BC 36884
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 12E3C 19DD4 364C0 36888
		fi ;;
	1167920) #RoW PQ 478
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 21D54 34AB0 3BA48
		fi ;;
	1170472) #EU ZR 462
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 1AAB8 1AE80 2EA4C 359E4
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 1AABC 1AE84 2EA50 359E8
		fi ;;
	1170896) #CN/US/EU PQ/ZR 468/472/478/479/480
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 1A4E8 21480 45A30 45DF8
		fi ;;
	1170912) #US PQ 447/468
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 2CB54 33AEC 4A198 4A560
		fi ;;
	1170920) #US PQ 447/468
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 2CB58 33AF0 4A19C 4A564
		fi ;;
	1170904) #CN/US/EU PQ/ZR 468/478/479/480
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 1A4EC 21484 45A34 45DFC
		fi ;;
	1170704) #EU ZR 515
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 1AAB0 1AE78 2EA44 359DC
		elif [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 1AAB4 1AE7C 2EA48 359E0
		fi ;;
	1171128) #cpu EU ZR 516
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 1A4E0 21478 45A28 45DF0
		fi ;;
	1171136) #EU ZR 516
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 1A4E4 2147C 45A2C 45DF4
		fi ;;
	1173048) #EU PQ 604
		if [ "$SYS" = "i.MX6_MIBSTD2_CPU_Board" ]; then
			set -A offsets 19990 19D58 23B20 2AAB8
		fi ;;
	1173056) #cpuplus EU PQ 604
		if [ "$SYS" = "i.MX6_MIBSTD2PLUS_CPU_Board" ]; then
			set -A offsets 19994 19D5C 23B24 2AABC
		fi ;;
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
		echo "Creating Exception List..."
		
		mv $fout $MIBPATH
		chmod 777 $MIBPATH
		
		[ ! -d "/tsd/etc/slist" ] && mkdir -p "/tsd/etc/slist"

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