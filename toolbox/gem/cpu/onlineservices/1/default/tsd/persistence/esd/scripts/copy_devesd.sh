#!/bin/ksh
export TOPIC=greenmenu
export MIBPATH=/tsd/etc/persistence/esd
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will copy developer Green Engineering Menus"
echo

# Make backup
. /tsd/etc/persistence/esd/scripts/util_backup.sh

# Copy file(s) to unit
export TOPIC=devesd
export SDPATH=$TOPIC
. /tsd/etc/persistence/esd/scripts/util_copy.sh

if [ -f $MIBPATH/VW_V01_Debugging.esd ]; then
	echo "Removing reduced VW_Debugging_red_V02.esd menu..."
	rm -f $MIBPATH/VW_Debugging_red_V02.esd
fi
if [ -f $MIBPATH/VW_V01_Engineering.esd ]; then
	echo "Removing reduced VW_Engineering_red_V04.esd menu..."
	rm -f $MIBPATH/VW_Engineering_red_V04.esd
fi
if [ -f $MIBPATH/VW_Main.esd ]; then
	echo "Removing reduced VW_Main_red.esd menu..."
	rm -f $MIBPATH/VW_Main_red.esd
fi

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Done. Please reopen Green Engineering Menu"
exit 0