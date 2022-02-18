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

# Search toolbox folder on all available volumes
for i in /media/mp00*; do
	if [ -d $i$TOOLBOX_FOLDER ]; then
		VOLUME=$i
		echo "Toolbox is found on $VOLUME"
		break
	fi
done

DESTINATION=""
ESD_FOLDER=/tsd/etc/persistence/esd
if [ -z "$VOLUME" ]; then
	for i in /fs/*; do
		if [ -d "$i$TOOLBOX_FOLDER" ]; then
			VOLUME=$i
			break
		fi
	done
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
	if [ -n "$VOLUME" ]; then
		for k in /fs/*; do
			if [ -d $k$ESD_FOLDER ]; then
				DESTINATION=$k
				break
			fi
		done
		
		if [ -z "$DESTINATION" ]; then
			# Try /dev/sdcard method by EvaldasL patcher
			if [ -d "/emmc$ESD_FOLDER" ]; then
				DESTINATION=/emmc
			fi
		fi
	fi
fi

if [ -z $VOLUME ]; then
	echo "ERROR: No SD card or USB drive with toolbox folder were found"
	exit 1
fi

echo "Toolbox is found on $VOLUME"
echo "Destination is: $DESTINATION$ESD_FOLDER"
echo "Sounds that logical? Press ENTER to continue or CTRL+C to abort"
read



if [ -d "$DESTINATION$ESD_FOLDER" ]; then
	if [ -z "$DESTINATION" ]; then
		# Mount system volume in read/write mode
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
	cp -r $VOLUME$TOOLBOX_FOLDER/* $DESTINATION/tsd/etc/persistence/esd
	echo "Done."

	echo "Setting execution attributes to scripts..."
	chmod a+rwx $DESTINATION/tsd/etc/persistence/esd/scripts/*.sh
	echo "Done."

	# Upgrage GEM 3.4/3.5 to 4.3 if found
	GEM_SIZE=$(ls -la "$DESTINATION/tsd/hmi/HMI/jar/GEM.jar" | awk '{print $5}' 2>/dev/null)
	if [[ "$GEM_SIZE" = "187047" || "$GEM_SIZE" = "187234" ]]; then
		echo "Old GEM is found. Updating to version 4.3..."
		cp -fv $VOLUME/toolbox/gem/cpu/onlineservices/1/default/tsd/bin/system/GEM.jar $DESTINATION/tsd/hmi/HMI/jar/GEM.jar
		echo "GEM update is finished."
	fi

	sync

	if [ -z "$DESTINATION" ];then
		# Mount system volume in read/only mode
		echo "Mounting system volume in read/only mode"
		mount -t qnx6 -o remount,ro /dev/hd0t177 /
	fi
	echo
	echo "Installation of the toolbox is done. Now you can open Green Engineering Menu :)"
else
	echo
	echo "ERROR: $DESTINATION$ESD_FOLDER is not found."
fi
