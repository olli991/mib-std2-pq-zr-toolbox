#!/bin/ksh
# MIB2 utility script, part of the MIB STD2 toolbox.
# Coded by Olli
# This script will restore files from backup.
# Based on the copy script by Jille from MIB2 High Toolbox. Modified for MIB2STD Toolbox by Olli

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

OLDFILES=$VOLUME/backup/$SDPATH

echo
echo "Source: $OLDFILES"
echo "Destination: $MIBPATH"

if [ "$TYPE" == "folder" ]; then
	if [ -d ${OLDFILES} ]; then
		echo "This can take some time. Please wait..."
		# Mount system partition in read/write mode
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		if [["$TOPIC" == "devesd" ]]; then
			rm -rv /tsd/etc/persistence/esd/*
		fi
		cp -r ${OLDFILES}/* ${MIBPATH}
	else
		echo "ERROR: No backup found"
		exit 0
	fi	
else
	if [ -f ${OLDFILES} ]; then
		# Mount system partition in read/write mode
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		cp -f ${OLDFILES} ${MIBPATH}
		if [[ "$TOPIC" == "swdl" || "$TOPIC" == "swap" || "$TOPIC" == "hmi" || "$TOPIC" == "mirrorlink" || "$TOPIC" == "navigation" || "$TOPIC" == "shadow" ]]; then
			chmod 777 ${MIBPATH}
		fi
	else
		echo "ERROR: No backup found"
		exit 0
	fi
fi 

echo "Restoring is done. Please restart the unit."
exit 0