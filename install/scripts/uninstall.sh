#!/bin/ksh

#Info
DESCRIPTION="This script will uninstall the MIB2STD Toolbox"

echo $DESCRIPTION
sleep 2

# Mounting system volume
echo "Mounting system volume writeable"
/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /
sleep 2

# Deleting GreenMenu screens
echo "Deleting GreenMenus"
/bin/rm -r /tsd/etc/persistence/esd/mib2std-*.esd

# Delete old toolbox GreenMenu screens
OLD_1=/tsd/etc/persistence/esd/mibstd2_yox.esd
OLD_2=/tsd/etc/persistence/esd/TOOLBOX.esd
if [ -f $OLD_1 ]; then
	/bin/rm /tsd/etc/persistence/esd/mibstd2_yox.esd
fi
if [ -f $OLD_2 ]; then
	/bin/rm /tsd/etc/persistence/esd/TOOLBOX.esd
fi
sleep 2

# Deleting scripts
echo "Deleting scripts"
/bin/rm -r /tsd/scripts
sleep 2

echo "Uninstall done. Please restart GreenMenu!"

exit 0
