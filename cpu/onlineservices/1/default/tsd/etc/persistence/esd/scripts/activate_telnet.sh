#!/bin/ksh
echo "This script activates telnet and ftp access until the next unit reboot"
echo
inetd
pfctl -d

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh

echo
echo "Telnet and ftp access are activated."
echo "Now you can connect D-Link DUB-E100 to USB port"
echo "or just connect over WiFi if your unit has it."
echo "Default login credentials: root / root"
echo "Go to the previous menu to see IP address for connection."
echo
echo "Have fun bricking your unit :)"
exit 0