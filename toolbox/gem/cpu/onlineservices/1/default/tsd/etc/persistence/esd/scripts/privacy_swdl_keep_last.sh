#!/bin/ksh
export TOPIC=swdownload
export MIBPATH=/tsd/var/swdownload
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will keep only the last update in SWDL menu"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

LAST_NUM=1
LAST_VER=""
CHANGES=""
FOUND=""
i=0
echo "Processing..."
while [ $i -ne 99 ]; do 
	i=$((i+1))
	FILE=$MIBPATH/swdlhistory/swdownload$i.conf
	if [ -f $FILE ]; then
		VER=$(awk '/ReleaseName/{if ($NF) print $NF;}' $FILE 2>/dev/null | grep 'MST2_')
		if [[ -n $VER && -z $FOUND ]]; then
			FOUND=1
			if [ -z $LAST_VER ]; then
				LAST_VER=$VER
			fi
			if [ "$LAST_VER" != "$VER" ]; then
				LAST_NUM=$((LAST_NUM+1))
				LAST_VER=$VER
			fi
			if [ "$FILE" != "$MIBPATH/swdlhistory/swdownload$LAST_NUM.conf" ]; then
				mv -f $FILE $MIBPATH/swdlhistory/swdownload$LAST_NUM.conf
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
	if [ -f $MIBPATH/swdlhistory/swdownload1.conf ]; then
		echo "Copying last to current..."
		cp -f $MIBPATH/swdlhistory/swdownload1.conf $MIBPATH/.swdownload.conf
	else
		echo "Copying current to last..."
		cp -f $MIBPATH/.swdownload.conf $MIBPATH/swdlhistory/swdownload1.conf
	fi
	sync
	echo "Done. Please restart the unit to apply changes."
elif [ -f $MIBPATH/swdlhistory/swdownload1.conf ]; then
	if [ -n "$(cmp $MIBPATH/.swdownload.conf $MIBPATH/swdlhistory/swdownload1.conf)" ]; then
		echo "Copying last to current because of differences..."
		cp -f $MIBPATH/swdlhistory/swdownload1.conf $MIBPATH/.swdownload.conf
		sync
		echo "Done. Please reboot the unit to apply changes."
	else
		echo "Done. Nothing was changed"
	fi
else 
	echo "Done. Nothing was changed"
fi

exit 0