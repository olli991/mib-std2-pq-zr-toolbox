#!/bin/ksh
# Coded by Jille for MIB2 High Toolbox
# Modified by Olli for MIB STD2 Toolbox

echo "This script will remove all update logs from SWDL menu"
echo

LOGPATH=/tsd/var/swdownload/swdlhistory

# Deleting
if [ -f $LOGPATH/swdownload1.conf ]; then
	echo "Deleting SWDL history"
	rm -r -f $LOGPATH/*
	sync
	echo "Done. Your updates are now no longer visible"
else
	echo "SWDL history folder is already empty"
fi

exit 0
