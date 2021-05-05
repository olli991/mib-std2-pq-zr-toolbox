#!/bin/ksh
export TOPIC=devesd
export MIBPATH=/tsd/etc/persistence/esd
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will copy developer Green Engineering Menus"
echo

# Make backup
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh

echo "Removing redundant Green Engineering Menu screens"
if [ -f $MIBPATH/VW_V01_Debugging.esd ]; then
	echo "VW_V01_Debugging.esd devmenu found, removing reduced menu"
	rm -v $MIBPATH/VW_Debugging_red_V02.esd
fi
if [ -f $MIBPATH/VW_V01_Engineering.esd ]; then
	echo "VW_V01_Engineering.esd devmenu found, removing reduced menu"
	rm -v $MIBPATH/VW_Engineering_red_V04.esd
fi
if [ -f $MIBPATH/VW_Main.esd ]; then
	echo "VW_Main.esd devmenu found, removing reduced menu"
	rm -v $MIBPATH/VW_Main_red.esd
fi

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo "Developer menus are copied. Please reopen Green Engineering Menu"
exit 0