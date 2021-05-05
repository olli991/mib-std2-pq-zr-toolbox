#!/bin/ksh
# This script will copy file(s)
# Created by Olli, based on scripts by Jille

echo

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

export DUMPFOLDER=$VOLUME/dump/$SDPATH

#Make dump folder if needed
if [ ! -d "$VOLUME/dump" ]; then
	echo "$VOLUME/dump not found, making a new one..."
	mkdir -p $VOLUME/dump
fi

echo "Source $TYPE: $MIBPATH"
echo "Destination folder: $DUMPFOLDER"
echo

# Create destination folder if needed
if [ ! -d "$DUMPFOLDER" ]; then
	echo "Creating folder" $DUMPFOLDER
	mkdir -p $DUMPFOLDER
fi

# Copying file(s)/folders
if [ -d "$DUMPFOLDER" ]; then
	echo "Copying file(s)/folder(s). This can take a while, please wait..."
	if [ "$TYPE" == "folder" ]; then
		cp -r ${MIBPATH}/* ${DUMPFOLDER}
		sync
		echo "Copying is completed." 
	elif [ -f $MIBPATH ]; then
		cp ${MIBPATH} ${DUMPFOLDER}
		sync
		echo "Copying is completed."
		if [[ "$TOPIC" == "fec" || "$TOPIC" == "shadow" ]]; then
			# Show the content of the copied file
			echo "Content of the copied file:"
			cat $DUMPFOLDER/*
		fi
	else
		echo "Cannot find: $MIBPATH, skipping..."
	fi
else
	echo "ERROR: Cannot create " $DUMPFOLDER
fi

echo
echo "Script execution is finished."
exit 0
