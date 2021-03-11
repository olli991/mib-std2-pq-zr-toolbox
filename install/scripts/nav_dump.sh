#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /

sleep 1

/bin/cp -f /tsd/etc/nav/mibstd2_nav_target.ini /media/mp000/backup/nav

echo "mibstd2_nav_target.ini successfully dumped"

exit 0
