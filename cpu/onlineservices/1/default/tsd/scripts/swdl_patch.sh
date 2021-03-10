#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /

sleep 1

/bin/cp -f /media/mp000/patch/swdl/tsd.mibstd2.system.swdownload /tsd/bin/swdownload/tsd.mibstd2.system.swdownload

sleep 1

/bin/chmod 777 /tsd/bin/swdownload/tsd.mibstd2.system.swdownload

echo "... done ... enjoy... swdl is patched ;) "

 