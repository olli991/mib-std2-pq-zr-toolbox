#!/bin/ksh
export TOPIC=root
export MIBPATH=/
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump root filesystem without /dev to SD card or USB drive"
echo

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

#Make dump folder
DUMPFOLDER=$VOLUME/dump/$VERSION/$SERIAL/$SDPATH

#Make dump folder if needed
if [ ! -d "$DUMPFOLDER" ]; then
	echo "$DUMPFOLDER not found, making a new one..."
	mkdir -p $DUMPFOLDER
fi

echo "Dumping to $DUMPFOLDER, please wait..."
echo "Dumping /bin"
cp -r /bin ${DUMPFOLDER}
echo "/bin dump done"
echo
echo "Dumping /etc"
cp -r /etc ${DUMPFOLDER}
echo "/etc dump done"
echo
echo "Dumping /fw"
cp -r /fw ${DUMPFOLDER}
echo "/fw dump done"
echo
echo "Dumping /j9"
cp -r /j9 ${DUMPFOLDER}
echo "/j9 dump done"
echo
echo "Dumping /lib"
cp -r /lib ${DUMPFOLDER}
echo "/lib dump done"
echo
echo "Dumping /sbin"
cp -r /sbin ${DUMPFOLDER}
echo "/sbin dump done"
echo
echo "Dumping /tsd (this will take some time!)"
cp -r /tsd ${DUMPFOLDER}
echo "/tsd dump done"
echo
echo "Dumping /usr"
cp -r /usr ${DUMPFOLDER}
echo "/usr dump done"
echo

sync
echo
echo "Dump is done. Saved at $DUMPFOLDER"