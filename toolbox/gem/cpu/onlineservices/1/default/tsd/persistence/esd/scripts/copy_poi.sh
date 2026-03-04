#!/bin/ksh

echo "Installing Personal POI directly to unit's filesystem..."
echo

PATHTOPOI=/PersonalPOI/MIB2TSD/personalpoi

# --- Search SD with POI ---
for i in /media/mp00*; do
    if [[ -d "$i$PATHTOPOI/ppoidb/1/default" && -f "$i$PATHTOPOI/InfoFile/1/default/Update.txt" ]]; then
        SRC=$i$PATHTOPOI
        SDROOT=$i
        break
    fi
done

if [ -z "$SRC" ]; then
    echo "ERROR: Cannot find PersonalPOI on SD card!"
    exit 1
fi

LOGFILE="$SDROOT/poi.log"

echo "Source found at: $SRC"
echo "Log file: $LOGFILE"
echo

DBFILE="$SRC/ppoidb/1/default/poidata.db3"
ICONDIR="$SRC/ppoidb/1/default/icon"
UPDATEFILE="$SRC/InfoFile/1/default/Update.txt"

if [ ! -f "$DBFILE" ] || [ ! -d "$ICONDIR" ] || [ ! -f "$UPDATEFILE" ]; then
    echo "ERROR: Required files missing!"
    exit 1
fi

DST_DB="/tsd/var/nav/personalpoi"
DST_UPDATE="/tsd/etc/PoiUpdate.txt"

echo "Mounting /tsd in read-write mode..."
. /tsd/etc/persistence/esd/scripts/util_mount.sh

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to mount RW!"
    exit 1
fi

# --- Logging ---
echo "===== POI BEFORE UPDATE =====" > "$LOGFILE"
date >> "$LOGFILE"
echo >> "$LOGFILE"

echo "----- /tsd/etc content -----" >> "$LOGFILE"
ls -al /tsd/etc/PoiUpdate.txt >> "$LOGFILE" 2>&1
cat /tsd/etc/PoiUpdate.txt >> "$LOGFILE" 2>&1
echo >> "$LOGFILE"

echo "----- $DST_DB content -----" >> "$LOGFILE"
ls -alR "$DST_DB" >> "$LOGFILE" 2>&1
echo >> "$LOGFILE"

echo "----- SD source content -----" >> "$LOGFILE"
ls -alR "$SRC" >> "$LOGFILE" 2>&1
echo >> "$LOGFILE"

sync

# --- Copying ---
echo "Creating destination directories..."
mkdir -p "$DST_DB"

echo "Copying database..."
cp -f "$DBFILE" "$DST_DB/poidata.db3"

echo "Copying icons..."
cp -rf "$ICONDIR" "$DST_DB/"

echo "Copying update info..."
cp -f "$UPDATEFILE" "$DST_UPDATE"

echo "Setting permissions..."
chmod 777 "$DST_DB/poidata.db3"
chmod -R 777 "$DST_DB/icon"
chmod 777 "$DST_UPDATE"

sync

echo "Mounting /tsd back to read-only..."
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo >> "$LOGFILE"
echo "===== INSTALLATION COMPLETE =====" >> "$LOGFILE"
date >> "$LOGFILE"

# --- Logging ---
echo "===== POI AFTER UPDATE =====" > "$LOGFILE"
date >> "$LOGFILE"
echo >> "$LOGFILE"

echo "----- /tsd/etc content -----" >> "$LOGFILE"
ls -al /tsd/etc/PoiUpdate.txt >> "$LOGFILE" 2>&1
cat /tsd/etc/PoiUpdate.txt >> "$LOGFILE" 2>&1
echo >> "$LOGFILE"

echo "----- $DST_DB content -----" >> "$LOGFILE"
ls -alR "$DST_DB" >> "$LOGFILE" 2>&1
echo >> "$LOGFILE"

echo "----- SD source content -----" >> "$LOGFILE"
ls -alR "$SRC" >> "$LOGFILE" 2>&1
echo >> "$LOGFILE"

sync

echo
echo "Installation complete."
echo "Log saved to $LOGFILE"
echo "Reboot unit to apply changes."

exit 0