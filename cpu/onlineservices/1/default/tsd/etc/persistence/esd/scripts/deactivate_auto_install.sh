#!/bin/ksh
echo "This script deactivates auto-installation of toolbox from SD card on startup"
echo

HELPER=/tsd/var/toolbox_autoinstall.sh
MARKER="TOOLBOX_AUTOINSTALL"
STARTUP=/tsd/bin/system/startup

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh

# Remove hook from startup
sed "/$MARKER/d" $STARTUP > /tmp/startup.tmp
mv -f /tmp/startup.tmp $STARTUP && chmod 777 $STARTUP
echo "Startup hook removed."

# Remove helper script
rm -f $HELPER
echo "Helper script removed."

# Mount system as read/only
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Auto-install is deactivated."
exit 0
