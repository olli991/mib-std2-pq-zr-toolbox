#!/bin/ksh
# AAtoKombi (MST2 port) uninstaller — restores the unit to stock.
# Recovery path: runs WITHOUT needing the toolbox SD card. It removes our bootclasspath line and
# the jar, and restores the stock libgal from the on-device backup. It also takes the DisplayManager
# hook (libkb_dm.so) out of cpu.conf and removes AAtoKombi's own Green Engineering Menu, if installed.
JAR_DIR="/tsd/hmi/HMI/jar/"
JAR=AAtoKombi.jar
HMI_SH=/tsd/hmi/runHMI.sh
GAL_DIR=/tsd/lib/sal/gal
GAL=libext.google.gal.receiver.so
GAL_BU=$GAL_DIR/$GAL.aatokombi.bak
AKB_UTIL=/tsd/etc/persistence/esd/scripts/util_aatokombi.sh

echo "This script removes AAtoKombi from the unit."
echo "NOTE: NEVER interrupt the process with -Back- button or by powering off!"
echo

# Mount system partition read/write (util_mount is self-contained; no SD required)
. /tsd/etc/persistence/esd/scripts/util_mount.sh

echo -ne "-- Removing AAtoKombi...\n"
# Surgically delete ONLY our own line. We deliberately do NOT restore the shared
# /tsd/hmi/runHMI.sh.bak backup, so other mods that patch runHMI.sh (e.g. navignore)
# and their restore point stay intact. Removing only our line returns runHMI.sh to its
# pre-AAtoKombi state regardless of what else is installed.
if grep -q 'AAtoKombi.jar' ${HMI_SH} 2>/dev/null; then
	sed -i '/AAtoKombi.jar/d' $HMI_SH
	echo "Removed AAtoKombi bootclasspath entry from $HMI_SH."
else
	echo "$HMI_SH has no AAtoKombi entry."
fi

if [ -f $JAR_DIR$JAR ]; then
	rm -f $JAR_DIR$JAR
	echo "$JAR removed from unit."
fi

# --- restore the stock GAL receiver library; only drop the backup once the restore verifies ---
if [ -f "$GAL_BU" ]; then
	cp -f $GAL_BU $GAL_DIR/$GAL 2>&1
	chmod a+rx $GAL_DIR/$GAL
	BAK_SZ=$(ls -la $GAL_BU 2>/dev/null | awk '{print $5}' 2>/dev/null)
	NEW_SZ=$(ls -la $GAL_DIR/$GAL 2>/dev/null | awk '{print $5}' 2>/dev/null)
	if [ -n "$NEW_SZ" ] && [ "$BAK_SZ" = "$NEW_SZ" ]; then
		rm -f $GAL_BU
		echo "Restored original GAL receiver library."
	else
		echo "WARNING: GAL restore did NOT verify (backup=$BAK_SZ live=$NEW_SZ)."
		echo "Keeping the backup ($GAL_BU) so you can retry Disable. The unit may still be patched."
	fi
else
	echo "GAL receiver library was not patched (nothing to restore)."
fi

# --- DisplayManager hook and AAtoKombi's own menu (helpers come with the toolbox) ---
if [ -f "$AKB_UTIL" ]; then
	. $AKB_UTIL
	if akb_dm_installed || [ -f $AKB_DM_LIB ]; then
		akb_dm_remove
	else
		echo "DisplayManager hook was not installed."
	fi
	if ls /tsd/etc/persistence/esd/aatokombi*.esd /tsd/etc/persistence/esd/scripts/aatokombi_*.sh >/dev/null 2>&1; then
		akb_menu_remove
		echo "AAtoKombi menu removed."
	fi
elif grep -q 'libkb_dm.so' /tsd/etc/system/cpu.conf 2>/dev/null; then
	echo "WARNING: $AKB_UTIL is missing, the DisplayManager hook stays in cpu.conf."
	echo "Reinstall the toolbox and run Disable again."
fi

# Mount system partition read/only
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Completed. Please reboot the unit to apply changes."
exit 0
