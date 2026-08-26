#!/bin/ksh
# Reset hook. Launched in the BACKGROUND from runHMI.sh via "ksh check_reset.sh &"
# Drop an empty file named "reset" at the root of SD1 or SD2 and reboot to recover:
#   1) delete the "reset" file FIRST, so a crash mid-recovery can't loop forever on reboot
#   2) run every known deactivate script that exists
#   3) restore runHMI.sh wholesale: prefer a user-provided backup at
#      <sdcard>/backup/runHMI.sh, then fall back to the local runHMI.sh.bak --
#      this makes the hook reusable for ANY runHMI.sh patch
DEACT_SCRIPTS="/tsd/etc/persistence/esd/scripts/deactivate_aatokombi.sh"
# To add another mod's cleanup script in the future, just append it here, e.g.:
DEACT_SCRIPTS="$DEACT_SCRIPTS /tsd/etc/persistence/esd/scripts/deactivate_navignore.sh"
HMI_SH=/tsd/hmi/runHMI.sh
BU=/tsd/hmi/runHMI.sh.bak
SD_BU=/backup/runHMI.sh
WAIT_MAX=30

# /media/mp000 and /mp001 may not be mounted yet this early in boot, so this waits,
# off the critical boot path, up to WAIT_MAX seconds for either to appear.
_waited=0
while [ ! -d /media/mp000 ] && [ ! -d /media/mp001 ] && [ $_waited -lt $WAIT_MAX ]; do
	sleep 1
	_waited=$((_waited + 1))
done

for _m in /media/mp00[0-1]; do
	if [ -f "$_m/reset" ]; then
		LOG="$_m/reset.log"
		rm -f "$_m/reset"
		sync
		echo "$(date) reset hook fired, mount=$_m" >> "$LOG"

		for _d in $DEACT_SCRIPTS; do
			if [ -f "$_d" ]; then
				echo "$(date) running $_d" >> "$LOG"
				ksh "$_d" >> "$LOG" 2>&1
			else
				echo "$(date) $_d not found, skipping" >> "$LOG"
			fi
		done

		if [ -f "$_m$SD_BU" ]; then
			echo "$(date) restoring $HMI_SH from user-provided backup at $_m$SD_BU" >> "$LOG"
			. /tsd/etc/persistence/esd/scripts/util_mount.sh
			cp -f $_m$SD_BU $HMI_SH 2>&1 >> "$LOG"
			chmod a+rx $HMI_SH
			. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
		elif [ -f "$BU" ]; then
			echo "$(date) restoring $HMI_SH from local backup $BU" >> "$LOG"
			. /tsd/etc/persistence/esd/scripts/util_mount.sh
			cp -f $BU $HMI_SH 2>&1 >> "$LOG"
			chmod a+rx $HMI_SH
			. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
		else
			echo "$(date) no runHMI.sh backup found (neither SD nor local)" >> "$LOG"
		fi

		echo "$(date) rebooting" >> "$LOG"
		sync
		. /tsd/etc/persistence/esd/scripts/util_reboot.sh
		break
	fi
done