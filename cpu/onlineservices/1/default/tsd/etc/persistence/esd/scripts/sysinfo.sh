#!/bin/ksh
echo "Date:"
date

echo
echo "J5 OS version:"
on -n J5 uname -a

echo
echo "iMX6 OS version:"
uname -a

echo
echo "Shell version:"
echo $KSH_VERSION

echo
echo "iMX6 memory:"
showmem -S

echo
echo "J5 memory:"
on -n J5 showmem -S

echo
echo "Processes running:"
ps -A

echo
echo "Mounts:"
mount

echo
echo "Filesystem                  Size       Used       Avail      Use%   Mounted on"
df -h

echo
echo "Filesystem root:"
ls -C /

echo
echo "Interface config:"
ifconfig

echo
echo "USB info:"
usb