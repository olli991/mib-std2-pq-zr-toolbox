#!/bin/sh
# Info
export TOPIC=devesd
export MIBPATH=/tsd/etc/persistence/esd
export SDPATH=$TOPIC
export TYPE="folder"
DESCRIPTION="This script will copy developer GreenMenus"

echo $DESCRIPTION
echo
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Make backup folder
. /tsd/etc/persistence/esd/scripts/util_backup.sh
sleep 1

# Copy file(s) to unit
. /tsd/etc/persistence/esd/scripts/util_copy.sh

echo "Removing redundant GreenMenu screens"
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
sleep 1

echo "Developer GreenMenus copied. Please restart GreenMenu"

exit 0
