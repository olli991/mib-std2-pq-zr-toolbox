#!/bin/ksh
echo "This script will update MIB STD2 PQ/ZR Toolbox from SD card or USB drive"
echo

TOOLBOX_FOLDER=/cpu/onlineservices/1/default/tsd/etc/persistence/esd 

unset VOLUME

# Search for toolbox distro on all available volumes
for i in 0 1 2 3 4
do
	if [ -f /media/mp00$i$TOOLBOX_FOLDER/scripts/util_update.sh ]; then
		VOLUME=/media/mp00$i
		echo "Toolbox is found on" $VOLUME
		break
	fi
done 

if [ -z $VOLUME ]; then
	echo "ERROR: No SD card or USB drive with toolbox folder were found"
	exit 1
fi

mount -t qnx6 -o remount,rw /dev/hd0t177 /
echo "System partition is remounted in read/write mode"

# Copy toolbox screens and scripts
echo "Copying toolbox Green Engineering Menu screens and scripts..."
cp -r $VOLUME$TOOLBOX_FOLDER/* /tsd/etc/persistence/esd
echo "Copying of toolbox Green Engineering Menu screens and scripts is done."
echo "Setting execution attributes to scripts..."
chmod a+rwx /tsd/etc/persistence/esd/scripts/*.sh
echo "Setting execution attributes is done."

sync
mount -t qnx6 -o remount,ro /dev/hd0t177 /
echo "System partition is remounted in read/only mode"

echo
echo "The update is completed. Please reopen Green Engineering Menu!"
exit 0
