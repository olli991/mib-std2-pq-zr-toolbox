#!/bin/ksh
# This script will dump all. Based on the script from MIB High Toolbox by Jille
# Modified for MIB2STD toolbox by Olli

#info
DESCRIPTION="This script will dump everything to SD card"

echo $DESCRIPTION
echo 
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later
. /tsd/scripts/util_checksd.sh
if [[ -z "$VOLUME" ]] 
then
	echo "No SD card found, quitting"
	exit 0
fi

#Make dump folders
DUMPPATH=$VOLUME/dump/

echo "Creating dump folders on SD card"
/bin/mkdir -p $DUMPPATH
echo 

# Include all dump scripts
echo "Dumping, please wait..."
sleep 1

# System dump scripts
echo "Dumping SWAP file"
. /tsd/scripts/dump_swap.sh > /dev/null & wait $!
sleep 1
echo "SWAP file dump done"

echo "Dumping SWDL file"
. /tsd/scripts/dump_swdl.sh > /dev/null & wait $!
sleep 1
echo "SWDL file dump done"

echo "Dumping HMI file"
. /tsd/scripts/dump_hmi.sh > /dev/null & wait $!
sleep 1
echo "HMI file dump done"

echo "Dumping Mirrorlink config file"
. /tsd/scripts/dump_mirrorlink.sh > /dev/null & wait $!
sleep 1
echo "Mirrorlink config file dump done"

echo "Dumping Navigation config file"
. /tsd/scripts/dump_nav.sh > /dev/null & wait $!
sleep 1
echo "Navigation config file dump done"

# Done
echo 
echo "All dumps done. You can now start tweaking the dumped stuff!"

exit 0
