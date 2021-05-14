#!/bin/ksh
# MIB2 utility script, part of the MIB STD2 Toolbox.
# Coded by Olli
# This script will restore files from backup.
# Based on the copy script by Jille from MIB2 High Toolbox. Modified for MIB STD2 Toolbox by Olli

echo

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

OLDFILES=$VOLUME/backup/$VERSION/$SERIAL/$SDPATH
echo "Source: $OLDFILES"
echo "Destination: $MIBPATH"

if [ "$TYPE" = "folder" ]; then
	if [ -d ${OLDFILES} ]; then
	
		# Mount system partition in read/write mode
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		
		echo "Restoring, please wait..."
		if [ "$TOPIC" = "greenmenu" ]; then
			rm -rf /tsd/etc/persistence/esd/*
		fi
		cp -rf ${OLDFILES}/. ${MIBPATH}
		if [ "$TOPIC" = "greenmenu" ]; then
			echo "Copying toolbox Green Engineering Menu screens and scripts..."
			cp -rf $VOLUME/cpu/onlineservices/1/default/tsd/etc/persistence/esd/* /tsd/etc/persistence/esd
			echo "Copying of toolbox Green Engineering Menu screens and scripts is done."
			echo "Setting execution attributes to scripts..."
			chmod a+rwx /tsd/etc/persistence/esd/scripts/*.sh
			echo "Setting execution attributes is done." 
		fi
		
		# Mount system partition in read/only mode
		. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh		
	else
		echo
		echo "ERROR: backup is not found"
		exit 0
	fi	
else
	if [ -f ${OLDFILES} ]; then
	
		# Mount system partition in read/write mode
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		
		echo "Restoring, please wait..."
		cp -f ${OLDFILES} ${MIBPATH}
		if [[ $TOPIC = "swdl" || $TOPIC = "swap" || $TOPIC = "hmi" || $TOPIC = "mirrorlink" || $TOPIC = "navigation" || $TOPIC = "shadow" ]]; then
			chmod 777 ${MIBPATH}
		fi
		
		# Mount system partition in read/only mode
		. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
	else
		echo
		echo "ERROR: backup is not found"
		exit 0
	fi
fi 

echo
if [ "$TOPIC" = "shadow" ]; then
	echo "Restoring is done."
elif [ "$TOPIC" = "devesd" ]; then
	echo "Restoring is done. Please reopen Green Engineering Menu."
else
	echo "Restoring is done. Please restart the unit."
fi
exit 0