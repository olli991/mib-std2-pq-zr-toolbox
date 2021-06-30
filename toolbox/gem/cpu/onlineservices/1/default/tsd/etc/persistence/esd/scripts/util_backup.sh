#!/bin/ksh
# MIB2 utility script, part of the MIB High toolbox.
# Coded by Jille
# This script will make a backup if it's not already there
# Modified for MIB STD2 toolbox by Olli

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

export BACKUPFOLDER=$VOLUME/backup/$VERSION/$SERIAL/$TOPIC

echo "Making $TYPE backup..."
echo "Source: $MIBPATH"
echo "Destination: $VOLUME/backup/"
echo "  $VERSION/$SERIAL/$TOPIC"

if [ "$TYPE" = "folder" ]; then
	if [ -d "${BACKUPFOLDER}" ]; then
		echo "Backup already exists. Skipping..."
	else
		echo "Copying files, please wait..."
		mkdir -p ${BACKUPFOLDER}
		cp -r ${MIBPATH}/. ${BACKUPFOLDER}
		echo "Backup is done."
	fi
else
	FILENAME=${SDPATH##*/}
	if [ -f "$BACKUPFOLDER/$FILENAME" ]; then
		echo "Backup already exists. Skipping..."
	else
		echo "Copying file, please wait..."
		mkdir -p ${BACKUPFOLDER}
		cp ${MIBPATH} ${BACKUPFOLDER}/
		echo "Backup is done."
	fi
fi
echo
