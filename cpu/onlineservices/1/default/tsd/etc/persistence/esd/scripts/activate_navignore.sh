#!/bin/ksh
JAR_DIR="/tsd/hmi/HMI/jar/"
JAR=NavActiveIgnore.jar
HMI_SH=/tsd/hmi/runHMI.sh
BU=/tsd/hmi/runHMI.sh.bak

export TOPIC=navigation
export MIBPATH=$HMI_SH
export SDPATH=$TOPIC/runHMI.sh
export TYPE="file"

echo "This script will patch Navigation to ignore the navigation-active status"
echo "from a smartphone."
echo "NOTE: NEVER interrupt the process with -Back- button or removing SD Card!"
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

if ! grep -q '$BOOTCLASSPATH -Xbootclasspath/p:$MIBJAR/NavActiveIgnore.jar' ${HMI_SH}; then
	if [ ! -f $BU ]; then
		echo "Backup $HMI_SH"
		cp $HMI_SH $BU 2>&1
	fi
	echo "Patching $HMI_SH to run additional *.jar"
	
	# Make backup to SD
	. /tsd/etc/persistence/esd/scripts/util_backup.sh
	
	sed -i 's/\(^BOOTCLASSPATH=.*$\)/\1\nBOOTCLASSPATH="$BOOTCLASSPATH -Xbootclasspath\/p:$MIBJAR\/NavActiveIgnore.jar"/' $HMI_SH
	echo "$HMI_SH is patched."
else
	echo "$HMI_SH is already patched."
fi

echo -ne "-- Install NavActiveIgnore\n"
if [[ "$TRAIN" = *VW* ]] || [[ "$TRAIN" = *SK* ]] || [[ "$TRAIN" = *SE* ]]; then
	echo -ne "Update FW to latest version is recommended.\n"
	if [ -f $JAR_DIR$JAR ]; then
		echo -ne "$JAR already present on unit.\nWill be updated with file from SD now.\n" 
	fi
	cp -f $VOLUME/custom/java/navignore_vw.jar $JAR_DIR$JAR 2>&1
	chmod a+rwx $JAR_DIR$JAR
	echo -ne "navignore_vw.jar installed.\n" 
elif [[ "$TRAIN" = *PO* ]] || [[ "$TRAIN" = *AU* ]] || [[ "$TRAIN" = *BY* ]]; then
	echo -ne "Update FW to latest version is recommended.\n"
	if [ -f $JAR_DIR$JAR ]; then
		echo -ne "$JAR already present on unit.\nWill be updated with file from SD now.\n"
	fi
	cp -f $VOLUME/custom/java/navignore_audi.jar $JAR_DIR$JAR 2>&1
	chmod a+rwx $JAR_DIR$JAR
	echo -ne "navignore_audi.jar installed.\n" 
else
	echo -ne "no supported train found - will stop here.\n" 
fi

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Completed. Please reboot the unit to apply changes."
echo "If something does not work as expected, use a restore function."
exit 0