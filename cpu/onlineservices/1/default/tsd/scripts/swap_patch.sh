#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /

sleep 1

/bin/cp -f /media/mp000/patch/swap/tsd.mibstd2.system.swap /tsd/bin/swap/tsd.mibstd2.system.swap

sleep 1

/bin/chmod 777 /tsd/bin/swap/tsd.mibstd2.system.swap

echo "... done ... enjoy... swap is patched ;) "
echo "... reboot this unit now ;) "

 