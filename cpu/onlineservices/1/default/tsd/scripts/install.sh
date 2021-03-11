#!/bin/ksh

#Info
DESCRIPTION="This script will install/update the MIB2STD Toolbox"

echo $DESCRIPTION
sleep 2

# Mounting system volume
echo "Mounting system volume writeable"
/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /
sleep 2

# Copy GreenMenu screens
echo "Copying ESD files"
/bin/cp -r /media/mp000/install/esd/*.esd /tsd/etc/persistence/esd
/bin/cp /media/mp000/cpu/onlineservices/1/default/tsd/etc/persistence/esd/mib2std-main.esd /tsd/etc/persistence/esd
sleep 2

# Copy scripts
echo "Copying scripts"
/bin/cp -r /media/mp000/install/scripts/*.sh /tsd/scripts
/bin/cp /media/mp000/cpu/onlineservices/1/default/tsd/scripts/install.sh /tsd/scripts
/bin/chmod a+rwx /tsd/scripts/*.sh
sleep 2

echo "Installtion/Update done. Please restart GreenMenu!"

exit 0