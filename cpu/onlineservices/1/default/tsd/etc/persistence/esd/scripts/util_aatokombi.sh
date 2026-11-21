#!/bin/ksh
# AAtoKombi helpers, sourced by activate_aatokombi.sh and deactivate_aatokombi.sh (not a menu item).
# The caller has the system partition mounted read/write. Every function prints what it did and
# returns 0 on success, 1 when it changed nothing.
#
#   akb_dm_install <libkb_dm.so>  DisplayManager hook for the Android Auto map on the cluster: copy,
#                                 self check on this unit, then one edit of the LD_PRELOAD line of
#                                 "service iMX6.DispMg" in cpu.conf (stock copy kept once)
#   akb_dm_installed              is the hook named in cpu.conf?
#   akb_dm_remove                 take the hook out of cpu.conf, then delete the library
#   akb_menu_install <dir>        AAtoKombi's own Green Engineering Menu from the SD card's
#                                 custom/greenmenu/: <dir>/aatokombi*.esd and
#                                 <dir>/scripts/aatokombi_*.sh, to the same places the toolbox's
#                                 "Copy custom Green Engineering Menu" puts them
#   akb_menu_remove               remove aatokombi*.esd and scripts/aatokombi_*.sh from the unit
#                                 (the toolbox's own *_aatokombi*.sh scripts do not match)
#
# DANGER (DisplayManager hook): a library named in LD_PRELOAD that cannot be loaded keeps
# DisplayManager from starting and the unit resets. akb_dm_install therefore copies, compares and
# lets the library CHECK ITSELF on this unit before cpu.conf refers to it, and akb_dm_remove never
# deletes the library while cpu.conf still names it.
AKB_LIBDIR=/tsd/lib/aatokombi
AKB_DM_LIB=$AKB_LIBDIR/libkb_dm.so
AKB_CPU=/tsd/etc/system/cpu.conf
AKB_VAR=/tsd/var/aatokombi
AKB_ESD=/tsd/etc/persistence/esd

# File size, empty when the file is missing
akb_size() { ls -la "$1" 2>/dev/null | awk '{print $5}'; }

akb_dm_installed() { grep -q 'libkb_dm.so' $AKB_CPU 2>/dev/null; }

akb_dm_remove() {
	if ! akb_dm_installed; then
		if [ -f $AKB_DM_LIB ]; then
			rm -f $AKB_DM_LIB
			echo "Removed $AKB_DM_LIB (cpu.conf did not name it)."
		fi
		return 0
	fi
	sed 's#:/tsd/lib/aatokombi/libkb_dm.so##g' $AKB_CPU > $AKB_CPU.new
	if [ -s $AKB_CPU.new ] && ! grep -q 'libkb_dm.so' $AKB_CPU.new; then
		chmod 644 $AKB_CPU.new
		mv -f $AKB_CPU.new $AKB_CPU
		rm -f $AKB_DM_LIB
		echo "DisplayManager hook (libkb_dm.so) removed from cpu.conf."
		return 0
	fi
	rm -f $AKB_CPU.new
	echo "WARNING: could not take libkb_dm.so out of $AKB_CPU; the library stays in place."
	echo "Restore by hand over telnet: cp $AKB_VAR/cpu.conf.stock $AKB_CPU"
	return 1
}

akb_dm_install() {
	typeset SRC="$1" CHK=/dev/shmem/aatokombi-dm.check DMBIN= x N
	if ! grep -q '^service iMX6.DispMg' $AKB_CPU; then
		echo "No iMX6.DispMg service in $AKB_CPU: libkb_dm.so does not fit this firmware."
		return 1
	fi
	if grep -q 'mst2-cluster-nav' $AKB_CPU; then
		echo "mst2-cluster-nav is installed: it hooks the same DisplayManager functions."
		return 1
	fi
	mkdir -p $AKB_LIBDIR $AKB_VAR
	[ -f $AKB_VAR/cpu.conf.stock ] || cp $AKB_CPU $AKB_VAR/cpu.conf.stock

	cp -f "$SRC" $AKB_DM_LIB.new 2>&1
	chmod a+rx $AKB_DM_LIB.new
	if [ -z "$(akb_size $AKB_DM_LIB.new)" ] || [ "$(akb_size "$SRC")" != "$(akb_size $AKB_DM_LIB.new)" ]; then
		rm -f $AKB_DM_LIB.new
		echo "libkb_dm.so did not copy."
		return 1
	fi

	# Self check: the copy is loaded into a harmless process with KB_DM_CHECK set and writes one
	# line to $CHK - which exists only if the library could be loaded here - saying whether this
	# unit's libOpenMAXAL and DisplayManager are the builds the hook knows (kb_dm_check in dm_hook.c).
	for x in $(sed -n '/^service iMX6.DispMg/,/^service /{s/^ *command  *\([^ ]*\).*/\1/p;}' $AKB_CPU); do
		DMBIN=$x; break
	done
	rm -f $CHK
	LD_PRELOAD=$AKB_DM_LIB.new KB_DM_CHECK=1 KB_DM_BIN="$DMBIN" ls /dev/null >/dev/null 2>&1
	if [ ! -s $CHK ]; then
		rm -f $AKB_DM_LIB.new
		echo "Self check: no result - libkb_dm.so cannot be loaded on this unit"
		echo "(as a preload it would keep DisplayManager from starting)."
		return 1
	fi
	echo "Self check (DisplayManager: ${DMBIN:-not found in cpu.conf}):"
	sed -n p $CHK
	if grep -q 'omx=differs' $CHK; then
		rm -f $AKB_DM_LIB.new
		echo "libOpenMAXAL on this unit is not the build the hook knows: it would replace nothing."
		return 1
	fi
	grep -q 'omx=unknown' $CHK && echo "note: libOpenMAXAL not visible from here; the hook checks it again inside DisplayManager"
	grep -q 'most=ok' $CHK || echo "note: MostSink call site not confirmed: the MOST ring is not waited for (pass-through mode only)"
	grep -q 'mmr=ok' $CHK || echo "note: mm-renderer client not confirmed: decode mode (the default) may not work"

	mv -f $AKB_DM_LIB.new $AKB_DM_LIB
	# a new build starts with a clean crash guard
	rm -f $AKB_VAR/video-off $AKB_VAR/dm-strikes $AKB_VAR/dm-busy

	if sed -n '/^service iMX6.DispMg/,/^service /p' $AKB_CPU | grep -q 'libkb_dm.so'; then
		echo "cpu.conf already preloads libkb_dm.so; library updated."
		return 0
	fi
	sed '/^service iMX6.DispMg/,/^service /s#^\(   envar LD_PRELOAD .*\)$#\1:'"$AKB_DM_LIB"'#' $AKB_CPU > $AKB_CPU.new
	N=$(sed -n '/^service iMX6.DispMg/,/^service /p' $AKB_CPU.new | grep -c 'libkb_dm.so')
	if [ "$N" != "1" ] || [ ! -s $AKB_CPU.new ]; then
		rm -f $AKB_CPU.new
		rm -f $AKB_DM_LIB
		echo "Could not edit cpu.conf (found $N), it is unchanged."
		return 1
	fi
	chmod 644 $AKB_CPU.new
	mv -f $AKB_CPU.new $AKB_CPU
	echo "cpu.conf: DisplayManager preloads $AKB_DM_LIB"
	sed -n '/^service iMX6.DispMg/,/^service /p' $AKB_CPU | grep LD_PRELOAD
	return 0
}

akb_menu_remove() {
	rm -f $AKB_ESD/aatokombi*.esd $AKB_ESD/scripts/aatokombi_*.sh
	return 0
}

akb_menu_install() {
	typeset DIR="$1" f n=0
	for f in "$DIR"/aatokombi*.esd; do
		[ -f "$f" ] || continue
		cp -f "$f" $AKB_ESD/ 2>&1
		n=$((n + 1))
	done
	if [ $n = 0 ]; then
		echo "No aatokombi*.esd in $DIR."
		return 1
	fi
	# a script that is gone from the new menu must not stay behind
	rm -f $AKB_ESD/scripts/aatokombi_*.sh
	for f in "$DIR"/scripts/aatokombi_*.sh; do
		[ -f "$f" ] || continue
		cp -f "$f" $AKB_ESD/scripts/ 2>&1
		chmod a+rx "$AKB_ESD/scripts/${f##*/}"
	done
	echo "AAtoKombi menu installed ($n screen file(s))."
	return 0
}
