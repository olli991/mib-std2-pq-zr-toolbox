#!/bin/ksh
echo "This script will restore the navigation-active status."
echo "NOTE: NEVER interrupt the process with -Back- button or removing SD Card!"
echo

JAR_DIR="/tsd/hmi/HMI/jar/"
JAR=NavActiveIgnore.jar
HMI_SH=/tsd/hmi/runHMI.sh
BU=/tsd/hmi/runHMI.sh.bak

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

echo -ne "-- Remove NavActiveIgnore\n" 
if [ -f $JAR_DIR$JAR ]; then
	rm -rf $JAR_DIR$JAR 2>&1
	echo "NavActiveIgnore.jar removed.\n" 
else
	echo -ne "File not found - navignore patch is not installed.\n"
fi
if [ -f $BU ]; then
	cp -f $BU $HMI_SH 2>&1
	echo "Original $HMI_SH has been restored.\n" 
fi

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. Please reboot the unit to apply changes."
exit 0