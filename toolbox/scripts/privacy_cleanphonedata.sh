#!/bin/sh
# Coded by Jille for MIB2 High Toolbox
# Modified by Olli for MIB2STD Toolbox
# Info
DESCRIPTION="This script will remove all stored contact info"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # for later

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh
sleep 1

# Deleting
PHONEPATH=/tsd/var/organizer

if [ -d $PHONEPATH/database ]; then
	echo "Deleting contacts database"
	rm -r -f $PHONEPATH/database/*
	sleep 1
	echo "Done. Your sored phone contacts are deleted"
else
	echo "No contacts databse found"
fi
if [ -d $PHONEPATH/photo ]; then
	echo "Deleting contacts photos"
	rm -r -f $PHONEPATH/photo/*
	sleep 1
	echo "Done. Your sored contacts photos are deleted"
else
	echo "No contacts photos found"
fi

exit 0
