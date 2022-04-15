#!/bin/ksh
export TOPIC=cp
export MIBPATH=/net/J5/tsd/bin/audio/tsd.mibstd2.audio.audiomgr
export SDPATH=$TOPIC/tsd.mibstd2.audio.audiomgr
export TYPE="file"

echo "This script will patch CP check"
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

# Size of the file to patch
size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)

echo "Checking $MIBPATH..."
set -A bytes 1E FF 2F E1 1E FF 2F E1
case $size in
	1851273) #EU PQ 138
		set -A offsets 1430B8 1430B9 1430BA 1430BB 143154 143155 143156 143157 ;;
	1850369) #EU ZR 140
		set -A offsets 142D2C 142D2D 142D2E 142D2F 142DC8 142DC9 142DCA 142DCB ;;
	1919783) #EU PQ 245
		set -A offsets 1513B0 1513B1 1513B2 1513B3 151448 151449 15144A 15144B ;;		
	1923559) #EU ZR 252
		set -A offsets 151E74 151E75 151E76 151E77 151F0C 151F0D 151F0E 151F0F ;;
	1921551) #EU PQ 252
		set -A offsets 1519D0 1519D1 1519D2 1519D3 151A68 151A69 151A6A 151A6B ;;
	2186198) #EU ZR 346
		set -A offsets 15CC90 15CC91 15CC92 15CC93 15CD24 15CD25 15CD26 15CD27 ;;
	2187958) #EU PQ 353
		set -A offsets 15D2B8 15D2B9 15D2BA 15D2BB 15D34C 15D34D 15D34E 15D34F ;;
	2187950) #EU ZR 356
		set -A offsets 15D2B0 15D2B1 15D2B2 15D2B3 15D344 15D345 15D346 15D347 ;;
	2189718) #EU PQ 359
		set -A offsets 15D8C8 15D8C9 15D8CA 15D8CB 15D95C 15D95D 15D95E 15D95F ;;
	2186470) #EU ZR 359
		set -A offsets 15CD70 15CD71 15CD72 15CD73 15CE04 15CE05 15CE06 15CE07 ;;
	2186303) #CN PQ/ZR 361/367
		set -A offsets 15CCEC 15CCED 15CCEE 15CCEF 15CD80 15CD81 15CD82 15CD83 ;;
	2188047) #EU ZR 367
		set -A offsets 15D30D 15D30E 15D30F 15D310 15D3A0 15D3A1 15D3A2 15D3A3 ;;
	2186574) #EU ZR 368
		set -A offsets 15CDD4 15CDD5 15CDD6 15CDD7 15CE68 15CE69 15CE6A 15CE6B ;;
	2194246) #EU PQ 369
		set -A offsets 15E018 15E019 15E01A 15E01B 15E0AC 15E0AD 15E0AE 15E0AF ;;
	2195751) #cpu EU PQ 369
		set -A offsets 15E550 15E551 15E552 15E553 15E5E4 15E5E5 15E5E6 15E5E7 ;;
	2195759) #cpuplus EU PQ 369
		set -A offsets 15E558 15E559 15E55A 15E55B 15E5EC 15E5ED 15E5EE 15E5EF ;;
	2198694) #CN PQ 478
		set -A offsets 15F108 15F109 15F10A 15F10B 15F19C 15F19D 15F19E 15F19F ;;
	2201779) #CN PQ 478
		set -A offsets 161294 161295 161296 161297 161328 161329 16132A 16132B ;;
	2200790) #EU PQ/ZR 449
		set -A offsets 15F7C8 15F7C9 15F7CA 15F7CB 15F85C 15F85D 15F85E 15F85F ;;
	2203579) #EU PQ/ZR 472/478/479/480
		set -A offsets 1618D4 1618D5 1618D6 1618D7 161968 161969 16196A 16196B ;;
	2201811) #EU 480 different variant
		set -A offsets 1612B4 1612B5 1612B6 1612B7 161348 161349 16134A 16134B ;;
	2207774) #EU 515/516
		set -A offsets 1627E0 1627E1 1627E2 1627E3 162874 162875 162876 162877 ;;
	*)
		offsets="" ;;
esac

if [ -n "$offsets" ]; then
	fin=$MIBPATH
	j=0
	for i in ${offsets[@]}; do
		fh=$((16#$i))
		echo "Patching offset 0x$i ${bytes[j]}"
		fout="/tmp/tsd.mibstd2.audio.audiomgr$j"
		(head -c $fh $fin; awk -v byte="\x${bytes[j]}" 'BEGIN{printf(byte)}' 2>/dev/null;tail -c +$(($fh+2)) $fin) > $fout
		if [ $j -gt 0 ]; then
			rm $fin
		fi
		fin=$fout
		j=$((j+1))
	done

	if [ -f "$fout" ]; then				
		mv $fout /tsd/var/tsd.mibstd2.audio.audiomgr
		chmod 777 /tsd/var/tsd.mibstd2.audio.audiomgr

		cp -f /net/J5/tsd/etc/system/main.conf /tsd/var/
		sed -i 's/   command \/tsd\/bin\/audio\/tsd.mibstd2.audio.audiomgr -control=tsd.audiomgr.control/   command \/tsd\/var\/tsd.mibstd2.audio.audiomgr -control=tsd.audiomgr.control/g' /tsd/var/main.conf

		# Mount system partition in read/write mode
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		
		echo "export TSD_COMMON_CONFIG=/tsd/etc/system/tsd.mibstd2.main.root.conf" >/tsd/bin/system/startup_main
		echo "export TSD_LOGCHANNEL=J5e" >>/tsd/bin/system/startup_main
		if [[ "$size" == "1851273" || "$size" == "1850369" ]]; then
			echo "on -p 20 /tsd/bin/root/tsd.mibstd2.main.root -file=/tsd/var/main.conf -reset=/net/imx6/var/root/reset.count.main" >>/tsd/bin/system/startup_main		
		else
			echo "on -p 20 /tsd/bin/root/tsd.mibstd2.main.root -file=/tsd/var/main.conf -swdlfile=/tsd/etc/system/swdl/main_swdl.conf -reset=/tsd/var/root/reset.count.main" >>/tsd/bin/system/startup_main		
		fi
		echo "RET=$""?" >>/tsd/bin/system/startup_main
		echo "if [ $""RET -eq 0 ] ; then" >>/tsd/bin/system/startup_main
        echo ' echo "main.root terminated -> calling shutdown script"' >>/tsd/bin/system/startup_main
		echo " # source it to avoid spawning a new shell" >>/tsd/bin/system/startup_main
		echo " . /tsd/bin/system/shutdown" >>/tsd/bin/system/startup_main
		echo ' echo "shutdown finished!"' >>/tsd/bin/system/startup_main
		echo "elif [ $""RET -eq 42 ] ; then" >>/tsd/bin/system/startup_main
		echo ' echo "MP42 set to low! -> Boot Stopped."' >>/tsd/bin/system/startup_main
		if [[ "$size" == "1851273" || "$size" == "1850369" ]]; then
			echo "else" >>/tsd/bin/system/startup_main
			echo "   /tsd/bin/system/wd_procterm.sh 'tsd.mibstd2.main.root' J5e.MCP 0 "'"main.root crash"' >>/tsd/bin/system/startup_main
		fi
		echo "fi" >>/tsd/bin/system/startup_main
		
		chmod 777 /tsd/bin/system/startup_main
		
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
