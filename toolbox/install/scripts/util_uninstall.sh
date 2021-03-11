#!/bin/ksh
# Original by Jille fpr MIB High toolbox
# Modified for MIB2STD toolbox by Olli

#Info
DESCRIPTION="This script will uninstall the MIB2STD Toolbox"

echo $DESCRIPTION
echo
sleep 2

# Mount system as read/write
. /tsd/scripts/util_mount.sh
sleep 1

# Deleting GreenMenu screens
echo "Deleting GreenMenus"
/bin/rm -r /tsd/etc/persistence/esd/mib2std-*.esd

# Delete old toolbox GreenMenu screens
OLD_1=/tsd/etc/persistence/esd/mibstd2_yox.esd
OLD_2=/tsd/etc/persistence/esd/TOOLBOX.esd
OLD_3=/tsd/etc/persistence/esd/mib2std_yox.esd
if [ -f $OLD_1 ]; then
	/bin/rm /tsd/etc/persistence/esd/mibstd2_yox.esd
fi
if [ -f $OLD_2 ]; then
	/bin/rm /tsd/etc/persistence/esd/TOOLBOX.esd
fi
if [ -f $OLD_3 ]; then
	/bin/rm /tsd/etc/persistence/esd/TOOLBOX.esd
fi
sleep 2

# Deleting scripts
echo "Deleting scripts"
/bin/rm -r /tsd/scripts
sleep 2

echo "Uninstall done. Please restart GreenMenu!"

exit 0
