#!/bin/ksh
echo "This script will install custom skins (images.mcf) and/or"
echo "ambienceColorMap.res from custom/skins folder"
echo

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

export TYPE="file"

# Copy custom file(s) to unit
echo "Copying files to the unit, please wait..."
for i in $VOLUME/custom/skins/skin*; do
	#Extract skin folder name
	FOLDER=${i##*/}
	if [ -f $i/images.mcf ]; then
		if [ -n "$(cmp $i/images.mcf $MIBPATH/$FOLDER/images.mcf)" ]; then
			export TOPIC=skins/$FOLDER
			export MIBPATH=/tsd/hmi/Resources/$FOLDER/images.mcf
			export SDPATH=$TOPIC/images.mcf
			# Make backup
			. /tsd/etc/persistence/esd/scripts/util_backup.sh
			cp -f $i/images.mcf $MIBPATH/$FOLDER/images.mcf
			echo "images.mcf of $FOLDER is replaced"
			COPIED=yes
		fi
	fi
	if [ -f $i/ambienceColorMap.res ]; then
		if [ -n "$(cmp $i/ambienceColorMap.res $MIBPATH/$FOLDER/ambienceColorMap.res)" ]; then
			export TOPIC=skins/$FOLDER
			export MIBPATH=/tsd/hmi/Resources/$FOLDER/ambienceColorMap.res
			export SDPATH=$TOPIC/ambienceColorMap.res
			# Make backup
			. /tsd/etc/persistence/esd/scripts/util_backup.sh
			cp -f $i/ambienceColorMap.res $MIBPATH/$FOLDER/ambienceColorMap.res
			echo "ambienceColorMap of $FOLDER is replaced"
			COPIED=yes
		fi
	fi
done

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
if [ -n $COPIED ]; then
	echo "Done. Please restart the unit."
else
	echo "Done. No new skins/ambienceColorMaps were found."
fi
exit 0