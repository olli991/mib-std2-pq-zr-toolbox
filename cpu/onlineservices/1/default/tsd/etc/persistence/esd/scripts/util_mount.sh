#!/bin/ksh
# MIB2 utility script, part of the MIB STD2 Toolbox.
# Coded by Olli
# This script remounts system partition in read/write mode

mount -t qnx6 -o remount,rw /dev/hd0t177 /
echo "System partition is remounted in read/write mode"