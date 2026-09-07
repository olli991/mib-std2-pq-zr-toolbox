#!/bin/ksh
JAR_DIR="/tsd/hmi/HMI/jar/"
JAR=NavActiveIgnore.jar
HMI_SH=/tsd/hmi/runHMI.sh
BU=/tsd/hmi/runHMI.sh.bak
HOOK_SH=/tsd/etc/persistence/esd/scripts/check_reset.sh

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

if [[ "$TRAIN" = *VW* ]] || [[ "$TRAIN" = *SK* ]] || [[ "$TRAIN" = *SE* ]]; then
	SRCJAR=navignore_vw.jar
elif [[ "$TRAIN" = *PO* ]] || [[ "$TRAIN" = *AU* ]] || [[ "$TRAIN" = *BY* ]]; then
	SRCJAR=navignore_audi.jar
else
	echo -ne "Aborted. No supported train found!\n"
	exit 1
fi

if [ ! -e "$VOLUME/custom/java/$SRCJAR" ]; then
	echo -ne "Aborted. Cannot open $VOLUME/custom/java/$SRCJAR!\n" 
	exit 1
fi
if [ ! -f "$HOOK_SH" ]; then
	echo "Aborted. $HOOK_SH missing on unit -- toolbox install looks incomplete."
	exit 1
fi

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

# --- reset hook FIRST (safety net goes in before the risky patch) ---
if ! grep -q 'check_reset.sh' ${HMI_SH}; then
	if [ ! -f $BU ]; then
		echo "Backup $HMI_SH"
		cp $HMI_SH $BU 2>&1
		. /tsd/etc/persistence/esd/scripts/util_backup.sh
	fi
	echo "Adding reset hook to $HMI_SH"
	sed -i "1a\ksh $HOOK_SH &" $HMI_SH
	echo "Reset hook installed."
else
	echo "Reset hook already present in $HMI_SH."
fi

echo -ne "-- Installing NavActiveIgnore...\n"
if ! grep -q '$BOOTCLASSPATH -Xbootclasspath/p:$MIBJAR/NavActiveIgnore.jar' ${HMI_SH}; then
	if [ ! -f $BU ]; then
		echo "Backup $HMI_SH"
		cp $HMI_SH $BU 2>&1
		# Make backup to SD
		. /tsd/etc/persistence/esd/scripts/util_backup.sh
	fi
	echo "Patching $HMI_SH to run additional *.jar"
	sed -i 's/\(^BOOTCLASSPATH=.*$\)/\1\nBOOTCLASSPATH="$BOOTCLASSPATH -Xbootclasspath\/p:$MIBJAR\/NavActiveIgnore.jar"/' $HMI_SH
	echo "$HMI_SH is patched."
else
	echo "$HMI_SH is already patched."
fi

echo -ne "Update of FW onto the latest version is recommended.\n"
if [ -f $JAR_DIR$JAR ]; then
	echo -ne "$JAR already present on unit.\nWill be updated with file from SD now.\n" 
fi
cp -f $VOLUME/custom/java/$SRCJAR $JAR_DIR$JAR 2>&1
chmod a+rwx $JAR_DIR$JAR
echo -ne "$SRCJAR is installed.\n" 

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Completed. Please reboot the unit to apply changes."
echo "If something does not work as expected, use a restore function,"
echo "or drop an empty file named 'reset' at the root of an SD card and reboot."
exit 0