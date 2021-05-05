#!/bin/ksh
# This script is meant to recover all skin mcf files
# author: Jille
# Modified by Olli for MIB STD2 Toolbox
########################
export TOPIC=skins
export MIBPATH=/tsd/hmi/Resources
export TYPE="file"

echo "This script will recover the skinfiles and ambienceColorMaps from backup"
echo

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Restore file(s) to unit
BACKUP=$VOLUME/backup/$TOPIC

# Mount system as read/write
. /tsd/etc/persistence/esd/scripts/util_mount.sh

echo "Copying all skin files from backup folder to the unit, please wait..."

RESTORE=no

for i in 0 1 2 3 4 5 6
do
	if [ -f $BACKUP/skin$i/images.mcf ]; then
		cp $BACKUP/skin$i/images.mcf $MIBPATH/skin$i/images.mcf
		echo "Skin$i is restored"
		RESTORE=yes
	else
		echo "No skin$i backup found"
fi
done

echo
echo "Copying all ambience files from backup folder to the unit, please wait..."
for i in 1 2 3 4 5 6
do
if [ -f $BACKUP/skin$i/ambienceColorMap.res ]; then
	cp $BACKUP/skin$i/ambienceColorMap.res $MIBPATH/skin$i/ambienceColorMap.res
	echo "Skin$i ambienceColorMap is restored"
	RESTORE=yes
else
	echo "No skin$i ambienceColorMap backup is found"
fi
done

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
if [ "$RESTORE" == "yes" ]; then
	echo "Done. Please restart the unit"
else
	echo "No backups found. Nothing to restore"
fi

exit 0
