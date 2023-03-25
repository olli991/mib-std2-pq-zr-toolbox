#!/bin/ksh
echo "This script activates console access until next unit reboot"
echo

if [ -d /net/imx6 ]; then
	echo /net/J5/dev/ser1 \"/bin/login -f root\" qansi-m on > /tmp/ttys
else
	echo /dev/ser1 \"/bin/login -f root\" qansi-m on > /tmp/ttys
fi
/sbin/tinit -f /tmp/ttys &

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh

echo
echo "Done. Set jumper on FT232R adapter to 5V position."
echo "Connect RX pin to pin 11(TX) of block A of the quadlock"
echo "Connect TX pin to pin 12(RX) of block A of the quadlock."
echo "Default login credentials: root / root"
echo "Be careful!"
exit 0