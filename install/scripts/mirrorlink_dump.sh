#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /

sleep 1

/bin/cp -f /tsd/etc/mirrorlink/mirrorlink.config.common.xml /media/mp000/backup/mirrorlink

echo "mirrorlink.config.common.xml successfully dumped"

exit 0
