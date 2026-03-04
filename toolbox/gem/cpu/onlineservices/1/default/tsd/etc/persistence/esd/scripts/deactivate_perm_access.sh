#!/bin/ksh
echo "This script deactivates permanent telnet and console access"
echo
sed '/echo \/net\/J5\/dev\/ser1 \\"\/bin\/login -f root\\" qansi-m on >\/tmp\/ttys/d' /tsd/bin/system/startup >/tmp/startup.tmp
sed '/\/sbin\/tinit -f \/tmp\/ttys \&/d' /tmp/startup.tmp >/tmp/startup1.tmp
sed '/inetd/d' /tmp/startup1.tmp >/tmp/startup.tmp
sed '/pass in all/d' /tsd/etc/networking/pf.conf >/tmp/startup1.tmp
sed '/pass in all/d' /tsd/etc/networking/pf_wlan.conf >/tmp/startup2.tmp
. /tsd/etc/persistence/esd/scripts/util_mount.sh
mv -f /tmp/startup.tmp /tsd/bin/system/startup && chmod 777 /tsd/bin/system/startup
mv -f /tmp/startup1.tmp /tsd/etc/networking/pf.conf && chmod 777 /tsd/etc/networking/pf.conf
mv -f /tmp/startup2.tmp /tsd/etc/networking/pf_wlan.conf && chmod 777 /tsd/etc/networking/pf_wlan.conf
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
echo
echo "Permanent telnet and console access are deactivated."
echo "Please reboot the unit."
exit 0