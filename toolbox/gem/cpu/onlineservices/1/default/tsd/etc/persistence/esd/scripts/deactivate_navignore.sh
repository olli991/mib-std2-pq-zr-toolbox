#!/bin/ksh
echo "This script will restore the navigation-active status."
echo "NOTE: NEVER interrupt the process with -Back- button or removing SD Card!"
echo

JAR_DIR="/tsd/hmi/HMI/jar/"
JAR=NavActiveIgnore.jar
HMI_SH=/tsd/hmi/runHMI.sh

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

echo -ne "-- Remove NavActiveIgnore\n" 
# Surgically delete ONLY our own line. We deliberately do NOT restore the shared
# /tsd/hmi/runHMI.sh.bak backup, so other mods that patch runHMI.sh and their 
# restore point stay intact.
if grep -q 'NavActiveIgnore.jar' ${HMI_SH} 2>/dev/null; then
	sed -i '/NavActiveIgnore.jar/d' $HMI_SH
	echo "Removed NavActiveIgnore bootclasspath entry from $HMI_SH."
else
	echo "$HMI_SH has no NavActiveIgnore entry."
fi

if [ -f $JAR_DIR$JAR ]; then
	rm -rf $JAR_DIR$JAR 2>&1
	echo "NavActiveIgnore.jar removed.\n" 
else
	echo -ne "File not found - navignore patch is not installed.\n"
fi

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. Please reboot the unit to apply changes."
exit 0