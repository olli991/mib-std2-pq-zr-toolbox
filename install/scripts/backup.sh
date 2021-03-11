#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /
sleep 2
/bin/cp /tsd/bin/swap/tsd.mibstd2.system.swap     /media/mp000/backup/swap/
echo "...swap is done... ;) "
sleep 2
/bin/cp /tsd/bin/swdownload/tsd.mibstd2.system.swdownload     /media/mp000/backup/swdl/
echo "...swdl is done...  "
echo " WAIT FOR "HMI" ... DO NOT REMOVE SD CARD !!! "
sleep 2
/bin/cp /tsd/hmi/tsd.mibstd2.hmi.ifs     /media/mp000/backup/hmi/
echo "...hmi is done... now you can remove sd card and patch it ;) "
                                           