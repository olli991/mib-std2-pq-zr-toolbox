#!/bin/ksh
export TOPIC=greenmenu
export MIBPATH=/tsd/etc/persistence/esd
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will install custom Green Engineering Menus and scripts"
echo

# Make backup
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

# Copy file(s) to unit
NEWFILES=$VOLUME/custom/$SDPATH

echo "Copying" $NEWFILES "/*.esd to" $MIBPATH
echo "This can take some time, please wait..."
cp -r ${NEWFILES}/*.esd ${MIBPATH}
echo "Copying" $NEWFILES "/scripts/*.sh to" $MIBPATH
cp -r ${NEWFILES}/scripts/*.sh ${MIBPATH}/scripts

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
echo
echo "Done. Please reopen Green Engineering Menu"

exit 0
