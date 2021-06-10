#!/bin/ksh
echo "This script will install custom skins (images.mcf) and/or"
echo "ambienceColorMap.res from custom/skins folder"
echo

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

export TYPE="file"
WRITE=""
SOURCE=$VOLUME

# Copy custom file(s) to unit
echo "Checking changes, please wait..."
for i in $SOURCE/custom/skins/skin*; do
	#Extract skin folder name
	FOLDER=${i##*/}
	if [ -f $i/images.mcf ]; then
		export MIBPATH=/tsd/hmi/Resources/$FOLDER/images.mcf
		if [ -n "$(cmp $i/images.mcf $MIBPATH)" ]; then
			export TOPIC=skins/$FOLDER
			export SDPATH=$TOPIC/images.mcf
			# Make backup
			. /tsd/etc/persistence/esd/scripts/util_backup.sh
			if [ -z "$WRITE" ]; then
				# Mount system partition in read/write mode
				. /tsd/etc/persistence/esd/scripts/util_mount.sh
				WRITE=1
			fi
			echo "Replacing $FOLDER/images.mcf..."
			cp -f $i/images.mcf $MIBPATH
			echo "Done."
		fi
	fi
	if [ -f $i/ambienceColorMap.res ]; then
		export MIBPATH=/tsd/hmi/Resources/$FOLDER/ambienceColorMap.res
		if [ -n "$(cmp $i/ambienceColorMap.res $MIBPATH)" ]; then
			export TOPIC=skins/$FOLDER
			export SDPATH=$TOPIC/ambienceColorMap.res
			# Make backup
			. /tsd/etc/persistence/esd/scripts/util_backup.sh
			if [ -z "$WRITE" ]; then
				# Mount system partition in read/write mode
				. /tsd/etc/persistence/esd/scripts/util_mount.sh
				WRITE=1
			fi
			echo "Replacing $FOLDER/ambienceColorMap.res..."
			cp -f $i/ambienceColorMap.res $MIBPATH
			echo "Done."
		fi
	fi
done

if [ -n "$WRITE" ]; then
	# Mount system partition in read/only mode
	. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
	echo
	echo "Done. Please restart the unit."
else
	echo
	echo "Done. No new skins/ambienceColorMaps were found."
fi
exit 0