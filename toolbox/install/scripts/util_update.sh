#!/bin/ksh

#Info
DESCRIPTION="This script will update the MIB2STD Toolbox"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later
. /tsd/scripts/util_checksd.sh
if [[ -z "$VOLUME" ]] 
then
	echo "No SD card found, quitting"
	exit 0
fi

# Mount system as read/write
. /tsd/scripts/util_mount.sh
sleep 1

# Updating GreenMenu screens
UPDATE_ESD=$VOLUME/toolbox/update/esd

if [ -f $UPDATE_ESD/*.esd ]; then
	echo "Updating GreenMenus screens from toolbox/update"
	/bin/mv -r $UPDATE_ESD/*.esd /tsd/etc/persistence/esd
else
	echo "No new GreenMenu screen found"
fi
sleep 2

# Updating scripts
UPDATE_SCRIPTS=$VOLUME/toolbox/update/scripts

if [ -f $UPDATE_SCRIPTS/*.sh ]; then
	echo "Updating scripts from toolbox/scripts"
	/bin/mv -r $UPDATE_SCRIPTS/*.sh /tsd/scripts
else
	echo "No new scripts found"
fi
sleep 2

echo "Update done. Please restart GreenMenu!"

exit 0
