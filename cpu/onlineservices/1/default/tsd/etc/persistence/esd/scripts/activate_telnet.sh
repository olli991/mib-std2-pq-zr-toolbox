#!/bin/ksh
# Script by YOX
export TSD_COMMON_CONFIG=/tsd/etc/system/tsd.mibstd2.main.root.conf
export TSD_LOGCHANNEL=J5e

echo "This script activates telnet, ftp and console access until next unit reboot"
echo
echo /net/J5/dev/ser1 \"/bin/login -f root\" qansi-m on > /net/J5/tmp/ttys
on -f imx6 /sbin/tinit -f /net/J5/tmp/ttys &
on -p25 /tsd/bin/system/tsd.mibstd2.config.memwatch 4194304 'echo "\$mem" > /proc/dumper' &
on -f imx6 inetd
on -f imx6 qconn
on -f imx6 waitfor /dev/pf
on -f imx6 pfctl -d

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh

echo "Telnet, ftp and console access are activated."
echo "Now you can connect with D-Link DUB-E100 over USB port or"
echo "WiFi if your unit supports it."
echo "Default credentials: root / root"
echo "Go to the previous menu to see IP address for connection."
echo
echo "Have fun bricking your unit :)"
exit 0