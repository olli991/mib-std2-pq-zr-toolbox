#!/bin/ksh
export TOPIC=swdlhistory
export MIBPATH=/tsd/var/swdownload/swdlhistory
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will keep only non duplicated FW updates in SWDL menu"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Clean SWDL history
LAST_NUM=1
LAST_VER=""
CHANGES=""
i=0
echo "Processing..."
while [ $i -ne 99 ]; do 
	i=$((i+1))
	FILE=$MIBPATH/swdownload$i.conf
	if [ -f $FILE ]; then
		VER=$(awk '/ReleaseName/{if ($NF) print $NF;}' $FILE | grep 'MST2_')
		if [ -n "$VER" ]; then
			if [ -z $LAST_VER ]; then
				LAST_VER=$VER
			fi
			if [ "$LAST_VER" != "$VER" ]; then
				LAST_NUM=$((LAST_NUM+1))
				LAST_VER=$VER
			fi
			if [ "$FILE" != "$MIBPATH/swdownload$LAST_NUM.conf" ]; then
				mv -f $FILE $MIBPATH/swdownload$LAST_NUM.conf
				CHANGES=1
			fi
		else
			rm -f $FILE
			CHANGES=1
		fi
	fi
done

echo
if [ -n "$CHANGES" ]; then
sync
echo "Done. Please restart the unit to apply changes."
else
echo "Done. Nothing was changed"
fi

exit 0
