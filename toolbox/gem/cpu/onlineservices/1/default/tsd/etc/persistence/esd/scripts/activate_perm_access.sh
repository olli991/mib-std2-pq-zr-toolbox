#!/bin/ksh
echo "This script activates permanent telnet and console access"
echo
sed '/echo \/net\/J5\/dev\/ser1 \\"\/bin\/login -f root\\" qansi-m on >\/tmp\/ttys/d' /tsd/bin/system/startup >/tmp/startup.tmp
sed '/\/sbin\/tinit -f \/tmp\/ttys \&/d' /tmp/startup.tmp >/tmp/startup1.tmp
sed '/inetd/d' /tmp/startup1.tmp >/tmp/startup.tmp
sed '/sleep 0.5/ainetd' /tmp/startup.tmp >/tmp/startup1.tmp
sed '/inetd/a\/sbin\/tinit -f \/tmp\/ttys \&' /tmp/startup1.tmp >/tmp/startup.tmp
sed '/inetd/aecho \/net\/J5\/dev\/ser1 \\\"\/bin\/login -f root\\\" qansi-m on \>\/tmp\/ttys' /tmp/startup.tmp >/tmp/startup1.tmp
sed '/pass in all/d' /tsd/etc/networking/pf.conf >/tmp/startup.tmp
echo 'pass in all' >>/tmp/startup.tmp
. /tsd/etc/persistence/esd/scripts/util_mount.sh
mv -f /tmp/startup1.tmp /tsd/bin/system/startup
chmod 777 /tsd/bin/system/startup
mv -f /tmp/startup.tmp /tsd/etc/networking/pf.conf
chmod 777 /tsd/etc/networking/pf.conf
sync
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Permanent telnet and console access are activated."
echo "Now you can reboot the unit and connect with D-Link"
echo "DUB-E100 over USB port or via WiFi if your unit has it."
echo "Default login credentials: root / root"
echo "Keeping permanent access in public places is not safe,"
echo "so disable it as soon as you do not need it!"
exit 0