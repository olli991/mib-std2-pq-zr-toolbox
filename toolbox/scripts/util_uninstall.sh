#!/bin/ksh
# Original by Jille for MIB High toolbox.
# This script will uninstall the toolbox.
# Modified for MIB2STD toolbox by Olli

# Info
DESCRIPTION="This script will uninstall the MIB2STD Toolbox"

echo $DESCRIPTION
echo
sleep 2

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh
sleep 1

# Deleting GreenMenu screens
echo "Deleting GreenMenus"
rm -r /tsd/etc/persistence/esd/mib2std-*.esd

# Delete old toolbox GreenMenu screens if present
OLD_1=/tsd/etc/persistence/esd/mibstd2_yox.esd
OLD_2=/tsd/etc/persistence/esd/TOOLBOX.esd
OLD_3=/tsd/etc/persistence/esd/mib2std_yox.esd

if [ -f $OLD_1 ]; then
	rm /tsd/etc/persistence/esd/mibstd2_yox.esd
fi
if [ -f $OLD_2 ]; then
	rm /tsd/etc/persistence/esd/TOOLBOX.esd
fi
if [ -f $OLD_3 ]; then
	rm /tsd/etc/persistence/esd/mib2std_yox.esd
fi
sleep 2

# Deleting scripts
echo "Deleting scripts"
rm -r /tsd/etc/persistence/esd/scripts
echo

# Delete old script folder if present
OLD_SCRIPTS_FOLDER=/tsd/scripts

if [ -d $OLD_SCRIPTS_FOLDER ]; then
	rm -r /tsd/scripts
fi
sleep 1

echo "Uninstall done. Please restart GreenMenu!"

exit 0
