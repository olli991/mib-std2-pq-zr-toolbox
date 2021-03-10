#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /

sleep 1

/bin/cp /media/mp000/fec/signed_exception_list.txt /tsd/etc/slist/
echo "... done ... enjoy... unit will reboot now... "

sleep 5

/bin/shutdown 