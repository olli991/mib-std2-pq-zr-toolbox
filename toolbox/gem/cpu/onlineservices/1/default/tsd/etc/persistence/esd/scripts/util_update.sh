#!/bin/ksh
echo "This script will update MIB STD2 PQ/ZR Toolbox from SD card or USB drive"
echo

TOOLBOX_FOLDER=/cpu/onlineservices/1/default/tsd/etc/persistence/esd 

unset VOLUME

# Search for toolbox distro on all available volumes
for i in /media/mp00*; do
	if [ -f $i$TOOLBOX_FOLDER/scripts/util_update.sh ]; then
		VOLUME=$i
		echo "Toolbox is found on $VOLUME"
		break
	fi
done 

if [ -z $VOLUME ]; then
	echo "ERROR: No SD card or USB drive with toolbox folder were found"
	exit 1
fi

mount -t qnx6 -o remount,rw /dev/hd0t177 /
echo "System partition is remounted in read/write mode"

# Clean before installation
rm -f /tsd/etc/persistence/esd/mib2std-*.esd
rm -f /tsd/etc/persistence/esd/mibstd2_yox.esd
rm -f /tsd/etc/persistence/esd/TOOLBOX.esd
rm -f /tsd/etc/persistence/esd/mib2std_yox.esd
rm -rf /tsd/scripts
rm -f /tsd/etc/persistence/esd/mibstd2-*.esd
rm -rf /tsd/etc/persistence/esd/scripts

# Copy toolbox screens and scripts
echo "Copying toolbox Green Engineering Menu screens and scripts..."
cp -r $VOLUME$TOOLBOX_FOLDER/* /tsd/etc/persistence/esd
echo "Done."
echo "Setting execution attributes to scripts..."
chmod a+rwx /tsd/etc/persistence/esd/scripts/*.sh
echo "Done."

sync
mount -t qnx6 -o remount,ro /dev/hd0t177 /
echo "System partition is remounted in read/only mode"

echo
echo "The update is completed. Please reopen Green Engineering Menu!"
exit 0
