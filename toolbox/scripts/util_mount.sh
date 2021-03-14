#!/bin/ksh
# MIB2 utility script, part of the MIB2STD toolbox.
# Coded by Olli
# This script mounts the system partition as read/write

mount -t qnx6 -o remount,rw /dev/hd0t177 /
echo "System is now mounted as read/write"