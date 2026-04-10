#!/bin/ksh
# MIB2 utility script, part of the MIB STD2 toolbox.
# Coded by Olli
# This script remounts the system partition in read/only mode

sync
mount -t qnx6 -o remount,ro /dev/hd0t177 /
echo "System partition is remounted in read/only mode"