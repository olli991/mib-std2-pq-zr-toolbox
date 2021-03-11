#!/bin/ksh

#Info
DESCRIPTION="This script will install the MIB2STD Toolbox"

echo $DESCRIPTION
echo
sleep 2

# Mounting system volume
echo "Mounting system volume writeable"
/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /
sleep 2

#Is there any SD card inserted?
if [ -d /media/mp000 ]
then
    echo "SD in slot 1 found"
    export VOLUME=/media/mp000
elif [ -d /media/mp001 ]
then
    echo "SD in slot 2 found"
    export VOLUME=/media/mp001
else 
    echo "No SD cards found"
    exit 0
fi

# Copy GreenMenu screens
echo "Copying ESD files"
/bin/cp -r $VOLUME/toolbox/install/esd/*.esd /tsd/etc/persistence/esd
sleep 2

# Copy scripts
echo "Copying scripts"
/bin/cp -r $VOLUME/toolbox/install/scripts/*.sh /tsd/scripts
/bin/chmod a+rwx /tsd/scripts/*.sh
sleep 2

echo "Installtion done. Please restart GreenMenu!"

exit 0