#!/bin/ksh
# QiChargeIcon installer: Shows the wireless (Qi) charging icon in the status bar.
# Installs QiChargeIcon.jar -> /tsd/hmi/HMI/jar/, loaded via runHMI.sh bootclasspath.
JAR_DIR="/tsd/hmi/HMI/jar/"
JAR=QiChargeIcon.jar
HMI_SH=/tsd/hmi/runHMI.sh
BU=/tsd/hmi/runHMI.sh.bak
HOOK_SH=/tsd/etc/persistence/esd/scripts/check_reset.sh

export TOPIC=qichargeicon
export MIBPATH=$HMI_SH
export SDPATH=$TOPIC/runHMI.sh
export TYPE="file"

echo "This script will install the QiChargeIcon HMI patch:"
echo "Shows the wireless (Qi) charging icon in the status bar."
echo "NOTE: NEVER interrupt the process with -Back- button or removing SD Card!"
echo

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

if [ ! -e "$VOLUME/custom/java/$JAR" ]; then
	echo -ne "Aborted. Cannot open $VOLUME/custom/java/$JAR!\n"
	exit 1
fi
if [ ! -f "$HOOK_SH" ]; then
	echo "Aborted. $HOOK_SH missing on unit -- toolbox install looks incomplete."
	exit 1
fi

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

# --- install the jar FIRST, and verify the copy actually landed (guard against a ro partition) ---
echo -ne "-- Installing $JAR...\n"
if [ -f $JAR_DIR$JAR ]; then
	echo -ne "$JAR already present on unit.\nWill be updated with file from SD now.\n"
fi
cp -f $VOLUME/custom/java/$JAR $JAR_DIR$JAR 2>&1
chmod a+rwx $JAR_DIR$JAR
JSRC_SZ=$(ls -la $VOLUME/custom/java/$JAR 2>/dev/null | awk '{print $5}')
JDST_SZ=$(ls -la $JAR_DIR$JAR 2>/dev/null | awk '{print $5}')
if [ -z "$JDST_SZ" ] || [ "$JSRC_SZ" != "$JDST_SZ" ]; then
	echo "ERROR: $JAR did not copy (src=$JSRC_SZ dst=$JDST_SZ). Nothing else changed; aborting."
	. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
	exit 1
fi
echo "$JAR installed."

# --- reset hook BEFORE the runHMI.sh patch (safety net goes in first) ---
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

echo -ne "-- Patching $HMI_SH...\n"
if ! grep -q '$BOOTCLASSPATH -Xbootclasspath/p:$MIBJAR/QiChargeIcon.jar' ${HMI_SH}; then
	if [ ! -f $BU ]; then
		echo "Backup $HMI_SH"
		cp $HMI_SH $BU 2>&1
		# Make backup to SD
		. /tsd/etc/persistence/esd/scripts/util_backup.sh
	fi
	echo "Patching $HMI_SH to run additional *.jar"
	sed -i '/^BOOTCLASSPATH="\$BOOTCLASSPATH/!s/\(^BOOTCLASSPATH=.*$\)/\1\nBOOTCLASSPATH="$BOOTCLASSPATH -Xbootclasspath\/p:$MIBJAR\/QiChargeIcon.jar"/' $HMI_SH
	echo "$HMI_SH is patched."
else
	echo "$HMI_SH is already patched."
fi

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Completed. Please reboot the unit to apply changes."
echo "If something does not work as expected, use the disable function,"
echo "or drop an empty file named 'reset' at the root of an SD card and reboot."
exit 0
