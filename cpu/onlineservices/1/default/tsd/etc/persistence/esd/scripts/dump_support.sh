#!/bin/ksh
# This script will copy file(s)
# Created by Olli, based on scripts by Jille

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

#Dumping SWAP file to SD
TOPIC=swap
MIBPATH=/tsd/bin/swap/tsd.mibstd2.system.swap
SDPATH=support/$TOPIC
TYPE="file"

DUMPFOLDER=$VOLUME/dump/$VERSION/$SERIAL/$SDPATH
echo "Source $TYPE: $MIBPATH"
echo "Destination: dump/$VERSION/$SERIAL/"
echo "  $SDPATH"

if [ -f $MIBPATH ]; then
	# Create destination and all intermediate folders if needed
	if [ ! -d "$DUMPFOLDER" ]; then
		echo "Creating folder..."
		mkdir -p $DUMPFOLDER
	fi
	echo "Copying, please wait..."
	cp ${MIBPATH} ${DUMPFOLDER}
	sync
	echo "Copying is completed."
else
	echo "ERROR: Cannot open $MIBPATH"
fi

echo 

#Dumping SWDL file to SD
TOPIC=swdl
MIBPATH=/tsd/bin/swdownload/tsd.mibstd2.system.swdownload
SDPATH=support/$TOPIC
TYPE="file"

DUMPFOLDER=$VOLUME/dump/$VERSION/$SERIAL/$SDPATH
echo "Source $TYPE: $MIBPATH"
echo "Destination: dump/$VERSION/$SERIAL/"
echo "  $SDPATH"

if [ -f $MIBPATH ]; then
	# Create destination and all intermediate folders if needed
	if [ ! -d "$DUMPFOLDER" ]; then
		echo "Creating folder..."
		mkdir -p $DUMPFOLDER
	fi
	echo "Copying, please wait..."
	cp ${MIBPATH} ${DUMPFOLDER}
	sync
	echo "Copying is completed."
else
	echo "ERROR: Cannot open $MIBPATH"
fi

echo 

#Dumping Audiomanager to SD
TOPIC=cp
MIBPATH=/net/J5/tsd/bin/audio/tsd.mibstd2.audio.audiomgr
SDPATH=support/$TOPIC
TYPE="file"

DUMPFOLDER=$VOLUME/dump/$VERSION/$SERIAL/$SDPATH
echo "Source $TYPE: $MIBPATH"
echo "Destination: dump/$VERSION/$SERIAL/"
echo "  $SDPATH"

if [ -f $MIBPATH ]; then
	# Create destination and all intermediate folders if needed
	if [ ! -d "$DUMPFOLDER" ]; then
		echo "Creating folder..."
		mkdir -p $DUMPFOLDER
	fi
	echo "Copying, please wait..."
	cp ${MIBPATH} ${DUMPFOLDER}
	sync
	echo "Copying is completed."
else
	echo "ERROR: Cannot open $MIBPATH"
fi

echo 

#Dumping startup to SD
TOPIC=cp
MIBPATH=/net/J5/tsd/bin/system/startup
SDPATH=support/$TOPIC
TYPE="file"

DUMPFOLDER=$VOLUME/dump/$VERSION/$SERIAL/$SDPATH
echo "Source $TYPE: $MIBPATH"
echo "Destination: dump/$VERSION/$SERIAL/"
echo "  $SDPATH"

if [ -f $MIBPATH ]; then
	# Create destination and all intermediate folders if needed
	if [ ! -d "$DUMPFOLDER" ]; then
		echo "Creating folder..."
		mkdir -p $DUMPFOLDER
	fi
	echo "Copying, please wait..."
	cp ${MIBPATH} ${DUMPFOLDER}
	sync
	echo "Copying is completed."
else
	echo "ERROR: Cannot open $MIBPATH"
fi

echo
echo "Script execution has finished."
exit 0