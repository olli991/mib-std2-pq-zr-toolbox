#!/bin/ksh
echo "This script will install /custom/skins (images.mcf),"
echo "ambienceColorMap.res and/or all text resources"
echo "(like en_GB.res) from /custom/skins folder"
echo "If /custom/skins contains new skin folders, they will be"
echo "copied into /tsd/hmi/Resources/"
echo

# Locate Toolbox drive
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

export TYPE="file"
WRITE=""

# Copy custom file(s) to unit
echo "Checking changes, please wait..."
for skin_folder in $VOLUME/custom/skins/skin*; do
	#Extract skin folder name
	FOLDER=${skin_folder##*/}
	if [ -f $skin_folder/images.mcf ]; then
		export MIBPATH=/tsd/hmi/Resources/$FOLDER/images.mcf
		if [ -n "$(cmp $skin_folder/images.mcf $MIBPATH 2>/dev/null)" ]; then
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
			cp -f $skin_folder/images.mcf $MIBPATH 2>&1
			echo "Done."
		fi
	fi
	if [ -f $skin_folder/ambienceColorMap.res ]; then
		export MIBPATH=/tsd/hmi/Resources/$FOLDER/ambienceColorMap.res
		if [ -n "$(cmp $skin_folder/ambienceColorMap.res $MIBPATH 2>/dev/null)" ]; then
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
			cp -f $skin_folder/ambienceColorMap.res $MIBPATH 2>&1
			echo "Done."
		fi
	fi
	if [ -f $skin_folder/info.txt ]; then
		export MIBPATH=/tsd/hmi/Resources/$FOLDER/info.txt
		if [ -n "$(cmp $skin_folder/info.txt $MIBPATH 2>/dev/null)" ]; then
			export TOPIC=skins/$FOLDER
			export SDPATH=$TOPIC/info.txt
			# Make backup
			. /tsd/etc/persistence/esd/scripts/util_backup.sh
			if [ -z "$WRITE" ]; then
				# Mount system partition in read/write mode
				. /tsd/etc/persistence/esd/scripts/util_mount.sh
				WRITE=1
			fi
			echo "Replacing $FOLDER/info.txt..."
			cp -f $skin_folder/info.txt $MIBPATH 2>&1
			echo "Done."
		fi
	fi
	TEXT_RESOURCES=$(find $skin_folder -type f -name "[a-z][a-z]_[A-Z][A-Z].res")
	if [ -n "$TEXT_RESOURCES" ]; then
		for text_resource in $TEXT_RESOURCES; do
			RESOURCE="${text_resource##*/}"
			export MIBPATH="/tsd/hmi/Resources/$FOLDER/i18n/$RESOURCE"
			if [ -n "$(cmp $skin_folder/$RESOURCE $MIBPATH 2>/dev/null)" ]; then
				export TOPIC=skins/$FOLDER/i18n
				export SDPATH=$TOPIC/$RESOURCE
				# Make backup
				. /tsd/etc/persistence/esd/scripts/util_backup.sh
				if [ -z "$WRITE" ]; then
					# Mount system partition in read/write mode
					. /tsd/etc/persistence/esd/scripts/util_mount.sh
					WRITE=1
				fi
				echo "Replacing $FOLDER/i18n/$RESOURCE..."
				cp -f $skin_folder/$RESOURCE $MIBPATH 2>&1
				echo "Done."
			fi
		done
	fi	
	if [ ! -d /tsd/hmi/Resources/$FOLDER ]; then
		if [ -z "$WRITE" ]; then
			# Mount system partition in read/write mode
			. /tsd/etc/persistence/esd/scripts/util_mount.sh
			WRITE=1
		fi
		echo "Copying new $FOLDER..."
		cp -rf $skin_folder /tsd/hmi/Resources/ 2>&1
		echo "Done."
	fi
done

#replace skins in MIB with skins from /custom/skins/replace
for skin_folder in $VOLUME/custom/skins/replace/skin*; do
	#Extract skin folder name
	FOLDER=${skin_folder##*/}
	if [ -d /tsd/hmi/Resources/$FOLDER ]; then
		export MIBPATH=/tsd/hmi/Resources/$FOLDER
		export TOPIC=skins/$FOLDER
		export SDPATH=$TOPIC
		export TYPE="folder" 
		# Make backup
		. /tsd/etc/persistence/esd/scripts/util_backup.sh
		if [ -z "$WRITE" ]; then
			# Mount system partition in read/write mode
			. /tsd/etc/persistence/esd/scripts/util_mount.sh
			WRITE=1
		fi
		echo "Deleting /tsd/hmi/Resources/$FOLDER..."
		rm -rf /tsd/hmi/Resources/$FOLDER 2>&1
		echo "Replacing with $skin_folder..."
		cp -rf $skin_folder /tsd/hmi/Resources/ 2>&1
		echo "Done."
	fi
done

if [ -n "$WRITE" ]; then
	# Mount system partition in read/only mode
	. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh
	echo
	echo "Done. Please restart the unit."
else
	echo
	echo "Done. No new texts/skins/ambienceColorMaps were found."
fi
exit 0