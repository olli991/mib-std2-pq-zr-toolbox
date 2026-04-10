#!/bin/ksh
# This script restores all skin *.mcf and ambience color map *.res files from the backup
# Author: Jille
# Modified by Olli for MIB STD2 Toolbox
########################
echo "This script will restore skins and ambienceColorMap files from the backup"
echo

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Mount system in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

# Include info utility
. /tsd/etc/persistence/esd/scripts/util_info.sh

MIBPATH=/tsd/hmi/Resources

# Restore file(s) to unit
echo "Copying all skin files from backup folder to the unit, please wait..."
for i in $VOLUME/backup/$TRAIN/$SERIAL/skins/skin*; do
	#Extract skin folder name
	FOLDER=${i##*/}
	if [ -f $i/images.mcf ]; then
		cp -f $i/images.mcf $MIBPATH/$FOLDER/images.mcf
		echo "images.mcf of $FOLDER is restored"
		RESTORE=yes
	fi
	if [ -f $i/ambienceColorMap.res ]; then
		cp -f $i/ambienceColorMap.res $MIBPATH/$FOLDER/ambienceColorMap.res
		echo "ambienceColorMap of $FOLDER is restored"
		RESTORE=yes
	fi
	if [ -d $i/i18n ]; then
		cp -rf "$i/i18n/." "$MIBPATH/$FOLDER/i18n/"
		echo "Text resources of $FOLDER are restored"
		RESTORE=yes
	fi
done

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
if [ -n "$RESTORE" ]; then
	echo "Done. Please restart the unit"
else
	echo "No backups found. Nothing to restore"
fi

exit 0
