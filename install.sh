#!/bin/ksh
# This script installs esd files and scripts of the toolbox
# Coded by Olli

echo "This script will inject mibstd2_toolbox to Green Engineering Menu"
echo

TOOLBOX_FOLDER=/cpu/onlineservices/1/default/tsd/etc/persistence/esd
VOLUME=""

# Search toolbox folder on all available volumes
for i in /media/mp00*; do
	if [ -d $i$TOOLBOX_FOLDER ]; then
		VOLUME=$i
		echo "Toolbox is found on $VOLUME"
		break
	fi
done

if [ -z $VOLUME ]; then
	echo "ERROR: No SD card or USB drive with toolbox folder were found"
	exit 1
fi

# Mount system volume in read/write mode
echo "Mounting system volume in read/write mode"
mount -t qnx6 -o remount,rw /dev/hd0t177 /

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
echo "Copying of toolbox Green Engineering Menu screens and scripts is done."

echo "Setting execution attributes to scripts..."
chmod a+rwx /tsd/etc/persistence/esd/scripts/*.sh
echo "Setting execution attributes to scripts is done."

# Upgrage GEM 3.5 to 4.3 if found
if [[ $(ls -la "/tsd/hmi/HMI/jar/GEM.jar" | awk '{print $5}') == "187234" ]]; then
	echo "GEM 3.5 is found. Updating to version 4.3..."
	cp -v -f $VOLUME/toolbox/gem/cpu/onlineservices/1/default/tsd/bin/system/GEM.jar /tsd/hmi/HMI/jar/GEM.jar
	echo "GEM update is finished."
fi

sync
# Mount system volume in read/only mode
echo "Mounting system volume in read/only mode"
mount -t qnx6 -o remount,ro /dev/hd0t177 /

echo
echo "Installation of the toolbox is done. Now you can open Green Engineering Menu :)"
