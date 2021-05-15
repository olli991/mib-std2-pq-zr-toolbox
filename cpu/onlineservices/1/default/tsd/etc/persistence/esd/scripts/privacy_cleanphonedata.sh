#!/bin/ksh
# Coded by Jille for MIB2 High Toolbox
# Modified by Olli for MIB STD2 Toolbox
export TOPIC=phonedata
export MIBPATH=/tsd/var/organizer
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script removes contacts database and photos from organizer"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Deleting phone data
if [ -d $MIBPATH/database ]; then
	echo "Deleting contacts database at $MIBPATH/database"
	rm -rf $MIBPATH/database/*
	sync
	echo "Done. Stored phone contacts are deleted"
	echo "Please restart the unit."
else
	echo "No contacts database found"
fi
if [ -d $MIBPATH/photo ]; then
	echo "Deleting contacts photos at $MIBPATH/photo"
	rm -rf $MIBPATH/photo/*
	sync
	echo "Done. Stored contact photos are deleted"
	echo "Please restart the unit."
else
	echo "No contact photos found"
fi

exit 0