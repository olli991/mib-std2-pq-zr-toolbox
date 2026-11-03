#!/bin/ksh
# AAtoKombi "Dump files" — copy the TWO files needed to BUILD the mod for YOUR firmware to the SD:
#   * MIBHMI.jxe                       (HMI executable -> on your PC becomes MIBHMI.jar)
#   * libext.google.gal.receiver.so    (STOCK GAL library -> build the patched shim from it)
# Both land under dump/<train>/<serial>/ .
#
# MIBHMI.jxe is a real file on the unit (the JVM loads $IFSDIR/MIBHMI.jxe per runHMI.sh), so we
# copy it DIRECTLY. If for some unit it isn't found, we fall
# back to dumping the whole HMI image (tsd.mibstd2.hmi.ifs), which then needs dumpifs to unpack.

. /tsd/etc/persistence/esd/scripts/util_checksd.sh
. /tsd/etc/persistence/esd/scripts/util_info.sh

OUT=$VOLUME/dump/$TRAIN/$SERIAL
mkdir -p "$OUT/hmi" "$OUT/gal"
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

# fingerprint so you can tell later which libgal a build was made from
cksum "$OUT/gal/libext.google.gal.receiver.so" > "$OUT/STOCK_INFO.txt" 2>&1
sync

echo
echo "Done."
exit 0
