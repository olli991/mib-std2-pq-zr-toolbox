#!/bin/ksh
echo "This script deactivates telnet, ftp and qconn access to the unit."
echo
slay inetd
slay telnetd
slay ftpd
slay qconn
pfctl -e

# Mount system as read only
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. External access is deactivated."
exit 0