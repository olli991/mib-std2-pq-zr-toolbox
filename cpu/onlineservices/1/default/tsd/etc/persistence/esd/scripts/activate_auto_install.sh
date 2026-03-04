#!/bin/ksh
echo "This script activates auto-installation of toolbox from SD card on startup"
echo

HELPER=/tsd/var/toolbox_autoinstall.sh
MARKER="TOOLBOX_AUTOINSTALL"
STARTUP=/tsd/bin/system/startup

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh

# Write helper script to /tsd/var/ (survives ESD update)
echo "Writing helper script to $HELPER..."
echo '#!/bin/ksh' > $HELPER
echo 'sleep 15' >> $HELPER
echo '[ -f /tsd/etc/persistence/esd/scripts/util_update.sh ] && exit 0' >> $HELPER
echo 'for i in /media/mp00* /fs/* /mnt/*; do' >> $HELPER
echo '    [ -d "$i" ] || continue' >> $HELPER
echo '    if [ -f "$i/install.sh" ]; then' >> $HELPER
echo '        ksh $i/install.sh' >> $HELPER
echo '        exit 0' >> $HELPER
echo '    fi' >> $HELPER
echo 'done' >> $HELPER
chmod 777 $HELPER
echo "Done."

# Remove any existing hook (idempotency) and append new one
sed "/$MARKER/d" $STARTUP > /tmp/startup.tmp
mv -f /tmp/startup.tmp $STARTUP && chmod 777 $STARTUP
echo "[ -f $HELPER ] && ksh $HELPER & # $MARKER" >> $STARTUP
echo "Startup hook injected."

# Mount system as read/only
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Auto-install is activated."
echo "On next boot, toolbox will be reinstalled from SD card if missing (approx. 2 minutes after boot)."
exit 0
