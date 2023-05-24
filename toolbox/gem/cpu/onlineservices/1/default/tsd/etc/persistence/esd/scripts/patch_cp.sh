#!/bin/ksh
export TOPIC=cp
if [ -d /net/imx6 ]; then
	export MIBPATH=/net/J5/tsd/bin/audio/tsd.mibstd2.audio.audiomgr
else
	mount_ifs -f /tsd/bin/ifs/system.ifs -m /tmp
	export MIBPATH=/tmp/tsd/bin/audio/tsd.mibstd2.audio.audiomgr
fi
export SDPATH=$TOPIC/tsd.mibstd2.audio.audiomgr
export TYPE="file"

echo "This script will patch CP check"
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh
echo "ID: $TRAIN $SYS"

# Size of the file to patch
size=$(ls -l $MIBPATH | awk '{print $5}' 2>/dev/null)

echo "Checking $MIBPATH..."
set -A bytes 1E FF 2F E1 1E FF 2F E1
offsets=""

case $size in
	#1852137) #EU ZR 137
	#	set -A offsets 14334C 14334D 14334E 14334F 1433E8 1433E9 1433EA 1433EB ;;
	#1851273) #EU PQ 138
	#	set -A offsets 1430B8 1430B9 1430BA 1430BB 143154 143155 143156 143157 ;;
	#1850393|1850369) #EU ZR 131/140
	#	set -A offsets 142D2C 142D2D 142D2E 142D2F 142DC8 142DC9 142DCA 142DCB ;;
	#1972589) #CN ZR 138
	#	set -A offsets 13F5C4 13F5C5 13F5C6 13F5C7 13F660 13F661 13F662 13F663 ;;
	1599808) #mainstd EU ZR 369
		set -A offsets FF290 FF291 FF292 FF293 FF328 FF329 FF32A FF32B ;;
	1604996) #mainstd EU ZR 480
		set -A offsets 101258 101259 10125A 10125B 1012F0 1012F1 1012F2 1012F3 ;;
	1919734) #EU PQ 240
		set -A offsets 151380 151381 151382 151383 151418 151419 15141A 15141B ;;
	1921742) #EU ZR 241
		set -A offsets 151824 151825 151826 151827 1518BC 1518BD 1518BE 1518BF ;;
	1919783) #EU PQ 245
		set -A offsets 1513B0 1513B1 1513B2 1513B3 151448 151449 15144A 15144B ;;
	1919767) #US PQ 245/247
		set -A offsets 151390 151391 151392 151393 151428 151429 15142A 15142B ;;
	1921791) #EU ZR 245
		set -A offsets 151854 151855 151856 151857 1518EC 1518ED 1518EE 1518EF ;;
	1923559) #EU ZR 252
		set -A offsets 151E74 151E75 151E76 151E77 151F0C 151F0D 151F0E 151F0F ;;
	1921551) #EU PQ 252
		set -A offsets 1519D0 1519D1 1519D2 1519D3 151A68 151A69 151A6A 151A6B ;;
	1918015) #US PQ 253
		set -A offsets 150D70 150D71 150D72 150D73 150E08 150E09 150E0A 150E0B ;;
	1918031) #EU PQ 254
		set -A offsets 150D90 150D91 150D92 150D93 150E28 150E29 150E2A 150E2B ;;
	1921535) #US PQ 254
		set -A offsets 1519B0 1519B1 1519B2 1519B3 151A48 151A49 151A4A 151A4B ;;
	1923543) #US ZR 254
		set -A offsets 151E54 151E55 151E56 151E57 151EEC 151EED 151EEE 151EEF ;;
	1920039|1920055) #EU/RoW ZR 254
		set -A offsets 151234 151235 151236 151237 1512CC 1512CD 1512CE 1512CF ;;
	2186198) #EU ZR 346
		set -A offsets 15CC90 15CC91 15CC92 15CC93 15CD24 15CD25 15CD26 15CD27 ;;
	2187958) #EU PQ 353
		set -A offsets 15D2B8 15D2B9 15D2BA 15D2BB 15D34C 15D34D 15D34E 15D34F ;;
	2187950|2187982|2187983) #EU/US PQ/ZR 356/357/359
		set -A offsets 15D2B0 15D2B1 15D2B2 15D2B3 15D344 15D345 15D346 15D347 ;;
	2189718) #EU PQ/ZR 359
		set -A offsets 15D8C8 15D8C9 15D8CA 15D8CB 15D95C 15D95D 15D95E 15D95F ;;
	2189726) #EU PQ 359 v2
		set -A offsets 15D8D0 15D8D1 15D8D2 15D8D3 15D964 15D965 15D966 15D967 ;;
	2186470) #EU ZR 359
		set -A offsets 15CD70 15CD71 15CD72 15CD73 15CE04 15CE05 15CE06 15CE07 ;;
	2186478) #EU ZR 359
		set -A offsets 15CD78 15CD79 15CD7A 15CD7B 15CE0C 15CE0D 15CE0E 15CE0F ;;
	2187974) #EU ZR 359
		set -A offsets 15D2A8 15D2A9 15D2AA 15D2AB 15D33C 15D33D 15D33E 15D33F ;;
	2186303) #CN PQ/ZR 361/367
		set -A offsets 15CCEC 15CCED 15CCEE 15CCEF 15CD80 15CD81 15CD82 15CD83 ;;
	2188055|2188079) #EU PQ/ZR 363/367
		set -A offsets 15D314 15D315 15D316 15D317 15D3A8 15D3A9 15D3AA 15D3AB ;;
	2186582) #EU PQ/ZR 363 v2
		set -A offsets 15CDDC 15CDDD 15CDDE 15CDDF 15CE70 15CE71 15CE72 15CE73 ;;
	2188047) #EU PQ/ZR 363/367 v2
		set -A offsets 15D30D 15D30E 15D30F 15D310 15D3A0 15D3A1 15D3A2 15D3A3 ;;
	2188071) #EU ZR 367 v3
		set -A offsets 15D30C 15D30D 15D30E 15D30F 15D3A0 15D3A1 15D3A2 15D3A3 ;;
	2186574) #EU ZR 368
		set -A offsets 15CDD4 15CDD5 15CDD6 15CDD7 15CE68 15CE69 15CE6A 15CE6B ;;
	2194246) #EU PQ 369
		set -A offsets 15E018 15E019 15E01A 15E01B 15E0AC 15E0AD 15E0AE 15E0AF ;;
	2194254) #EU PQ 369 v2
		set -A offsets 15E020 15E021 15E022 15E023 15E0B4 15E0B5 15E0B6 15E0B7 ;;
	2195759) #cpuplus EU PQ 369
		set -A offsets 15E558 15E559 15E55A 15E55B 15E5EC 15E5ED 15E5EE 15E5EF ;;
	2197495) #EU ZR 369
		set -A offsets 15EB70 15EB71 15EB72 15EB73 15EC04 15EC05 15EC06 15EC07 ;;
	2197503) #EU ZR 369 v2
		set -A offsets 15EB78 15EB79 15EB7A 15EB7B 15EC0C 15EC0D 15EC0E 15EC0F ;;
	2200790) #EU PQ/ZR 449
		set -A offsets 15F7C8 15F7C9 15F7CA 15F7CB 15F85C 15F85D 15F85E 15F85F ;;
	2202566|2202542) #EU/US PQ/ZR 447/462
		set -A offsets 15FDE8 15FDE9 15FDEA 15FDEB 15FE7C 15FE7D 15FE7E 15FE7F ;;
	2198694) #CN PQ 478
		set -A offsets 15F108 15F109 15F10A 15F10B 15F19C 15F19D 15F19E 15F19F ;;
	2201779) #EU ZR 472/CN PQ 478
		set -A offsets 161294 161295 161296 161297 161328 161329 16132A 16132B ;;
	2195751) #cpu EU PQ 478
		set -A offsets 15E550 15E551 15E552 15E553 15E5E4 15E5E5 15E5E6 15E5E7 ;;
	2203579) #EU PQ/ZR 468/472/478/479/480
		set -A offsets 1618D4 1618D5 1618D6 1618D7 161968 161969 16196A 16196B ;;
	2205355) #US PQ 468
		set -A offsets 161EF4 161EF5 161EF6 161EF7 161F88 161F89 161F90 161F91 ;;
	2201811|2201835) #EU/US ZR/PQ 475/478/480 2nd variant
		set -A offsets 1612B4 1612B5 1612B6 1612B7 161348 161349 16134A 16134B ;;
	2207086) #EU PQ 604
		set -A offsets 1623C8 1623C9 1623CA 1623CB 16245C 16245D 16245E 16245F ;;
	2207774) #EU ZR 515/516
		set -A offsets 1627E0 1627E1 1627E2 1627E3 162874 162875 162876 162877 ;;
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

	if [[ $j -eq 8 && -f "$fout" ]]; then
		echo "Audiomgr is patched. Moving to eMMC..."
		mv $fout /tsd/var/tsd.mibstd2.audio.audiomgr
		if [[ -f "/tsd/var/tsd.mibstd2.audio.audiomgr" ]]; then
			chmod 777 /tsd/var/tsd.mibstd2.audio.audiomgr
			if [ -d /net/imx6 ]; then
				cp -f /net/J5/tsd/etc/system/main.conf /tsd/var/
				if [[ -f "/tsd/var/main.conf" ]]; then
					confsize=$(ls -l /tsd/var/main.conf | awk '{print $5}' 2>/dev/null)
					sed -i 's/   command \/tsd\/bin\/audio\/tsd.mibstd2.audio.audiomgr -control=tsd.audiomgr.control/   command \/tsd\/var\/tsd.mibstd2.audio.audiomgr -control=tsd.audiomgr.control/g' /tsd/var/main.conf
					if [[ "$confsize" != "$(ls -l /tsd/var/main.conf | awk '{print $5}' 2>/dev/null)" ]]; then 
						# Mount system partition in read/write mode
						. /tsd/etc/persistence/esd/scripts/util_mount.sh
						echo "Creating startup_main file..."
						echo "export TSD_COMMON_CONFIG=/tsd/etc/system/tsd.mibstd2.main.root.conf" >/net/imx6/tsd/bin/system/startup_main
						if [[ -f /net/imx6/tsd/bin/system/startup_main ]]; then
							echo "export TSD_LOGCHANNEL=J5e" >>/net/imx6/tsd/bin/system/startup_main
							if [[ "$size" == "1852137" || "$size" == "1851273" || "$size" == "1850369" || "$size" == "1850393" || "$size" == "1972589" ]]; then
								echo "on -p 20 /tsd/bin/root/tsd.mibstd2.main.root -file=/tsd/var/main.conf -reset=/net/imx6/tsd/var/root/reset.count.main" >>/net/imx6/tsd/bin/system/startup_main
							else
								echo "on -p 20 /tsd/bin/root/tsd.mibstd2.main.root -file=/tsd/var/main.conf -swdlfile=/tsd/etc/system/swdl/main_swdl.conf -reset=/net/imx6/tsd/var/root/reset.count.main" >>/net/imx6/tsd/bin/system/startup_main
							fi
							echo "RET=$""?" >>/net/imx6/tsd/bin/system/startup_main
							echo "if [ $""RET -eq 0 ] ; then" >>/net/imx6/tsd/bin/system/startup_main
							echo ' echo "main.root terminated -> calling shutdown script"' >>/net/imx6/tsd/bin/system/startup_main
							echo " # source it to avoid spawning a new shell" >>/net/imx6/tsd/bin/system/startup_main
							echo " . /tsd/bin/system/shutdown" >>/net/imx6/tsd/bin/system/startup_main
							echo ' echo "shutdown finished!"' >>/net/imx6/tsd/bin/system/startup_main
							echo "elif [ $""RET -eq 42 ] ; then" >>/net/imx6/tsd/bin/system/startup_main
							echo ' echo "MP42 set to low! -> Boot Stopped."' >>/net/imx6/tsd/bin/system/startup_main
							if [[ "$size" == "1852137" || "$size" == "1851273" || "$size" == "1850369" || "$size" == "1850393" || "$size" == "1972589" ]]; then
								echo "else" >>/net/imx6/tsd/bin/system/startup_main
								echo "   /tsd/bin/system/wd_procterm.sh 'tsd.mibstd2.main.root' J5e.MCP 0 "'"main.root crash"' >>/net/imx6/tsd/bin/system/startup_main
							fi
							echo "fi" >>/net/imx6/tsd/bin/system/startup_main
							chmod 777 /net/imx6/tsd/bin/system/startup_main
							echo "Patch is applied. Please restart the unit."
						else
							echo "Cannot create startup_main file. Nothing was changed."
						fi
						# Mount system partition in read/only mode
						. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
					else
						echo "Patching failed. Cannot patch main.conf!"
					fi
				else
					echo "Patching failed. Cannot open main.conf!"
				fi
			else
				cp -f /tsd/etc/system/radio.conf /tsd/var/
				if [[ -f "/tsd/var/radio.conf" ]]; then
					confsize=$(ls -l /tsd/var/radio.conf | awk '{print $5}' 2>/dev/null)
					sed -i 's/   command \/tsd\/bin\/audio\/tsd.mibstd2.audio.audiomgr -control=tsd.audiomgr.control/   command \/tsd\/var\/tsd.mibstd2.audio.audiomgr -control=tsd.audiomgr.control/g' /tsd/var/radio.conf
					if [[ "$confsize" != "$(ls -l /tsd/var/radio.conf | awk '{print $5}' 2>/dev/null)" ]]; then
						cp -f /tsd/etc/system/lsmradio/radio.conf /tsd/var/radio2.conf
						if [[ -f "/tsd/var/radio2.conf" ]]; then
							confsize=$(ls -l /tsd/var/radio2.conf | awk '{print $5}' 2>/dev/null)
							sed -i 's/   command \/tsd\/bin\/audio\/tsd.mibstd2.audio.audiomgr -control=tsd.audiomgr.control/   command \/tsd\/var\/tsd.mibstd2.audio.audiomgr -control=tsd.audiomgr.control/g' /tsd/var/radio2.conf
							if [[ "$confsize" != "$(ls -l /tsd/var/radio2.conf | awk '{print $5}' 2>/dev/null)" ]]; then
								. /tsd/etc/persistence/esd/scripts/util_mount.sh
								echo "Patching /tsd/bin/system/startup..."
								sed -i 's/    CFG=\/tsd\/etc\/system\/radio\.conf.*/    CFG=\/tsd\/etc\/system\/radio\.conf ; if \[ -f \/tsd\/var\/radio\.conf ]; then CFG=\/tsd\/var\/radio\.conf; fi/g' /tsd/bin/system/startup
								sed -i 's/    RCFG=\/tsd\/etc\/system\/lsmradio\/radio\.conf.*/    RCFG=\/tsd\/etc\/system\/lsmradio\/radio\.conf ; if \[ -f \/tsd\/var\/radio2\.conf ]; then RCFG=\/tsd\/var\/radio2\.conf; fi/g' /tsd/bin/system/startup
								. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
								echo "Patch is applied. Please restart the unit."
							else
								echo "Patching failed. Cannot patch /tsd/var/radio2.conf!"
							fi
						else
							echo "Patching failed. Can't copy /tsd/etc/system/lsmradio/radio.conf to /tsd/var/"
						fi
					else
						echo "Patching failed. Cannot patch /tsd/var/radio.conf!"
					fi
				else
					echo "Patching failed. Can't copy /tsd/etc/system/radio.conf to /tsd/var/"
				fi
			fi
		else
			echo "Patching failed. Cannot open audiomgr!"
		fi
	else
		echo "Patching failed! Please retry or send sysinfo!"
	fi
else
	if [[ "$size" == "1852137" || "$size" == "1851273" || "$size" == "1850369" || "$size" == "1850393" || "$size" == "1972589" ]]; then
		echo "CP patch on firmwares 1xx is not possible, sorry!"
	else
		echo "Unknown file size $size detected. Send Tools>Support Dump!"
	fi
fi
exit 0