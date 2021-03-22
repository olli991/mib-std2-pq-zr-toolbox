#!/bin/ksh
# Info
export TOPIC=filesystem
export MIBPATH=/
export SDPATH=$TOPIC
export TYPE="folder"
DESCRIPTION="This script will dump the whole filesystem (without /dev) to SD card"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh
sleep 1

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh
sleep 1

#Make dump folder
DUMPFOLDER=$VOLUME/dump/$SDPATH

if [ -d "$DUMPFOLDER" ]; then
	echo "Dumping content recursively to dump folder on SD card"
	echo "This will take some time. Please wait"
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
else
	echo "Making dump folder"
	mkdir -p $DUMPFOLDER
	echo "Dumping content recursively to dump folder on SD card"
	echo "This will take some time. Please wait"
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
fi

echo "Dump done. Saved at dump/$SDPATH" 
echo 

sleep .5

exit 0
