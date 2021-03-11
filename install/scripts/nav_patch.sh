#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /

sleep 1

/bin/cp -f /media/mp000/patch/nav/mibstd2_nav_target.ini /tsd/etc/nav/mibstd2_nav_target.ini

sleep 1

/bin/chmod 777 /tsd/etc/nav/mibstd2_nav_target.ini

echo "... done ... enjoy... nav_CID is patched ;) "

 