#!/bin/ksh
# AAtoKombi "Dump files" — copy the TWO files needed to BUILD the mod for YOUR firmware to the SD:
#   * MIBHMI.jxe                       (HMI executable -> on your PC becomes MIBHMI.jar)
#   * libext.google.gal.receiver.so    (STOCK GAL library -> build the patched shim from it)
# and, for the DisplayManager hook libkb_dm.so (Android Auto map on the cluster), the files whose
# build it is tied to - it carries their addresses for one firmware build, so for another build
# they are what the addresses are taken from:
#   * cpu.conf (+ its stock copy), the DisplayManager binary, libOpenMAXAL.so.1, libtsd.common.so,
#     libmmrndclient.so.1
# Everything lands under dump/<train>/<serial>/ .
#
# MIBHMI.jxe is a real file on the unit (the JVM loads $IFSDIR/MIBHMI.jxe per runHMI.sh), so we
# copy it DIRECTLY. If for some unit it isn't found, we fall
# back to dumping the whole HMI image (tsd.mibstd2.hmi.ifs), which then needs dumpifs to unpack.

. /tsd/etc/persistence/esd/scripts/util_checksd.sh
. /tsd/etc/persistence/esd/scripts/util_info.sh

OUT=$VOLUME/dump/$TRAIN/$SERIAL
mkdir -p "$OUT/hmi" "$OUT/gal" "$OUT/dm"
echo "Dumping AAtoKombi build sources to: dump/$TRAIN/$SERIAL/"
echo

# --- HMI: prefer the MIBHMI.jxe file directly ---
JXE=/tsd/hmi/ifs/MIBHMI.jxe
HMI_IFS=/tsd/hmi/tsd.mibstd2.hmi.ifs
echo "== HMI =="
if [ -f "$JXE" ]; then
	echo "  + MIBHMI.jxe (direct)"
	cp -f "$JXE" "$OUT/hmi/MIBHMI.jxe" 2>&1
elif [ -f "$HMI_IFS" ]; then
	echo "  ! MIBHMI.jxe not found; dumping the whole HMI image instead."
	echo "    (you'll need dumpifs to extract MIBHMI.jxe from it)"
	cp -f "$HMI_IFS" "$OUT/hmi/tsd.mibstd2.hmi.ifs" 2>&1
else
	echo "  ! neither $JXE nor $HMI_IFS found — wrong platform?"
fi

# --- GAL: dump the STOCK libgal. If the mod is installed the LIVE file is the PATCHED one, so
#     prefer the .aatokombi.bak (that IS the stock copy); fall back to the live file otherwise. ---
GAL=/tsd/lib/sal/gal/libext.google.gal.receiver.so
GAL_BU=$GAL.aatokombi.bak
echo "== stock libgal =="
if [ -f "$GAL_BU" ]; then
	echo "  source: $GAL_BU  (mod installed -> .bak is the stock copy)"
	cp -f "$GAL_BU" "$OUT/gal/libext.google.gal.receiver.so" 2>&1
elif [ -f "$GAL" ]; then
	echo "  source: $GAL  (mod not installed -> live file is stock)"
	cp -f "$GAL" "$OUT/gal/libext.google.gal.receiver.so" 2>&1
else
	echo "  ! MISSING: $GAL"
fi

# --- DisplayManager and the libraries the libkb_dm.so hook depends on ---
CPU=/tsd/etc/system/cpu.conf
CPU_STOCK=/tsd/var/aatokombi/cpu.conf.stock
echo "== DisplayManager (for libkb_dm.so) =="
DMBIN=
LIBPATH=
rm -f "$OUT/dm/PATHS.txt"
if [ -f "$CPU" ]; then
	cp -f "$CPU" "$OUT/dm/cpu.conf" 2>&1
	# cpu.conf.stock is the copy from before the hook was installed
	[ -f "$CPU_STOCK" ] && cp -f "$CPU_STOCK" "$OUT/dm/cpu.conf.stock" 2>&1
	for x in $(sed -n '/^service iMX6.DispMg/,/^service /{s/^ *command  *\([^ ]*\).*/\1/p;}' $CPU); do
		DMBIN=$x; break
	done
	for x in $(sed -n '/^service iMX6.DispMg/,/^service /{s/^ *envar  *LD_LIBRARY_PATH  *\([^ ]*\).*/\1/p;}' $CPU); do
		LIBPATH=$(echo $x | sed 's/:/ /g'); break
	done
else
	echo "  ! MISSING: $CPU"
fi
if [ -n "$DMBIN" ] && [ -f "$DMBIN" ]; then
	echo "  + ${DMBIN##*/} ($DMBIN)"
	cp -f "$DMBIN" "$OUT/dm/${DMBIN##*/}" 2>&1
else
	echo "  ! DisplayManager binary not found (service iMX6.DispMg in cpu.conf: '$DMBIN')"
fi
# a library: first in the service's LD_LIBRARY_PATH, then in the usual places, then a search
# that stays off /net and /media
for LIB in libOpenMAXAL.so.1 libtsd.common.so libmmrndclient.so.1; do
	F=
	for d in $LIBPATH /lib /usr/lib /lib/dll /tsd/lib /usr/lib/graphics/imx6x; do
		if [ -f "$d/$LIB" ]; then F=$d/$LIB; break; fi
	done
	[ -n "$F" ] || F=$(find /lib /usr /tsd/lib /tsd/bin -name "$LIB" 2>/dev/null | head -1)
	if [ -n "$F" ] && [ -f "$F" ]; then
		echo "  + $LIB ($F)"
		cp -f "$F" "$OUT/dm/$LIB" 2>&1
		echo "$LIB $F" >> "$OUT/dm/PATHS.txt"
	else
		echo "  ! MISSING: $LIB"
	fi
done
[ -n "$DMBIN" ] && echo "displaymanager $DMBIN" >> "$OUT/dm/PATHS.txt"

# fingerprint so you can tell later which files a build was made from
cksum "$OUT/gal/libext.google.gal.receiver.so" > "$OUT/STOCK_INFO.txt" 2>&1
for f in "$OUT"/dm/*; do
	case "$f" in *.txt|*/cpu.conf*) continue ;; esac
	[ -f "$f" ] && cksum "$f" >> "$OUT/STOCK_INFO.txt" 2>&1
done
sync

echo
echo "Done."
exit 0
