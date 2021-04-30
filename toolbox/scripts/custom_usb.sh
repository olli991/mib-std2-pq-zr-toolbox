#!/bin/ksh
# This script will run a custom script from USB
# By Olli

# Info
DESCRIPTION="This script will run a custom script called toolbox.sh from USB"

echo $DESCRIPTION
echo 
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

# Running script from USB
echo "Looking for custom toolbox.sh script on USB"
sleep 1

if [ -f $VOLUME/toolbox.sh ]; then
	echo "Script found at $VOLUME. Executing..."
	. $VOLUME/toolbox.sh & wait $!
	echo "Custom script finished"
else
	echo "Custom script not found. Aborting"
	exit 0
fi
