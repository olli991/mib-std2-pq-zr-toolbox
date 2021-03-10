#!/bin/ksh

echo "Mounting system volume writeable"
/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /
sleep 2

echo "Copying ESD files"
/bin/cp -rv /media/mp000/cpu/onlineservices/1/default/tsd/etc/persistence/esd/*.esd /tsd/etc/persistence/esd
sleep 2

echo "Copying scripts"
/bin/cp -rv /media/mp000/cpu/onlineservices/1/default/tsd/scripts/*.sh /tsd/scripts
chmod a+rwx /tsd/scripts
sleep 2

echo "Update done. Please restart GreenMenu!"
