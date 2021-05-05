#!/bin/ksh
# MIB2 utility script, part of the MIB High toolbox.
# Coded by Jille
# This script will make a backup if it's not already there
# Modified for MIB STD2 toolbox by Olli

NEWFILES=$VOLUME/custom/$SDPATH

echo "Copying" $NEWFILES
echo "To" $MIBPATH

if [ "$TYPE" == "folder" ]; then
	if [ -d ${NEWFILES} ]; then
		echo "This can take some time, please wait"
		# Mount system as read/write
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		cp -r ${NEWFILES}/* ${MIBPATH}
	else
		echo "No files found"
		exit 0
	fi	
else
	if [ -f ${NEWFILES} ]; then
		# Mount system as read/write
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		cp -f ${NEWFILES} ${MIBPATH}
		if [[ "$TOPIC" == "hmi" || "$TOPIC" == "mirrorlink" || "$TOPIC" == "navigation" || "$TOPIC" == "swap" || "$TOPIC" == "swdl" || "$TOPIC" == "shadow" ]]; then
			chmod 777 ${MIBPATH}
		fi
	else
		echo "No files found"
		exit 0
	fi
fi 

echo "Copying is done."
