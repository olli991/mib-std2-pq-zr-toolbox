#!/bin/ksh
export TOPIC=swdownload
export MIBPATH=/tsd/var/swdownload
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will keep only non duplicated FW updates in SWDL menu"
echo

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh

LAST_NUM=1
LAST_VER=""
CHANGES=""
i=0
echo "Processing..."
while [ $i -ne 99 ]; do 
	i=$((i+1))
	FILE=$MIBPATH/swdlhistory/swdownload$i.conf
	if [ -f $FILE ]; then
		VER=$(awk '/ReleaseName/{if ($NF) print $NF;}' $FILE 2>/dev/null | grep 'MST2_')
		if [ -n "$VER" ]; then
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

if [ -n "$CHANGES" ]; then
	if [ -f $MIBPATH/swdlhistory/swdownload1.conf ]; then
		echo "Copying last to current..."
		cp -f $MIBPATH/swdlhistory/swdownload1.conf $MIBPATH/.swdownload.conf
	else
		echo "Copying current to last..."
		cp -f $MIBPATH/.swdownload.conf $MIBPATH/swdlhistory/swdownload1.conf
	fi
elif [ -f $MIBPATH/swdlhistory/swdownload1.conf ]; then
	if [ -n "$(cmp $MIBPATH/.swdownload.conf $MIBPATH/swdlhistory/swdownload1.conf)" ]; then
		echo "Copying last to current because of differences..."
		cp -f $MIBPATH/swdlhistory/swdownload1.conf $MIBPATH/.swdownload.conf
		CHANGES=1
	fi
fi

TRAIN=$(awk '/46924065 401 25/ {print $4}' /tsd/var/persistence/.persistence.vault 2>/dev/null | sed 's/[^[:print:]]//g')
if [ -z "$(cat $MIBPATH/.swdownload.conf | grep $TRAIN)" ]; then
	echo "Fixing error 1556..."
	sed -i "s/\(ReleaseName[[:space:]]*=[[:space:]]*\)\(.*\)/\1${TRAIN}\r/" $MIBPATH/.swdownload.conf
	TRAIN=$(echo "$TRAIN"|awk -F'_' '{gsub(/[^[:digit:]]/, "", $5);print $5}' 2>/dev/null)
	sed -i "s/\(MuVersion[[:space:]]*=[[:space:]]*\)\(.*\)/\1${TRAIN}\r/" $MIBPATH/.swdownload.conf
	TRAIN=$(cat $MIBPATH/.swdownload.conf|awk '/online/{getline;getline;printf "%d",$3}' 2>/dev/null)
	sed -i "s/TargetVersion = 1157/TargetVersion = ${TRAIN}/" $MIBPATH/.swdownload.conf
	sed -i "s/UpdateStatus = 14/UpdateStatus = 4/" $MIBPATH/.swdownload.conf
	sed -i "s/UpdateResult = 2/UpdateStatus = 1/" $MIBPATH/.swdownload.conf
	cp -f $MIBPATH/.swdownload.conf $MIBPATH/swdlhistory/swdownload1.conf
fi

echo
if [ -n "$CHANGES" ]; then
	sync
	echo "Done. Please reboot the unit to apply changes."
else
	echo "Done. Nothing was changed"
fi

exit 0