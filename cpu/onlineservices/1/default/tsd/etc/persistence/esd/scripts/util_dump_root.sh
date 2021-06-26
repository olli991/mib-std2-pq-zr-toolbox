#!/bin/ksh

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

#Make dump folder
DUMPFOLDER=$VOLUME/dump/$VERSION/$SERIAL/$TOPIC

#Make dump folder if needed
if [ ! -d "$DUMPFOLDER" ]; then
        echo "Making $DUMPFOLDER..."
        mkdir -p $DUMPFOLDER
fi

echo "Listing files..."
echo "Root:" >${DUMPFOLDER}/root.txt
ls -al ${MIBPATH}/ >>${DUMPFOLDER}/root.txt 2>/dev/null
echo >>${DUMPFOLDER}/root.txt
echo "/dev" >>${DUMPFOLDER}/root.txt
ls -al ${MIBPATH}/dev/ >>${DUMPFOLDER}/root.txt
if [ -d "$MIBPATH/net" ]; then
        echo >>${DUMPFOLDER}/root.txt
        echo "/net" >>${DUMPFOLDER}/root.txt
        ls -al ${MIBPATH}/net >>${DUMPFOLDER}/root.txt
fi
for d in ${MIBPATH}/{,.}*; do
        if [[ "$d" != "$MIBPATH/cdrom" && "$d" != "$MIBPATH/.*" && "$d" != "$MIBPATH/." && "$d" != "$MIBPATH/.." && "$d" != "$MIBPATH/cpu" && "$d" != "$MIBPATH/dev" && "$d" != "$MIBPATH/media" && "$d" != "$MIBPATH/net" && "$d" != "$MIBPATH/proc" && "$d" != "$MIBPATH/tmp" ]]; then
                echo "Dumping $d"
                cp -rfL ${d} ${DUMPFOLDER} 2>/dev/null
        fi
done
sync
echo
echo "Done. Saved at $DUMPFOLDER"
exit 0