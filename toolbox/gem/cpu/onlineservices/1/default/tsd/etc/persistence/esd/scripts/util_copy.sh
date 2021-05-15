#!/bin/ksh
# MIB2 utility script, part of the MIB High toolbox.
# Coded by Jille
# This script will make a backup if it's not already there
# Modified for MIB STD2 toolbox by Olli

if [ "$TOPIC" = "devesd" ]; then
	NEWFILES=$VOLUME/toolbox/$SDPATH
else
	NEWFILES=$VOLUME/custom/$SDPATH
fi

echo "Copying $TYPE"
echo "Source:" $NEWFILES
echo "Destination:" $MIBPATH

if [ "$TYPE" = "folder" ]; then
	if [ -d ${NEWFILES} ]; then
		# Mount system as read/write
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		echo "Copying folder, please wait..."
		cp -rf ${NEWFILES}/. ${MIBPATH}
	else
		echo "ERROR: No files found"
		exit 0
	fi	
else
	if [ -f ${NEWFILES} ]; then
		# Mount system as read/write
		. /tsd/etc/persistence/esd/scripts/util_mount.sh
		echo "Copying file, please wait..."
		cp -f ${NEWFILES} ${MIBPATH}
		if [[ $TOPIC = "hmi" || $TOPIC = "mirrorlink" || $TOPIC = "navigation" || $TOPIC = "swap" || $TOPIC = "swdl" || $TOPIC = "shadow" ]]; then
			echo "Setting attributes..."
			chmod 777 ${MIBPATH}
		fi
	else
		echo "ERROR: No files found"
		exit 0
	fi
fi 

echo "Copying has finished."
