#!/bin/ksh

/bin/mount -t qnx6 -o remount,rw /dev/hd0t177 /
echo "System is now mounted as read/write"