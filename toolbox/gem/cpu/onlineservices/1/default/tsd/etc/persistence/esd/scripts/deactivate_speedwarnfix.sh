#!/bin/ksh
# SpeedWarnFix uninstaller. Runs WITHOUT the toolbox SD card (also used by check_reset.sh).
echo "This script will remove the SpeedWarnFix HMI patch."
echo "NOTE: NEVER interrupt the process with -Back- button or removing SD Card!"
echo

JAR_DIR="/tsd/hmi/HMI/jar/"
JAR=SpeedWarnFix.jar
HMI_SH=/tsd/hmi/runHMI.sh

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

echo -ne "-- Remove SpeedWarnFix\n"
# Surgically delete ONLY our own line. We deliberately do NOT restore the shared
# /tsd/hmi/runHMI.sh.bak backup, so other mods that patch runHMI.sh and their
# restore point stay intact.
if grep -q "$JAR" ${HMI_SH} 2>/dev/null; then
	sed -i "/$JAR/d" $HMI_SH
	echo "Removed SpeedWarnFix bootclasspath entry from $HMI_SH."
else
	echo "$HMI_SH has no SpeedWarnFix entry."
fi

if [ -f $JAR_DIR$JAR ]; then
	rm -f $JAR_DIR$JAR 2>&1
	echo -ne "$JAR removed.\n"
else
	echo -ne "File not found - SpeedWarnFix patch is not installed.\n"
fi

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. Please reboot the unit to apply changes."
exit 0
