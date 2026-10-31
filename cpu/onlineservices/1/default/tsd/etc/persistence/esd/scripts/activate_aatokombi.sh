#!/bin/ksh
# AAtoKombi (MST2 port) installer — Android Auto navigation on the instrument cluster.
# Installs BOTH required parts:
#   * AAtoKombi.jar               -> /tsd/hmi/HMI/jar/, loaded via runHMI.sh bootclasspath
#   * patched libgal (the shim)   -> /tsd/lib/sal/gal/, feeds turn-by-turn to /dev/shmem/aa_nav
JAR_DIR="/tsd/hmi/HMI/jar/"
JAR=AAtoKombi.jar
HMI_SH=/tsd/hmi/runHMI.sh
BU=/tsd/hmi/runHMI.sh.bak
HOOK_SH=/tsd/etc/persistence/esd/scripts/check_reset.sh
GAL_DIR=/tsd/lib/sal/gal
GAL=libext.google.gal.receiver.so
GAL_BU=$GAL_DIR/$GAL.aatokombi.bak

export TOPIC=aatokombi
export MIBPATH=$HMI_SH
export SDPATH=$TOPIC/runHMI.sh
export TYPE="file"

echo "This script installs AAtoKombi: Android Auto turn-by-turn navigation on the cluster."
echo "NOTE: NEVER interrupt the process with -Back- button or removing SD Card!"
echo

# Train/volume helpers from the toolbox
. /tsd/etc/persistence/esd/scripts/util_info.sh
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

JAR_SRC=$VOLUME/custom/java/$JAR
GAL_SRC=$VOLUME/custom/sal/$GAL

# --- pre-flight gates: do NOTHING unless every required input/target is in place ---
if [ ! -e "$JAR_SRC" ]; then
	echo "Aborted. Missing on SD: custom/java/$JAR"
	exit 1
fi
if [ ! -e "$GAL_SRC" ]; then
	echo "Aborted. Missing on SD: custom/sal/$GAL"
	echo "Build the patched libgal from THIS unit's own libgal first (see the project README;"
	echo "use the 'Dump AAtoKombi build sources' menu item to extract the stock files)."
	exit 1
fi
if [ ! -f "$HMI_SH" ]; then
	echo "Aborted. $HMI_SH not found — wrong unit/platform?"
	exit 1
fi
# A valid stock libgal must exist to back up (the live file, or a .bak from a prior install),
# otherwise Disable could not restore the unit to stock.
if [ ! -f "$GAL_DIR/$GAL" ] && [ ! -f "$GAL_BU" ]; then
	echo "Aborted. Stock $GAL_DIR/$GAL not found and no backup exists — cannot guarantee a safe restore."
	exit 1
fi
if [ ! -f "$HOOK_SH" ]; then
	echo "Aborted. $HOOK_SH missing on unit -- toolbox install looks incomplete."
	exit 1
fi

# Mount system partition read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh

# --- 1) install the jar, and verify the copy actually landed (guard against a ro partition) ---
echo -ne "-- Installing $JAR...\n"
cp -f $JAR_SRC $JAR_DIR$JAR 2>&1
chmod a+rwx $JAR_DIR$JAR
JSRC_SZ=$(ls -la $JAR_SRC 2>/dev/null | awk '{print $5}')
JDST_SZ=$(ls -la $JAR_DIR$JAR 2>/dev/null | awk '{print $5}')
if [ -z "$JDST_SZ" ] || [ "$JSRC_SZ" != "$JDST_SZ" ]; then
	echo "ERROR: $JAR did not copy (src=$JSRC_SZ dst=$JDST_SZ). Nothing else changed; aborting."
	. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
	exit 1
fi
echo "$JAR installed."

# --- 2) install the patched GAL receiver library, with stock backup + size verify ---
echo -ne "-- Installing AA-nav GAL patch...\n"
if [ ! -f "$GAL_BU" ]; then
	echo "Backup $GAL_DIR/$GAL -> $GAL_BU"
	cp $GAL_DIR/$GAL $GAL_BU 2>&1
fi
cp -f $GAL_SRC $GAL_DIR/$GAL 2>&1
chmod a+rx $GAL_DIR/$GAL
SRC_SZ=$(ls -la $GAL_SRC 2>/dev/null | awk '{print $5}')
DST_SZ=$(ls -la $GAL_DIR/$GAL 2>/dev/null | awk '{print $5}')
if [ -z "$DST_SZ" ] || [ "$SRC_SZ" != "$DST_SZ" ]; then
	echo "ERROR: GAL copy did NOT verify (src=$SRC_SZ dst=$DST_SZ)."
	echo "Restoring stock libgal and removing the jar so the unit stays stock."
	cp -f $GAL_BU $GAL_DIR/$GAL 2>&1
	chmod a+rx $GAL_DIR/$GAL
	rm -f $JAR_DIR$JAR
	. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
	exit 1
fi
echo "GAL receiver patched and verified (size $DST_SZ)."

# --- 3) reset hook FIRST (safety net goes in before the risky patch) ---
if ! grep -q 'check_reset.sh' ${HMI_SH}; then
	if [ ! -f $BU ]; then
		echo "Backup $HMI_SH"
		cp $HMI_SH $BU 2>&1
		. /tsd/etc/persistence/esd/scripts/util_backup.sh
	fi
	echo "Adding reset hook to $HMI_SH"
	sed -i "1a\ksh $HOOK_SH &" $HMI_SH
	echo "Reset hook installed."
else
	echo "Reset hook already present in $HMI_SH."
fi

# --- 4) only now patch runHMI.sh bootclasspath (so a failure above never leaves a dangling bootclasspath) ---
if ! grep -q '$BOOTCLASSPATH -Xbootclasspath/p:$MIBJAR/AAtoKombi.jar' ${HMI_SH}; then
	if [ ! -f $BU ]; then
		echo "Backup $HMI_SH"
		cp $HMI_SH $BU 2>&1
		# Make backup to SD
		. /tsd/etc/persistence/esd/scripts/util_backup.sh
	fi
	echo "Patching $HMI_SH to load $JAR via bootclasspath"
	sed -i '/^BOOTCLASSPATH="\$BOOTCLASSPATH/!s/\(^BOOTCLASSPATH=.*$\)/\1\nBOOTCLASSPATH="$BOOTCLASSPATH -Xbootclasspath\/p:$MIBJAR\/AAtoKombi.jar"/' $HMI_SH
	echo "$HMI_SH is patched."
else
	echo "$HMI_SH is already patched."
fi

# Mount system partition read/only
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Completed. Please reboot the unit to apply changes."
echo "If something does not work as expected, use the Disable function or restore,"
echo "or drop an empty file named 'reset' at the root of sd card and reboot."
exit 0
