#!/bin/ksh
# Coded by Jille for MIB2 High Toolbox
# Modified by Olli for MIB STD2 Toolbox

echo "This script removes contacts database and photos from organizer"
echo

PHONEPATH=/tsd/var/organizer

if [ -d $PHONEPATH/database ]; then
	echo "Deleting contacts database at $PHONEPATH/database"
	rm -r -f $PHONEPATH/database/*
	echo "Done. Stored phone contacts are deleted"
else
	echo "No contacts database found"
fi
if [ -d $PHONEPATH/photo ]; then
	echo "Deleting contacts photos at $PHONEPATH/photo"
	rm -r -f $PHONEPATH/photo/*
	echo "Done. Stored contact photos are deleted"
else
	echo "No contact photos found"
fi

sync

exit 0
