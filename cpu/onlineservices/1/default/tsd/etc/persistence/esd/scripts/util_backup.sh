#!/bin/ksh
# MIB2 utility script, part of the MIB High toolbox.
# Coded by Jille
# This script will make a backup if it's not already there
# Modified for MIB STD2 toolbox by Olli

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

export BACKUPFOLDER=$VOLUME/backup/$SDPATH

echo "Backup type: $TYPE"
echo "Source: $MIBPATH"
echo "Destination: $BACKUPFOLDER"

if [ "$TYPE" == "folder" ]; then
	if [ -d "${BACKUPFOLDER}" ]; then
		echo "Backup already exists. Skipping..."
	else
		echo "Making backup. This can take some time, please wait..."
		mkdir -p ${BACKUPFOLDER}
		cp -r ${MIBPATH}/* ${BACKUPFOLDER}
		echo "Backup is done."
	fi
else
	if [ -f "${BACKUPFOLDER}" ]; then
		echo "Backup already exists. Skipping..."
	else
		echo "Making backup. This can take some time, please wait..."
		mkdir -p $VOLUME/backup/$TOPIC
		cp ${MIBPATH} ${BACKUPFOLDER}
		echo "Backup is done."
	fi
fi
echo
