#!/bin/ksh
# Reset hook (sourced from runHMI.sh on every boot, BEFORE the HMI/JVM starts).
# Drop an empty file named "reset" at the root of SD1 or SD2 and reboot to recover:
#   1) delete the "reset" file FIRST, so a crash mid-recovery can't loop forever on reboot
#   2) run deactivate_aatokombi.sh (removes bootclasspath entry, restores stock libgal)
#   3) if that script itself is missing, fall back to restoring runHMI.sh straight from
#      its own backup
#   4) reboot ONLY if something was actually restored; otherwise leave the unit as-is
#      and let the user know there's nothing this hook can do
DEACT=/tsd/etc/persistence/esd/scripts/deactivate_aatokombi.sh
HMI_SH=/tsd/hmi/runHMI.sh
BU=/tsd/hmi/runHMI.sh.bak
WAIT_MAX=30

# When it launched in the BACKGROUND from runHMI.sh,
# /media/mp000 and /mp001 may not be mounted yet this early in boot, so this waits,
# off the critical boot path, up to WAIT_MAX seconds for either to appear.
_waited=0
while [ ! -d /media/mp000 ] && [ ! -d /media/mp001 ] && [ $_waited -lt $WAIT_MAX ]; do
	sleep 1
	_waited=$((_waited + 1))
done

for _m in /media/mp00[0-1]; do
	if [ -f "$_m/reset" ]; then
		rm -f "$_m/reset"
		sync
		if [ -f "$DEACT" ]; then
			ksh "$DEACT"
			. /tsd/etc/persistence/esd/scripts/util_reboot.sh
		elif [ -f "$BU" ]; then
			echo "deactivate_aatokombi.sh missing, restoring $HMI_SH from backup"
			. /tsd/etc/persistence/esd/scripts/util_mount.sh
			cp -f $BU $HMI_SH 2>&1
			chmod a+rx $HMI_SH
			. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
			. /tsd/etc/persistence/esd/scripts/util_reboot.sh
		else
			echo "Nothing to restore from: no deactivate script and no runHMI.sh backup found"
		fi
		break
	fi
done