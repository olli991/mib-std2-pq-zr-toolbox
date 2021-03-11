#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /

sleep 1

/bin/cp -f /media/mp000/patch/hmi/tsd.mibstd2.hmi.ifs /tsd/hmi/tsd.mibstd2.hmi.ifs

sleep 1

/bin/chmod 777 /tsd/hmi/tsd.mibstd2.hmi.ifs

echo "... done ... enjoy... Component Protection is patched and cp is off ;) "
echo " ... now reboot this unit..."

 