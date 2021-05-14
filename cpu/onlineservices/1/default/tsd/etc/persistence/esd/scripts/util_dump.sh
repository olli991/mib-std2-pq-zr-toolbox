#!/bin/ksh
# This script will copy file(s)
# Created by Olli, based on scripts by Jille

echo

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

DUMPFOLDER=$VOLUME/dump/$VERSION/$SERIAL/$SDPATH
echo "Source $TYPE: $MIBPATH"
echo "Destination: dump/$VERSION/$SERIAL/$SDPATH"

if [ "$TYPE" = "file" ]; then
	if [ -f $MIBPATH ]; then
		# Create destination and all intermediate folders if needed
		if [ ! -d "$DUMPFOLDER" ]; then
			echo "Creating folder $DUMPFOLDER..."
			mkdir -p $DUMPFOLDER
		fi
		echo "Copying to: $DUMPFOLDER, please wait..."
		cp ${MIBPATH} ${DUMPFOLDER}
		sync
		echo "Copying is completed."
		if [[ $TOPIC = "fec" || $TOPIC = "shadow" ]]; then
			# Show the content of the copied file
			echo "Content of the file:"
			cat ${MIBPATH}
		fi
	else
		echo "ERROR: Cannot open $MIBPATH"
	fi
elif [ -d $MIBPATH ]; then
	# Create destination and all intermediate folders if needed
	if [ ! -d "$DUMPFOLDER" ]; then
		echo "Creating folder $DUMPFOLDER..."
		mkdir -p $DUMPFOLDER
	fi
	echo "Copying to $DUMPFOLDER, please wait..."
	cp -r ${MIBPATH}/. ${DUMPFOLDER}
	sync
	echo "Copying is completed." 
else
	echo "ERROR: Cannot open $MIBPATH"
fi

echo
echo "Script execution has finished."
exit 0
