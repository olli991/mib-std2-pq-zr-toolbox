#!/bin/ksh
# Script by YOX
# Info
export TSD_COMMON_CONFIG=/tsd/etc/system/tsd.mibstd2.main.root.conf
export TSD_LOGCHANNEL=J5e
DESCRIPTION="This script is activating telenet till next reboot"

echo $DESCRIPTION
echo
sleep 2

echo /net/J5/dev/ser1 \"/bin/login -f root\" qansi-m on > /net/J5/tmp/ttys
on -f imx6 /sbin/tinit -f /net/J5/tmp/ttys &
echo "Please wait"
sleep 10

on -p25 /tsd/bin/system/tsd.mibstd2.config.memwatch 4194304 'echo "\$mem" > /proc/dumper' &
on -f imx6 inetd
on -f imx6 qconn
on -f imx6 waitfor /dev/pf
on -f imx6 pfctl -d
echo "Telnet activated"
sleep 1

# Mount system as read/write
. /tsd/scripts/util_mount.sh
sleep 1

echo
echo "Connect D-Link and open up advanced menu again"
echo "The MU IP adress shown there now should be possibile to connect to"
echo "Login with: root / root"
echo "Have fun bricking your unit. You can close this screen now"

exit 0
