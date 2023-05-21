#!/bin/ksh
# This script installs esd files and scripts of the toolbox
# Coded by Olli and lprot

echo ' __  __ ___ ___   ___ _____ ___ ___   _____         _ _             '
echo '|  \/  |_ _| _ ) / __|_   _|   \_  ) |_   _|__  ___| | |__  _____ __'
echo '| |\/| || || _ \ \__ \ | | | |) / /    | |/ _ \/ _ \ |  _ \/ _ \ \ /'
echo '|_|  |_|___|___/ |___/ |_| |___/___|   |_|\___/\___/_|_.__/\___/_\_\'
echo
echo "This script will inject mibstd2_toolbox to Green Engineering Menu"
echo

TOOLBOX_FOLDER=/cpu/onlineservices/1/default/tsd/etc/persistence/esd
VOLUME=""
DESTINATION=""
ESD_FOLDER=/tsd/etc/persistence/esd

# Search toolbox folder
for i in /media/mp00*; do
	if [ -d "$i$TOOLBOX_FOLDER" ]; then
		VOLUME=$i
		break
	fi
done
if [ -z "$VOLUME" ]; then
	for i in /fs/*; do
		if [ -d "$i$TOOLBOX_FOLDER" ]; then
			VOLUME=$i
			break
		fi
	done
fi
if [ -z "$VOLUME" ]; then
	for i in /mnt/*; do
		if [ -d "$i$TOOLBOX_FOLDER" ]; then
			VOLUME=$i
			break
		fi
	done
fi
if [ -z "$VOLUME" ]; then
	if [ -d "/tmp$TOOLBOX_FOLDER" ]; then
		VOLUME="/tmp"
	fi
fi
if [ -z "$VOLUME" ]; then
	if [ -d "/dev/sdcard$TOOLBOX_FOLDER" ]; then
		VOLUME="/dev/sdcard"
	fi
fi
if [ -z "$VOLUME" ]; then
	echo "ERROR: Cannot find a drive with the Toolbox!"
	exit 1
fi
echo "Toolbox is found on $VOLUME"

for i in /fs/*; do
	if [ -d "$i$ESD_FOLDER" ]; then
		DESTINATION=$i
		break
	fi
done
if [ -z "$DESTINATION" ]; then
	if [ -d "/emmmc$ESD_FOLDER" ]; then
		DESTINATION=/emmmc
	fi
fi

if [ -d "$DESTINATION$ESD_FOLDER" ]; then
	echo "Destination is: $DESTINATION"
	if [ -z "$DESTINATION" ]; then
		echo "Mounting system volume in read/write mode"
		mount -t qnx6 -o remount,rw /dev/hd0t177 /
	fi

	# Clean before installation
	rm -f $DESTINATION/tsd/etc/persistence/esd/mib2std-*.esd
	rm -f $DESTINATION/tsd/etc/persistence/esd/mibstd2_yox.esd
	rm -f $DESTINATION/tsd/etc/persistence/esd/TOOLBOX.esd
	rm -f $DESTINATION/tsd/etc/persistence/esd/mib2std_yox.esd
	rm -rf $DESTINATION/tsd/scripts
	rm -f $DESTINATION/tsd/etc/persistence/esd/mibstd2-*.esd
	rm -rf $DESTINATION/tsd/etc/persistence/esd/scripts

	# Copy toolbox screens and scripts
	echo "Copying toolbox Green Engineering Menu screens and scripts..."
	cp -rf $VOLUME$TOOLBOX_FOLDER/* $DESTINATION/tsd/etc/persistence/esd
	echo "Done."

	echo "Setting execution attributes to scripts..."
	chmod a+rwx $DESTINATION/tsd/etc/persistence/esd/scripts/*.sh
	echo "Done."

	# Upgrage GEM 3.4/3.5/4.3 to 4.11 if found
	GEM_SIZE=$(ls -la "$DESTINATION/tsd/hmi/HMI/jar/GEM.jar" | awk '{print $5}' 2>/dev/null)
	if [[ "$GEM_SIZE" = "187047" || "$GEM_SIZE" = "187234" || "$GEM_SIZE" = "242383" ]]; then
		echo "Old GEM is found. Updating to version 4.11..."
		cp -fv $VOLUME/toolbox/gem/cpu/onlineservices/1/default/tsd/bin/system/GEM.jar $DESTINATION/tsd/hmi/HMI/jar/GEM.jar
		echo "GEM update is finished."
	fi
	sync
	if [ -z "$DESTINATION" ]; then
		echo "Mounting system volume in read/only mode"
		mount -t qnx6 -o remount,ro /dev/hd0t177 /
	fi
	echo
	echo "Installation of the toolbox is done. Now you can open Green Engineering Menu :)"
else
	echo "ERROR: $ESD_FOLDER is not found."
fi