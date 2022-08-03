#!/bin/ksh
export TOPIC=greenmenu
export MIBPATH=/tsd/etc/persistence/esd
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will install custom Green Engineering Menus and scripts"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh

echo "Setting execution attributes to scripts..."
chmod a+rwx /tsd/etc/persistence/esd/scripts/*.sh
echo "Done."

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. Please reopen Green Engineering Menu"
exit 0