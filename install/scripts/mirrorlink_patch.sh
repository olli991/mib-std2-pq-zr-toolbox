#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /

sleep 1

/bin/cp -f /media/mp000/patch/mirrorlink/mirrorlink.config.common.xml /tsd/etc/mirrorlink/mirrorlink.config.common.xml

sleep 1

/bin/chmod 777 /tsd/etc/mirrorlink/mirrorlink.config.common.xml

echo "... done ... enjoy... mirrorlink is patched ;) "

 