#!/bin/ksh
# This script will copy file(s)
# Created by Olli, based on scripts by Jille

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

# Dumping SWAP file to SD
TOPIC=swap
MIBPATH=/tsd/bin/swap/tsd.mibstd2.system.swap
SDPATH=support/$TOPIC
TYPE="file"

DUMPFOLDER=$VOLUME/dump/$TRAIN/$SERIAL/$SDPATH
echo "Source $TYPE: $MIBPATH"
echo "Destination: dump/$TRAIN/$SERIAL/"
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

# Include files from backup if present
echo "Include backup files if present..."

BACKUPFOLDER=$VOLUME/backup/$TRAIN/$SERIAL/$TOPIC
DUMPFOLDER2=$DUMPFOLDER/backup
if [ -d "$BACKUPFOLDER" ]; then
	echo "Files found!"
	if [ ! -d "$DUMPFOLDER2" ]; then
		echo "Creating folder..."
		mkdir -p $DUMPFOLDER2
	fi
	echo "Copying, please wait..."
	cp -r ${BACKUPFOLDER}/. ${DUMPFOLDER2}
	sync
	echo "Copying is completed."
else
	echo "No backup found for SWAP. Nothing to include."
fi
echo "25% done, please wait..."
echo 

#Dumping SWDL file to SD
TOPIC=swdl
MIBPATH=/tsd/bin/swdownload/tsd.mibstd2.system.swdownload
SDPATH=support/$TOPIC
TYPE="file"

DUMPFOLDER=$VOLUME/dump/$TRAIN/$SERIAL/$SDPATH
echo "Source $TYPE: $MIBPATH"
echo "Destination: dump/$TRAIN/$SERIAL/"
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

# Include files from backup if present
echo "Include backup files if present..."

BACKUPFOLDER=$VOLUME/backup/$TRAIN/$SERIAL/$TOPIC
DUMPFOLDER2=$DUMPFOLDER/backup
if [ -d "$BACKUPFOLDER" ]; then
	echo "Files found!"
	if [ ! -d "$DUMPFOLDER2" ]; then
		echo "Creating folder..."
		mkdir -p $DUMPFOLDER2
	fi
	echo "Copying, please wait..."
	cp -r ${BACKUPFOLDER}/. ${DUMPFOLDER2}
	sync
	echo "Copying is completed."
else
	echo "No backup found for SWDL. Nothing to include."
fi
echo "50% done, please wait..."
echo 

# Dumping Audiomanager to SD
TOPIC=cp
if [ -d /net/imx6 ]; then
	MIBPATH=/net/J5/tsd/bin/audio/tsd.mibstd2.audio.audiomgr
else
	mount_ifs -f /tsd/bin/ifs/system.ifs -m /tmp
	MIBPATH=/tmp/tsd/bin/audio/tsd.mibstd2.audio.audiomgr
fi
SDPATH=support/$TOPIC
TYPE="file"

DUMPFOLDER=$VOLUME/dump/$TRAIN/$SERIAL/$SDPATH
echo "Source $TYPE: $MIBPATH"
echo "Destination: dump/$TRAIN/$SERIAL/"
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
echo "75% done, please wait..."
echo 

# Dumping startup to SD
TOPIC=cp
if [ -d /net/imx6 ]; then
	MIBPATH=/net/J5/tsd/bin/system/startup
else
	MIBPATH=/tsd/bin/system/startup
fi
SDPATH=support/$TOPIC
TYPE="file"

DUMPFOLDER=$VOLUME/dump/$TRAIN/$SERIAL/$SDPATH
echo "Source $TYPE: $MIBPATH"
echo "Destination: dump/$TRAIN/$SERIAL/"
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
echo "95% done, please wait..."
echo

# Include short sysinfo and persistence
echo "Saving system informations..."
. /tsd/etc/persistence/esd/scripts/util_sysinfo.sh >$DUMPFOLDER/sysinfo.txt
cp -f /tsd/var/persistence/.persistence.vault $DUMPFOLDER/persistence.vault
if [ -f /tsd/var/itr.timer.log ], then
   cp -f /tsd/var/itr.timer.log $DUMPFOLDER/
fi

echo
echo "100% - Script execution has finished."
exit 0